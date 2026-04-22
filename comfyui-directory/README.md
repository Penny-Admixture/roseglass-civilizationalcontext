# ComfyUI Local Workflow Directory (Viewer)

This is a **local-only** viewer for curated ComfyUI workflows.

## Quick start

From the repository root:

```bash
python3 -m http.server 4173
```

Then open:

- `http://localhost:4173/comfyui-directory/index.html`

## Data file

The viewer reads:

- `comfyui-directory/workflows.sample.json`

You can replace this file with your own exported list (same schema).

## Supported filters

- Free-text search (name/source/category/tags)
- Modality (`t2i`, `i2i`, `t2v`, `i2v`, `i2t`, `v2t`, `sound2text`)
- `<=12 GB VRAM` toggle (on by default)
- Local-only toggle (on by default)
- Sort by popularity/rating/name

## Notes

- Records marked `cloud_only` are hidden by default.
- Records with missing VRAM evidence should be marked `vram_verified: false`; these are hidden when `<=12 GB` is enabled.
