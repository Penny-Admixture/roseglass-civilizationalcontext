# Automated Multi-Model Analysis Orchestrator (Turnkey Spec)

Authoring target: **Google AI Studio** (front-end + serverless functions) to build a web UI that coordinates multiple LLMs analyzing this repo’s documents in an append-only workflow.

This spec is designed to be handed directly to an AI to generate the implementation. It references the repository structure of `roseglass-civilizationalcontext` and encodes all required behaviors, prompts, file paths, and validation rules.

---
## 1. Objectives
- One-click runs that select a model, load repo context, and produce structured analyses without back-and-forth prompting.
- Strict append-only writes to GitHub, respecting the project’s philosophy (no edits to existing files).
- Deterministic, repeatable prompting that minimizes refusals (offline-mode friendly with pre-fetched context).
- Rich provenance tracking (model, endpoint, timestamps, hashes, prompts) with a master index.

---
## 2. Repository Assumptions
- Root paths of interest:
  - `raw/` — source conversation fragments (e.g., `raw/001_elliot_futures_virtual_societies.md`).
  - `alignment/`, `analysis/`, `handoffs/`, `handoff-archive/` — existing analyses/notes.
  - `MASTER_INDEX.md` — manual tracking; keep append-only.
  - `templates/` — safe place for prompt templates and generated configs.
- Append-only rule: never modify existing files; all outputs go to new timestamped files.

---
## 3. System Architecture
- **Frontend (Google AI Studio web app)**
  - Single-page UI (HTML/JS/CSS) with panels for: document selection, model selection, prompt preview, run log, and GitHub commit preview.
  - Authentication inputs: GitHub PAT, model API keys (client-side vault or GCP Secret Manager via callable function).
  - Buttons: `Fetch Context`, `Run Analysis`, `Retry/Repair`, `Commit to GitHub`.
  - Status toasts/log stream for each pipeline step.

- **Backend (Serverless Functions)**
  - Functions implemented via Google Cloud Functions or Vertex AI Functions.
  - Responsibilities:
    1. **ListDocs**: read repo tree (GitHub API) to list `raw/*.md` plus prior analyses for a doc.
    2. **BuildContext**: fetch target doc and summaries of prior analyses (tail-truncated) and return structured payload.
    3. **SelectModel**: load `models.yaml` (see §4) and pick model per policy (round-robin or weighted random).
    4. **RunLLM**: call chosen model with handoff prompt, validate structure, and auto-repair missing sections.
    5. **PersistOutputs**: write new files under `analysis-runs/` (see §5), update `docs/index.json`, and open a PR/commit.
    6. **LogRun**: append JSONL entry to `runs/` with full provenance.

- **Stateless design**: each run uses GitHub as source of truth; cache optional.

---
## 4. Configuration Files (checked into repo)
- `models.yaml` (add under `templates/`): list of available endpoints with fields: `name`, `provider`, `endpoint`, `context_window`, `cost`, `temperature`, `style_notes`, `roles` (e.g., `critic`, `creative`).
- `templates/handoff.md`: structured prompt template (see §6).
- `templates/bootstrap.md`: refusal-recovery prompt emphasizing offline mode and provided context.
- `docs/index.json` (create under `analysis/` or `docs/`): master table keyed by source doc filename with arrays of runs (timestamp, model, commit SHA, paths, hashes).
- `runs/` (folder): JSONL logs per execution.

---
## 5. File Output Conventions (append-only)
- Base directory for new outputs: `analysis-runs/` (create if missing).
- Per run paths (all new files):
  - `analysis-runs/<doc-stem>/<timestamp>-<model>/primary.md` — main analysis bundle (sections in §6 Output).
  - `analysis-runs/<doc-stem>/<timestamp>-<model>/meta-meta.md` — meta/meta section copy for quick access.
  - `analysis-runs/<doc-stem>/<timestamp>-<model>/prompt.txt` — exact prompt sent (for reproducibility).
  - `analysis-runs/<doc-stem>/<timestamp>-<model>/response.json` — structured JSON validation output.
- Filenames use UTC ISO compact: `YYYYMMDDTHHMMSSZ`.
- Do not overwrite existing files; refuse if path exists.

---
## 6. Prompt & Validation
- **Handoff prompt sections** (enforce headings):
  1. `# Context` (project summary + doc path + prior analyses list)
  2. `# Tasks` (explicit list of steps)
  3. `# Output Format` with required headings:
     - `## Primary-Analysis` (≥2:1 length vs source summary)
     - `## Analysis-of-Analyses` with nested `### [analysis-id]` per prior analysis
     - `## Meta-Meta`
     - `## Blue-Sky` (12 paragraphs)
     - `## Importance-Now` (10 paragraphs)
     - `## Importance-Future` (10 paragraphs)
  4. `# Validation` instruction: regenerate missing sections only.
- **Bootstrap prompt**: short reminder to operate solely on provided text, ignore internet claims, and fill required sections.
- **Auto-validation**: after LLM response, check presence of all headings and paragraph counts; if missing, run repair call with a correction prompt supplying the partial output.

---
## 7. Pipeline Logic (per run)
1. **Select source doc**: user picks from UI list (default `raw/*.md`).
2. **Fetch context**:
   - Download source doc (full text) and SHA.
   - Gather prior analyses for that doc by scanning `analysis-runs/<doc-stem>/**/primary.md` and existing directories (`alignment/`, `analysis/`, `handoffs/`, `handoff-archive/`). Summarize or chunk to fit budget.
