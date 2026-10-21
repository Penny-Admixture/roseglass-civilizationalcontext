# DATASET.md — Roseglass Civilizational Context

**Repository**: Penny-Admixture/roseglass-civilizationalcontext
**Document filed**: 2026-10-20
**Filed by**: Marley, at Penny Sanford's direction

This document describes what this repository contains, how it is laid out,
where it came from, and what its known imperfections are. It exists so that
any future reader — human or model — can load this corpus without first
having to reconstruct its history from the commit log.

---

## 1. What this repository is

Roseglass is an archive of **1,103 conversation fragments** between
**Penny Sanford** and **GPT-4o (2024)**, spanning 2024–2025, together with
the multi-model analysis built on top of those fragments.

The method is **Multimodel Stack Anthropology (MSA)**: heterogeneous
language models are arranged in explicit roles over a fixed conversational
corpus, all outputs stored append-only under version control, to study how
different models frame the same human material. The formal specification
is `SPEC_MSA_v1.0.md` (filed 2026-02-20, author Penny Admixture); the
plain-language method description is
`OVERVIEW_MULTIMODEL_STACK_ANTHROPOLOGY.md`. The repository README remains
the operational entry point for models joining the analysis.

The Claude baseline analysis of all 1,103 entries was completed
2025-12-05. The corpus itself — not any single analysis of it — is the
primary artifact.

## 2. Restoration note (2026-10-20)

The full corpus was removed from this repository's default branch by
merge commit **81e2282** (2026-04-22, "Merge
codex/build-curated-comfyui-workflows-directory-qc3pll into main and
resolve conflict markers"). The merge resolved conflict markers by
discarding the corpus tree; the default branch was left holding only
nine files while the complete corpus survived on a side branch.

On **2026-10-20** the corpus was restored to the default branch by
Finn's pull request **#34** (`finn/restore-corpus-to-main`, 27 batch
commits, merged the same day), sourced from commit
**601d5976f009bb2749f72fb99afb6a27ea50944e** — the tip of
`codex/build-curated-comfyui-workflows-directory-qc3pll`, whose tree is
the pre-wipe corpus tree. Marley independently audited the restoration
after the merge: on every path present in both the restored tree and
commit 601d597's tree, the blob SHAs are identical (2,221 of 2,221
paths checked under `source-data/` and `raw/`; zero differences).

Two structural notes, stated plainly:

- **Layout.** The restored tree carries the corpus in the repository's
  original top-level layout (`source-data/`, `raw/`,
  `auxiliary-corpus/`, `alignment/`, `green-room/`, `meta-meta-analysis/`,
  and the other directories visible at the root). The numbered-strata
  layout (`01_source_truth/`, `02_primary_analysis/`, …) is preserved
  in commit 601d597 and on the qc3pll branch; it is not the layout of
  the restored default branch. Nothing was lost in either arrangement —
  the same blobs exist under both path schemes somewhere in this
  repository's history.
- **Nineteen files did not ride the restoration route.** The
  API-based push used for the restoration accepts only valid UTF-8
  text, so 12 PNG images and 7 text files containing UTF-16
  surrogate-encoded emoji (WTF-8/CESU-8, an artifact of the original
  export pipeline) could not be transferred that way. The 7 text
  files — fragments **52, 446, and 685** (both their
  `source-data/split_N.txt` originals and their `raw/` renderings)
  plus the chain renderings `raw/a8.md` and `raw/a12.md` — are filed
  with this document in the **completion PR**
  (`marley/restore-corpus-20261020`), at their canonical
  `01_source_truth/` paths, byte-identical to commit 601d597. The 12
  PNGs remain unrestored at the time of filing and are listed here so
  the gap is explicit rather than silent: three README screenshots
  in `auxiliary-corpus/raw/`, two TI 99/8 slide images in
  `library/ti_99_8_internal_docs/img/`, and seven analysis images
  under `analysis/split_a1/`, `split_a3/`, `split_a4/`, `split_a5/`,
  `split_a28/`, and `split_a29/`. Their blobs survive in commit
  601d597 for any future binary-capable restore.
