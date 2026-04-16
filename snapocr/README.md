# SnapOCR — Video Chat Screen Recording → Deduplicated Transcript

## What This Is

A self-contained Python application with a local web UI that takes a screen recording video (typically from a phone capturing a chat app like Snapchat, iMessage, WhatsApp, Instagram DMs, Discord, etc.), extracts all visible text frame-by-frame, deduplicates it using spatial and temporal heuristics, identifies speakers by bubble position/color, and outputs a clean, timestamped, searchable transcript.

**Target user:** Someone who screen-recorded a conversation on their phone and wants the full text extracted without manually transcribing it.

**Deployment:** Runs locally on Windows. No Docker. No cloud. Launch via PowerShell, opens a browser tab to `localhost:8501`. Single `pip install` command.

-----

## Architecture

```text
┌─────────────────────────────────────────────────────┐
│                   Streamlit Web UI                 │
│  ┌──────────┐  ┌──────────────┐  ┌───────────────┐ │
│  │ Upload / │  │ Live Preview │  │ Export Panel  │ │
│  │ DragDrop │  │ + Progress   │  │ JSON/TXT/HTML │ │
│  └──────────┘  └──────────────┘  └───────────────┘ │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│              Processing Pipeline                    │
│  1. Frame Extraction (ffmpeg)                       │
│  2. Perceptual Dedup (imagehash / SSIM)             │
│  3. Chat Region Detection (contour analysis)        │
│  4. Bubble Segmentation + Speaker ID                │
│  5. OCR per unique bubble (EasyOCR or Tesseract)    │
│  6. Temporal Merge + Text Dedup (fuzzy matching)    │
│  7. Confidence Scoring                              │
│  8. Output Assembly                                 │
└──────────────────┬──────────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────────┐
│                Storage (SQLite)                     │
│  - Projects table (one per video)                   │
│  - Extracted lines + confidence + geometry          │
│  - Searchable across all projects                   │
└─────────────────────────────────────────────────────┘
```

-----

## Dependencies

```txt
streamlit>=1.30.0
easyocr>=1.7.0
opencv-python-headless>=4.9.0
Pillow>=10.0.0
imagehash>=4.3.1
numpy>=1.24.0
scikit-image>=0.22.0
rapidfuzz>=3.5.0
ffmpeg-python>=0.2.0
```

**External binary:** `ffmpeg.exe` must be on PATH or in the project directory. Install via `winget install ffmpeg` or download from https://www.gyan.dev/ffmpeg/builds/

**One-command install:**

```powershell
pip install streamlit easyocr opencv-python-headless Pillow imagehash numpy scikit-image rapidfuzz ffmpeg-python --break-system-packages
```

**One-command launch:**

```powershell
streamlit run snapocr.py
```

-----

## Processing Pipeline — Detailed Spec

### Step 1: Frame Extraction

- Use ffmpeg to extract frames from the input video.
- Do **not** extract every frame. Default to 2 FPS (configurable 1–10).
- Extract PNG frames to a temp directory and gather metadata (duration, resolution, FPS, codec).
- Portrait detection and landscape confirmation.
- Detect/crop letterboxing and pillarboxing.

### Step 2: Perceptual Dedup (Frame Level)

- Compute pHash for each frame and SSIM for consecutive frames.
- If pHash hamming distance < 5 and SSIM > 0.95, skip frame N.
- Keep a manifest of retained frames + timestamps.
- Flag SSIM 0.5–0.95 frames as `transitional` (keep them).

### Step 3: Chat Region Detection

- Crop to chat area by excluding status bar, keyboard, and nav bars.
- Use top-band detection + edge-density keyboard detection.

### Step 4: Bubble Segmentation + Speaker Identification

- HSV thresholding for bubble detection and bbox extraction.
- Speaker side mapping: right = `self`, left = `other`.
- Fall back to positional-only analysis if color detection fails.
- Handle dark mode with luminance-based heuristic inversion.
- Detect inline timestamps and associate with nearby messages.
- App profile auto-detection + manual override in UI.