3. **Model selection**: choose via `SelectModel` policy; allow user override in UI.
4. **Build prompt**: inject context + prior analysis summaries + task/output schema from `templates/handoff.md`. Include offline reminder.
5. **Run LLM**: call chosen endpoint; store raw response and structured parse.
6. **Validate/repair**: ensure required sections/headings; if ratio/paragraph counts fail, auto-reprompt to patch missing parts only.
7. **Persist**: write files under `analysis-runs/…`; compute hashes; update `docs/index.json` (append new run entry); append to `runs/YYYY-MM.jsonl` with full metadata.
8. **Commit/PR**: create commit with message `feat: add analysis for <doc-stem> via <model>`; push to branch or open PR.
9. **UI update**: show diff preview and provenance summary.

---
## 8. Data Schemas
- **docs/index.json** example:
```json
{
  "001_elliot_futures_virtual_societies.md": {
    "source_sha": "<git-sha>",
    "runs": [
      {
        "timestamp": "2025-02-14T12:00:00Z",
        "model": "gemini-2.0-pro",
        "endpoint": "vertex-ai",
        "commit": "<sha>",
        "paths": {
          "primary": "analysis-runs/001_elliot_futures_virtual_societies/20250214T120000Z-gemini-2.0-pro/primary.md",
          "meta_meta": "analysis-runs/001_elliot_futures_virtual_societies/20250214T120000Z-gemini-2.0-pro/meta-meta.md",
          "prompt": "analysis-runs/001_elliot_futures_virtual_societies/20250214T120000Z-gemini-2.0-pro/prompt.txt"
        },
        "hashes": {
          "source_sha256": "...",
          "response_sha256": "..."
        }
      }
    ]
  }
}
```

- **runs JSONL entry** example:
```json
{"timestamp":"2025-02-14T12:00:00Z","doc":"raw/001_elliot_futures_virtual_societies.md","model":"gemini-2.0-pro","endpoint":"vertex-ai","result":"success","output_paths":{"primary":"..."},"prompt_hash":"...","response_hash":"...","warnings":["repair-run"]}
```

---
## 9. GitHub Integration
- Use GitHub REST API with user PAT (scopes: `repo`, `contents`).
- Steps per run:
  1. `GET` files for context; `PUT` new files with base64 content (fail if exists).
  2. Update `docs/index.json` by reading current version, appending run entry, writing back.
  3. Commit all new files in a single tree; commit message from §7.
  4. Optionally create PR targeting default branch; include run summary in body.
- Respect append-only: if file exists, abort and prompt user to re-run with new timestamp.

---
## 10. UI/UX Flow (web app)
- **Landing**: inputs for GitHub repo URL (pre-filled to this repo), PAT, and model keys.
- **Doc picker**: dropdown populated from `raw/` filenames; search filter.
- **Prior analyses panel**: list existing runs with timestamp/model; expandable summaries.
- **Prompt preview**: show fully rendered prompt before send; allow edits but warn about schema.
- **Execution log**: stream of steps (Fetch, Build Prompt, Run LLM, Validate, Persist, Commit).
- **Diff/Preview**: render markdown of new files and `docs/index.json` diff.
- **Retry controls**: buttons to switch model and re-run with same context; repair-only mode.

---
## 11. Error Handling & Safeguards
- If model refuses or claims no internet, switch to bootstrap prompt with embedded content only.
- If validation fails after two repairs, mark run as `failed` in `runs/` log and do not write outputs.
- Token budgeting: summarize prior analyses if combined length exceeds 75% of model context; keep summaries deterministic (e.g., top-N sentences or embedding-ranked snippets if available).
- Rate limits: backoff retries on GitHub and model APIs.
- Security: never log secrets; use temporary credentials in memory only.

---
## 12. Testing Checklist (for AI implementer)
- Unit tests for prompt builder to ensure required headings present.
- Integration test hitting a mock model endpoint returning canned output; verify validation/repair works.
- End-to-end test that writes to a temporary branch, updates `docs/index.json`, and produces expected paths.
- UI test: simulate selecting a doc, running analysis, viewing preview, committing.

---
## 13. Deliverables
- Front-end HTML/JS/CSS assets (single-page app) ready to deploy via Google AI Studio hosting.
- Serverless function code (Node.js or Python) for the six backend responsibilities in §3.
- New repo files: `templates/models.yaml` (sample entries), `templates/handoff.md`, `templates/bootstrap.md`, `docs/index.json` (initialized), `analysis-runs/` (empty placeholder via `.gitkeep`), `runs/` (empty `.gitkeep`).
- Documentation: `VIEWING_FRONTEND.md` update describing how to launch the web app and required environment variables/keys.

---
## 14. Implementation Notes for the AI
- Prefer lightweight libraries (e.g., `fetch`/`axios` for HTTP, `marked` for markdown preview).
- Keep code modular: `githubClient`, `modelClient`, `promptBuilder`, `validator`, `fileWriter` modules.
- Avoid try/catch around imports (per coding guidelines).
- Ensure timestamps are generated in UTC and used consistently across filenames and logs.
- Provide clear comments and TODOs where human configuration may be needed (e.g., cost weights in `models.yaml`).

