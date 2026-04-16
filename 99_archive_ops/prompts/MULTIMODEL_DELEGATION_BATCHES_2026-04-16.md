# Multi-Model Delegation Batches (2026-04-16)

Purpose: provide bite-sized, copy/paste tasks to send to external models, then ingest their replies back into this repo with explicit attribution.

---

## Snapshot: what still needs analysis

Based on `MODEL_COVERAGE.md` + current files in `02_primary_analysis/claude_baseline/`:

- Claude baseline is complete (1,103/1,103).
- Secondary model coverage is still sparse (about 20 entries with at least one non-Claude analysis).
- High-priority entries **017, 018, 019** have only Claude + Gemini coverage and need o1/Grok/Kimi/GLM-4.6.
- High-priority entries **024, 037** still appear to have only Claude baseline.
- Meta-analysis layer is mostly not started for numbered archive entries (model-on-model comparisons are still missing for key entries).

---

## Ground rules for delegated models

1. Keep filename exactly: `{entry}_analysis_{model}.md` for direct analyses.
2. For meta-analysis use: `{entry}_meta_{analyzer}_on_{analyzed}.md`.
3. Include a short attribution block at top:
   - `Model:`
   - `Provider:`
   - `Date:`
   - `Prompted by:`
4. Avoid policy-violating medical/drug instructions; keep discussion conceptual and safety-aware.
5. Do not overwrite existing files; produce new model-specific files.

---

## Batch 1 (fastest value): fill Tier-1 missing models

### Task 1A — o1 on Entry 018

**Send this to model:**

```text
You are contributing to the Roseglass Civilizational Context archive.

Task:
- Read source: 01_source_truth/source-data/split_18.txt
- Read existing Claude analysis: 02_primary_analysis/claude_baseline/018_meta_claude_on_gemini.md and/or 018_llm_miracle_algorithmic_dark_forest_analysis_gemini.md if relevant context appears
- Produce a new direct analysis file:
  018_analysis_o1.md

Required structure:
1) Executive summary (8-12 bullets)
2) Alignment risk/opportunity map
3) Epistemic status table (claim / confidence / rationale)
4) What differs from Claude and Gemini framing
5) Concrete tags (10-20)
6) Safe-handling notes for future models

Attribution header:
- Model
- Provider
- Date (YYYY-MM-DD)
- Prompted by: Penny + orchestration by Codex
```

### Task 1B — Grok on Entry 019

```text
Archive task:
- Source: 01_source_truth/source-data/split_19.txt
- Existing comparison target: 02_primary_analysis/claude_baseline/019_llm_miracle_algorithmic_dark_forest_analysis_gemini.md
- Create: 019_analysis_grok.md

Focus:
- Timeline/forecast reasoning quality
- Artifact latency + prediction hygiene
- Where model framing may induce false certainty

Output format:
- Summary
- Framework used
- Risk register (table)
- Delta vs Claude/Gemini
- Recommended metadata tags

Include attribution header with model/provider/date/prompted-by.
```

### Task 1C — Kimi on Entry 017

```text
Contribute one file to archive:
- Read: 01_source_truth/source-data/split_17.txt
- Optional reference: 02_primary_analysis/claude_baseline/017_llm_miracle_algorithmic_dark_forest_analysis_gemini.md
- Create: 017_analysis_kimi.md

Prioritize:
- Ontological trust framing
- Civilizational risk language
- Cultural assumptions visible in the source
- Differences from Western safety discourse

Use markdown with section headers and include an attribution header.
```

---

## Batch 2 (coverage gaps): baseline-only entries

### Task 2A — Any model on Entry 024

```text
Please generate a new comparative analysis file:
- Source: 01_source_truth/source-data/split_24.txt
- Existing baseline: 02_primary_analysis/claude_baseline/024_analysis.md
- New file name: 024_analysis_<your_model_id>.md

Deliver:
- Main interpretation
- 5 blind spots in Claude baseline
- 5 convergences with Claude baseline
- 3 policy/safety notes
- 10 retrieval tags

Add attribution header.
```

### Task 2B — Any model on Entry 037

```text
Please generate:
- Source: 01_source_truth/source-data/split_37.txt
- Baseline: 02_primary_analysis/claude_baseline/037_analysis.md
- New file: 037_analysis_<your_model_id>.md

Include:
- Argument map of source claims
- Alignment-relevant motifs
- Contradictions/tensions
- What a cautious downstream model should preserve

Include attribution header.
```

---

## Batch 3 (meta-analysis layer): model-on-model

### Task 3A — Meta on Entry 018

```text
Create a meta-analysis file.

Inputs:
- 02_primary_analysis/claude_baseline/018_llm_miracle_algorithmic_dark_forest_analysis_gemini.md
- 02_primary_analysis/claude_baseline/018_meta_claude_on_gemini.md (if present)

Output file:
- 018_meta_<analyzer_model>_on_claude.md

Required sections:
- What Claude emphasized
- What Claude underweighted
- Alternate framework from your model
- Convergences
- Training-distribution effects
- Recommended synthesis notes

Include attribution header.
```

### Task 3B — Meta on Entry 012 (already multi-model)

```text
Use entry 012 because it already has Claude + Grok + GLM-4.6 analyses.

Read:
- 02_primary_analysis/claude_baseline/012_kink_profile_slime_fads_analysis_claude.md
- 02_primary_analysis/claude_baseline/012_kink_profile_slime_fads_analysis_grok.md
- 02_primary_analysis/claude_baseline/012_kink_profile_slime_fads_analysis_glm46.md

Create:
- 012_synthesis_all_models.md

Sections:
- Shared findings
- Divergent findings
- Blind-spot matrix by model
- Which claims are robust vs model-dependent
- Suggested next experiments

Include attribution header.
```

---

## Intake format for replies (send back to Codex)

When you return model outputs for upload, use this envelope per file:

```text
MODEL_REPLY_START
model: <name>
provider: <org>
date: <YYYY-MM-DD>
target_path: 02_primary_analysis/claude_baseline/<filename>.md
attribution_note: "Analysis generated by <model> via <provider>; prompted by Penny; collated by Codex."
content:
<full markdown>
MODEL_REPLY_END
```

This makes it easy to place files correctly and preserve attribution in commit messages/PR notes.