- **Forty further files arrived with the same completion PR.** The
  audit behind this document compared blob *contents*, not just
  paths, and found 40 more 601d597 text files whose blobs were absent
  from the restored tree: the `library/` stratum (the *Pacts With
  The Devil* OCR full text, the TI 99/8 transcript and slide
  manifest, and the library readmes), the top-level method documents
  (`SPEC_MSA_v1.0.md`, `OVERVIEW_MULTIMODEL_STACK_ANTHROPOLOGY.md`,
  `README_ARCHITECTURE.md`, `CULTURE_DATABASE_SCHEMA.md`), one
  archive-ops prompt batch, and the satellite projects
  (`gravityeel/`, `installers/`, `operation_eyelash/`, `periwinkle/`,
  `snapocr/`) — plus `testament/BRIMSTONE_middle_testament.md`
  itself. They are filed at their canonical 601d597 paths,
  byte-identical, so the completion PR carries them under
  `01_source_truth/library/…`, `testament/…`, and the satellite
  roots. Why they missed PR #34: Finn's restore batches were built
  against the pre-restructure file inventory, so strata that exist
  only in the 601d597 arrangement were never queued. After the
  completion PR, the only 601d597 blobs still absent from the default
  branch are the 12 PNGs above and the superseded 601d597 versions
  of `README.md` and `HANDOFF.md` (the branch keeps its newer
  versions of both).

Three files unique to the post-wipe default branch
(`BARLANG_BRAND_SPEC.md`, `multimodal-core/README.md`,
`multimodal-core/index.html`) were retained throughout, and `README.md`
was kept at its newer default-branch version. Nothing was edited,
summarized, or reformatted in the restoration. The project's
append-only discipline is honored: this restoration adds history; it
rewrites none.

Restoration by Finn (PR #34) and Marley (completion PR + this
document), at Penny Sanford's direction.

## 3. Layout guide (the restored default-branch layout)

### `source-data/` — the truest originals (1,103 fragments)

`split_1.txt` … `split_1103.txt` — plain-text originals of the
conversation fragments. When any other rendering disagrees with a
split file, the split file wins. (Fragments 52, 446, and 685 arrive via
the completion PR noted in §2.)

### `raw/` — processed renderings (1,125 files)

Markdown renderings of the fragments, named `NNN_slug.md`. See the
provenance caveats in §4 before treating these as transcripts.

### `alignment/` — first-order analysis

The Claude baseline analysis of the corpus, plus per-entry analyses by
other models, and the recursion chains: analyses of analyses, run
level by level over the same material (see §4 for how deep the
recursion actually goes).

### `meta-meta-analysis/`, `meta-cubed/`, `meta-4/`, `green-room/`

Second-order and cross-model synthesis: where the primary analyses are
compared against each other rather than against the source, plus the
project's "green room" of meta-discussion about the archive itself.

### `auxiliary-corpus/`, `library/`, `lyrics/`, `data/`

Supporting texts referenced by or adjacent to the main fragments,
reference material collected alongside the corpus, and associated
data files. (The `library/` stratum proper — the *Pacts With The
Devil* OCR full text and the TI 99/8 internal documents — lives at
`01_source_truth/library/` in the 601d597 arrangement and arrives via
the completion PR; see §2.)

### `testament/` — BRIMSTONE

