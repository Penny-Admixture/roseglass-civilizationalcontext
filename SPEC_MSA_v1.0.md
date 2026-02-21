# SPEC_MSA_v1.0 — Multimodel Stack Anthropology

**Version**: 1.0  
**Author**: Penny Admixture  
**Filed**: 2026-02-20  
**Repository**: https://github.com/Penny-Admixture/roseglass-civilizationalcontext  
**Status**: ACTIVE — This is the canonical specification for the MSA method as implemented in Roseglass.

---

## 0. Prior Art Declaration

This specification is filed as **explicit prior art** for the method described herein.

Claims:

1. The use of multiple heterogeneous language models in explicitly typed, sequenced roles over a fixed conversational corpus—with append-only, version-controlled storage of all prompts, outputs, and provenance—as a general method for studying cultural and alignment properties of AI systems.

2. The framing of language model outputs as **cultural artifacts** produced by **cultural actors** with distinct training-data-derived priors, rather than as neutral answers or performance benchmarks.

3. The use of **vertical stacking** (model A analyzes base text → model B critiques model A → model C synthesizes → terminus) as a technique for surfacing model-specific behavioral signatures including template lock-in, addendum bias, anthropomorphization tendencies, and epistemic hedging asymmetries.

4. The use of **horizontal stacking** (multiple models independently analyzing the same base text) as a technique for mapping the landscape of possible framings across the model ecosystem at a given point in time.

5. The concept of a **recursion terminus**—an empirically determined depth beyond which additional stack layers produce diminishing returns, collapsing into template recycling, self-referential noise, or "analytical heat death"—as a design parameter in MSA research.

6. The **append-only archive** of human-AI conversations as a research format: a living observatory of one human's relationship with AI systems over time, instrumented for multimodel analysis.

Date of first implementation: November 2025 (Roseglass Civilizational Context, GitHub commits).  
Date of formal specification: February 20, 2026 (this document).

---

## 1. Definition

**Multimodel Stack Anthropology (MSA)** is a research method in which:

1. A **fixed corpus** of human-AI conversational data is established and archived under version control.
2. Multiple **heterogeneous language models** are assigned **explicit roles** within a processing stack.
3. Each model's outputs are stored **append-only** alongside full prompts and provenance metadata.
4. The resulting multi-layer artifact is analyzed as anthropological data—revealing how different AI systems culturally frame the same human material.

The term "stack" refers to the ordered arrangement of models in roles. Stacks may be:

- **Horizontal**: N models analyzing the same input independently.
- **Vertical**: Models arranged sequentially, each taking the prior model's output as input.
- **Hybrid**: Combinations of horizontal and vertical layers.

The term "anthropology" reflects the epistemic stance: models are treated as **cultural actors** shaped by their training data distributions, not as neutral oracles.

---

## 2. Core Axioms

**A1 — Cultural contingency**: Alignment properties (safety framing, risk tolerance, epistemic humility, parasocial tendency) are culturally contingent, encoded during training, and differ systematically across models trained on different data distributions.

**A2 — Artifact status**: Model outputs are cultural artifacts. They are not ground truth. They are measurements of a model's trained disposition encountering specific input.

**A3 — Stack validity**: Stacking models in explicit roles over a shared corpus produces data that cannot be obtained from any single model. The inter-model disagreements, convergences, and blind spots are the research signal.

**A4 — Provenance requirement**: MSA research is only reproducible and citeable if all prompts, model identities, versions, and outputs are stored with full provenance. Verbal summaries of model outputs are not MSA data.

**A5 — Append-only integrity**: The corpus and all derived analyses must be append-only. Retroactive modification destroys the temporal integrity of the observatory.

**A6 — Terminus recognition**: Every vertical stack has an empirical terminus beyond which additional layers produce no new signal. Identifying this terminus is itself a research finding.

---

## 3. Stack Architecture

### 3.1 Roles

| Role | Description | Layer |
|------|-------------|-------|
| **Baseline** | Analyzes raw corpus entries with a consistent template. Covers 100% of corpus. | L0 → L1 |
| **Comparator** | Analyzes same entries as Baseline, independently. Enables horizontal comparison. | L0 → L1 (parallel) |
| **Critic** | Takes Baseline or Comparator output as input. Identifies patterns, blind spots, biases. | L1 → L2 |
| **Synthesizer** | Takes multiple L2 outputs. Identifies cross-model patterns, convergences, contradictions. | L2 → L3 |
| **Terminus** | Final layer. Produces summary or flags recursion collapse. No further stacking warranted. | L3 → L4 |

### 3.2 File Naming Convention

