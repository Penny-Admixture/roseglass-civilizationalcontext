# Music Flamingo

**NVIDIA's 8B-parameter AI model for deep music understanding.**

Analyzes audio files for genre, tempo, key, chord progressions, instrument identification, song structure, lyrics transcription, mood, production style, and music-theoretic reasoning.

Source: [NVIDIA/audio-flamingo](https://github.com/NVIDIA/audio-flamingo) (branch: `music_flamingo`)
Model: [nvidia/music-flamingo-hf](https://huggingface.co/nvidia/music-flamingo-hf)

## Install

```powershell
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/install.ps1 | iex
```

## Prerequisites

- **Python 3.10+** — [python.org/downloads](https://www.python.org/downloads/)
- **NVIDIA GPU** with CUDA drivers — [nvidia.com/drivers](https://www.nvidia.com/drivers)
- The installer auto-detects your GPU VRAM and picks the right quantization:
  - 32+ GB VRAM → FP16 (full precision)
  - 16+ GB VRAM → 8-bit quantization
  - 6+ GB VRAM → 4-bit quantization (NF4)

## What it does

- Creates a Python venv at `%LOCALAPPDATA%\MusicFlamingo\venv`
- Installs PyTorch with CUDA, HuggingFace Transformers, Gradio, and dependencies
- Writes a Gradio web UI (port 7870) and a CLI inference script
- Creates Start Menu and Desktop shortcuts
- Model weights (~16.6 GB) download automatically on first launch via HuggingFace

## Usage

**Web UI:** Double-click "Music Flamingo" on Desktop → browser opens at `http://127.0.0.1:7870`

**CLI:**
```
Launch-CLI.bat "C:\Music\track.mp3"
Launch-CLI.bat "C:\Music\track.mp3" -p "What key is this song in?"
Launch-CLI.bat "C:\Music\track.mp3" -p "Transcribe the lyrics" -t 0.3
```

## Uninstall

```powershell
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/uninstall.ps1 | iex
```

Removes app directory, venv, shortcuts, registry entries. Optionally removes cached model weights (~16.6 GB in `~/.cache/huggingface`).

## License

Non-commercial research use only ([NVIDIA OneWay Noncommercial License](https://huggingface.co/nvidia/music-flamingo-hf)).