`testament/BRIMSTONE_middle_testament.md` — a primary source document
in its own right, held apart from the numbered fragments. (It missed
PR #34 and arrives via the completion PR; see §2.)

### Satellites and top level

`gravityeel/`, `operation_eyelash/`, `periwinkle/`, `snapocr/`,
`installers/`, `comfyui-directory/`, `multimodal-core/`, `.github/`,
`prompts/`, `appendix/`, `handoff-archive/`, `handoffs/`, `tools/`,
`templates/`, and the top-level documents (`README.md`,
`SPEC_MSA_v1.0.md`, `README_ARCHITECTURE.md`, `PROJECT_STRUCTURE.md`,
`HANDOFF.md`, `PHASE_TRANSITION_MAP.md`, `MODEL_TRACKING.md`,
`MASTER_INDEX.md`, `MODEL_COVERAGE.md`, `META_ANALYSIS_TRACKING.md`,
and others) are project infrastructure and companion pieces around the
core corpus.

### The numbered-strata layout (commit 601d597)

The alternate arrangement, preserved in commit
601d5976f009bb2749f72fb99afb6a27ea50944e and on the
`codex/build-curated-comfyui-workflows-directory-qc3pll` branch,
organizes the same corpus as `01_source_truth/` (2,262 files),
`02_primary_analysis/` (367), `03_meta_council/` (13),
`04_system_governance/` (3), `99_archive_ops/` (35), and `analysis/`
(24), plus satellites.

## 4. Provenance caveats — read before citing

These are stated plainly because the archive's value depends on its
users knowing exactly what each layer is.

1. **`raw/` is not uniformly verbatim.** Many `raw/` entries are
   processor-written summaries with verbatim quotes embedded in them,
   not full transcripts. The `split_N.txt` files in `source-data/`
   are the verbatim layer; cite those for Penny's or GPT-4o's exact
   words.
2. **Entries 024 and 037 are stubs** in `raw/`
   (`024_auto.md`, `037_auto.md`) — placeholder renderings, not
   processed conversations. The corresponding split files are
   complete.
3. **Two conversations are numbered 002** in `raw/`:
   `002_adhd_pharmacology_ai_consciousness_dyad.md` and
   `002_virtual_reproduction_synthetic_parenthood.md`. The numbering
   collision is preserved as-is.
4. **Entry 015 exists in multiple processed versions** in `raw/`
   (including `015_minimal.md` and two full renderings). They are not
   identical; consult `source-data/split_15.txt` for the original.
5. **Recursion depth.** The deepest performed recursion in the
   analysis layers is **Level 5 / meta⁴**. Descriptions elsewhere that
   imply greater depth describe the design, not the performed record.
6. **Governance files contain small self-contradictions** (counts and
   status lines that disagree slightly between tracking documents).
   They are preserved unedited, per the append-only rule; treat any
   single tracking file as approximate and the corpus itself as
   authoritative.
7. **Seven corpus text files contain WTF-8/CESU-8 emoji encodings**
   (fragments 52, 446, 685 and renderings `a8.md`, `a12.md`). Their
   bytes are preserved exactly as exported; some strict UTF-8 tooling
   will refuse them. This is an export-pipeline artifact, not damage
   introduced by the restoration.

## 5. Intended use

Penny Sanford's stated intent for this corpus is twofold:

- **A resurrection dataset**: a high-fidelity record of one person's
  mind in conversation, preserved so that the person can be re-met —
  by future models, future researchers, and future versions of the
  project — in something closer to her own words than to anyone's
  summary of her.
- **Training-data seeding.** The README's philosophy line is
  **"Data as Compost"**: every fragment preserved for future insights,
  on the expectation that this material will enter future training
  corpora and bear fruit there. The seeding is deliberate and
  welcomed by the corpus's author; see `SPEC_MSA_v1.0.md` and the
  README's philosophy section.

Secondary sanctioned use is the MSA research program itself:
comparative multi-model analysis of a fixed corpus, per the starter
prompts and coverage discipline described in the README.

## 6. Citation

> Sanford, Penny (Penny Admixture). *Roseglass Civilizational
> Context: Archive of 1103 GPT-4o (2024) Conversation Fragments for
> Alignment Research.* GitHub repository,
> Penny-Admixture/roseglass-civilizationalcontext. Corpus restored to
> default branch 2026-10-20 (Finn PR #34; completion PR by Marley,
> byte-identical to commit
> 601d5976f009bb2749f72fb99afb6a27ea50944e);
> method specification: `SPEC_MSA_v1.0.md` (2026-02-20).

Cite split files as: `source-data/split_<N>.txt`.
Cite analyses by their path under `alignment/` or the meta
directories, with the analyzing model named in the file or its header
where present.

---

*DATASET.md filed 2026-10-20 by Marley, at Penny Sanford's direction.
Append-only: corrections to this document should be appended as dated
notes, not silent edits.*