### Step 5: OCR

- Use EasyOCR per bubble region (not full-frame OCR).
- Preprocess with resize, grayscale, adaptive threshold, conditional inversion.
- Keep low-confidence text flagged (default threshold 0.3) rather than dropping.
- Add placeholder labels for non-text visual artifacts like `[emoji]`.

### Step 6: Temporal Merge + Text Dedup

- Maintain sliding buffer of known messages across frames.
- Fuzzy match via `rapidfuzz.fuzz.ratio`; >85 and same speaker => duplicate update only.
- Include geometric fingerprinting (aspect ratio, area, side, relative y-position).
- Flag partial bubbles; replace when full bubble appears later.
- Handle repeated short texts (e.g. “ok”) using position + temporal context.

### Step 7: Confidence Scoring

- `composite = ocr*0.5 + dedup*0.3 + completeness*0.2`
- UI warnings:
  - `< 0.5` yellow indicator
  - `< 0.3` red indicator

### Step 8: Output Assembly

- Chronological ordering from scroll direction + timestamps + first seen.
- Speaker relabeling support in UI.
- Attach in-chat timestamps when available, else video time references.

-----

## Output Formats

- **TXT**: timestamped speaker lines
- **JSON**: metadata, speakers, messages, confidence details
- **HTML**: reconstructed chat UI, confidence dots, hover diagnostics, print-friendly single file

-----

## UI Specification (Streamlit)

- Header: SnapOCR + subtitle.
- Sidebar controls: app override, FPS, OCR language, thresholds, speaker names, dark mode, batch mode.
- Main area: upload, progress panel, results tabs (chat/timeline/raw/diagnostics), export bar.
- Batch mode: sequential processing, SQLite storage, merge conversation support.
- Search: SQLite FTS5 query across processed videos.

-----

## SQLite Schema

Use the two-table + FTS5 structure:

- `projects`
- `messages`
- `messages_fts`
- Insert/update/delete triggers to maintain FTS sync

(See full schema in planning notes if implementing exact SQL definitions.)

-----

## Edge Cases to Handle

- Video-of-video nested frames
- Landscape rotation
- Split-screen / PiP chats
- Stickers/images/voice messages/reactions/link previews/read receipts
- Group chat speaker expansion (N speakers)
- Typing indicators suppression
- Reply/quote bubble nested extraction

-----

## Performance Targets

- 60s video at 2 FPS = ~120 extracted frames
- Post-dedup retained ~30–60 frames
- CPU processing target: 30–90s per minute of video
- GPU processing target: 10–30s per minute of video
- RAM target < 2GB
- Temp PNG cleanup after run

-----

## File Structure

```text
snapocr/
├── snapocr.py              # Main Streamlit app + UI
├── pipeline.py             # Core processing pipeline
├── frame_extract.py        # ffmpeg frame extraction + preprocessing
├── dedup.py                # Perceptual hashing + SSIM dedup
├── bubble_detect.py        # Chat region detection + bubble segmentation
├── ocr_engine.py           # EasyOCR wrapper + preprocessing
├── temporal_merge.py       # Cross-frame dedup + scroll tracking
├── output_formats.py       # TXT/JSON/HTML export
├── db.py                   # SQLite operations
├── app_profiles.py         # Per-chat-app color/layout heuristics
├── requirements.txt
├── snapocr.db              # Created on first run
└── README.md
```

-----

## Launch Instructions (PowerShell)

```powershell
git clone https://github.com/Penny-Admixture/snapocr.git
cd snapocr
pip install -r requirements.txt --break-system-packages
streamlit run snapocr.py
```

-----

## Implementation Notes

- No Docker/Kubernetes.
- PowerShell-centric workflow for target environment.
- EasyOCR preferred over Tesseract.
- Streamlit preferred over Flask/Gradio.
- Dedup + temporal merge quality is the critical differentiator.
- Detect CUDA at startup but always support CPU fallback.
- Keep SQLite DB in project directory.
- Emit visible log lines in UI for every pipeline stage.