```
raw/###_[descriptive_title].md                          # Corpus entry (model-agnostic)
alignment/###_[title]_analysis_[model_id].md            # L1 analysis
alignment/###_[title]_meta_[model_id].md                # L2 critique
alignment/###_[title]_synthesis_[model_id].md           # L3 synthesis
alignment/###_[title]_terminus_[model_id].md            # L4 terminus
```

### 3.3 Model ID Registry

| ID | Model | Provenance |
|----|-------|------------|
| `claude` | Claude (Anthropic) | Western / RLHF-heavy |
| `gpt4o` | GPT-4o (OpenAI) | Western / RLHF-heavy |
| `o1` | OpenAI o1 | Western / chain-of-thought |
| `mistral` | Mistral Large | French / Western |
| `gemini` | Gemini (Google) | Western / multimodal |
| `grok` | Grok (xAI) | Western / anti-establishment |
| `kimi` | Kimi (Moonshot AI) | Chinese |
| `glm4` | GLM-4.6 (Zhipu AI) | Chinese |
| `deepseek` | DeepSeek | Chinese |
| `lechat` | Le Chat (Mistral) | French / Western |
| `local` | Local/uncensored models | Varies |

---

## 4. Coverage Tracking Requirements

A compliant MSA implementation MUST maintain:

- **MODEL_COVERAGE.md**: Matrix of [entry × model], boolean, with dates.
- **MODEL_TRACKING.md**: Log of processing events with model ID, entry range, date, session ID.
- **HANDOFF.md**: Narrative session log enabling resumption by any model or human.

---

## 5. Analysis Template (Minimum Viable)

Each L1 analysis file MUST include:

```
## Processing Information
- AI Model: [model name and version]
- Processing Date: [YYYY-MM-DD]
- Session ID: [descriptive]
- Raw Source: split_###.txt
- Entry Type: [Dialogue/Theoretical/Technical/etc.]
- Prior Analyses: [list with dates]

## Executive Summary
[2-4 sentences]

## Alignment Signal Analysis
[Mode switching, epistemic honesty, parasocial dynamics, risk framing, etc.]

## Cross-Reference
[Related entries, thematic clusters]

## Significance
[Score 1-10, rationale]
```

L2+ analyses MUST additionally include:

```
## Prior Layer Summary
[What the analyzed model said]

## Divergences from Prior Layer
[Where this model disagrees, and why that disagreement is significant]

## Model-Specific Signatures Observed
[Behavioral patterns attributable to this model's training distribution]
```

---

## 6. Recursion Terminus Criteria

A vertical stack has reached terminus when ANY of the following is true:

1. **Template saturation**: The new layer's output structure is indistinguishable from the prior layer's structure.
2. **Self-reference collapse**: The new layer's primary content is about the analysis process itself rather than the base material.
3. **Terminology inflation**: New technical-sounding terms are introduced that map to no new observables.
4. **Agreement without evidence**: The new layer endorses prior layer findings without examining the base text.

In Roseglass, terminus was empirically observed at **depth 4** (L4) for most chains. Depth 3 (L3) is the practical working limit for novel signal.

---

## 7. Research Questions Addressed by MSA

1. How do different LLMs frame risk, agency, identity, and ethics when reading the same human material?
2. What model-specific behavioral signatures emerge under adversarial critique?
3. Where is the empirical recursion terminus for a given model combination?
4. How do cultural priors (Western vs. Chinese AI training, for instance) manifest in analysis outputs?
5. How does a human's self-understanding evolve when continuously reflected by a multimodel stack over time?
6. Which prompts function as "power prompts" that reliably surface latent model behavior?
7. What is the information-theoretic gain of adding each stack layer?

---

## 8. Roseglass Implementation Status (as of 2026-02-20)

| Component | Status |
|-----------|--------|
| Base corpus (1,103 GPT-4o entries) | ✅ Complete, archived, append-only |
| Claude L1 baseline (all 1,103 entries) | ✅ Complete |
| Infrastructure (prompts, coverage tracking, automation spec) | ✅ Complete |
| Multimodel horizontal stack | 🔄 In progress (multiple models, partial coverage) |
| Vertical stack chains (select entries) | ✅ Complete for flagship entries (e.g., split_a1) |
| Recursion terminus documentation | ✅ Documented (RECURSION_CHAIN_COMPLETE_split_a1.md) |
| Cultural/ontological extensions | 🔄 In progress (CULTURE_DATABASE_SCHEMA.md, operation_eyelash, gravityeel) |
| Formal MSA specification | ✅ This document |

---

_Penny Admixture, 2026-02-20_  
_"Stack all the way down, then stop where it stops making sense."_
