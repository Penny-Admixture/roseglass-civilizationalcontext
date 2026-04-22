# ComfyUI Workflow Directory (Local-Only) — Scope Update

## Direct answer to your follow-up
Yes — this plan now explicitly covers all requested modalities and enforces **local-only execution** with **no hosted inference APIs**.

## Modality coverage
The searchable index must include and tag workflows across:

- **Image generation**: `t2i`, `i2i`
- **Video generation**: `t2v`, `i2v`
- **Captioning / understanding**:
  - `i2t` (image captioning)
  - `v2t` (video captioning)
  - `sound2text` (audio/music captioning/transcription)

## Hardware gate (strict)
Only include workflows expected to run on **12 GB VRAM or less** under local inference.

Required metadata fields for filtering:

- `vram_min_gb`
- `vram_recommended_gb`
- `tested_gpu`
- `resolution_or_duration_limits`
- `quantization_or_lowvram_mode` (if used)

Any workflow missing VRAM evidence is marked `unverified` and excluded from default results.

## Local-only policy (no API inference)

### Allowed
- Local ComfyUI runtime
- Local checkpoints, LoRAs, VAEs, and local node packs
- Optional local metadata scraping/indexing jobs

### Not allowed
- Hosted inference APIs for generation/captioning
- Cloud execution dependency as a requirement to run workflows
- Any workflow that requires external paid API keys for core output

## Source curation policy for aggregator
Candidate sources can be indexed for discovery (ComfyHub, CivitAI, OpenArt, ComfyUI Examples, Beam, RunComfy, Comfy Cloud links), but each workflow record must be labeled:

- `local_ready` (runs fully local)
- `cloud_only` (excluded by default)
- `hybrid` (included only if local execution path is documented)

## Search/filter requirements
Required filters in UI:

- Modality (`t2i`, `i2i`, `t2v`, `i2v`, `i2t`, `v2t`, `sound2text`)
- `<=12 GB VRAM` toggle (default ON)
- Local-only toggle (default ON)
- Node dependencies present/missing
- Rating/popularity

## Practical caveat
Some listed sites do not expose consistent popularity/rating/download metadata via stable public endpoints. In those cases, ingest what is publicly available and mark missing fields explicitly as `unknown`, while keeping records searchable.
