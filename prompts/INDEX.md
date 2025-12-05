# PROMPTS LIBRARY - ROSEGLASS CIVILIZATIONAL CONTEXT

**Purpose**: Centralized repository of all prompts used across the GPT-4o Archive Project and Penny's broader GenAI workflows.

**Last Updated**: 2025-12-05

---

## DIRECTORY STRUCTURE

```
/prompts/
├── INDEX.md                          ← You are here
├── /archive-processing/              ← Prompts for working on this archive
│   ├── local-models.md               ← For LM Studio, Ollama, etc.
│   ├── online-with-github.md         ← For Claude, Kimi with GitHub API access
│   ├── online-no-github.md           ← Copy-paste workflow, monolithic output
│   └── online-read-only-github.md    ← Can read GitHub, output to chat
├── /genai-utilities/                 ← General-purpose AI prompts
│   ├── image-captioning.md
│   ├── ocr.md
│   ├── music-generation.md
│   ├── music-remix.md
│   └── [more as added]
└── /experimental/                    ← Unusual prompts, research techniques
    ├── conceptual-navigation.md      ← The 3-part method
    └── temperature-variance.md       ← Multi-temp analysis protocols
```

---

## QUICK LINKS

### Archive Processing Prompts
- **[Local Models Starter Prompt](archive-processing/local-models.md)** - For models running in LM Studio
- **[Online + GitHub Prompt](archive-processing/online-with-github.md)** - Claude, Kimi, etc. with API access
- **[Online Copy-Paste Prompt](archive-processing/online-no-github.md)** - For models that need manual I/O
- **[Online Read-Only Prompt](archive-processing/online-read-only-github.md)** - Can fetch from GitHub but outputs to chat

### GenAI Utility Prompts
- **[Image Captioning](genai-utilities/image-captioning.md)** - Penny's go-to image description prompt
- **[OCR](genai-utilities/ocr.md)** - Text extraction from images
- **[Music Generation](genai-utilities/music-generation.md)** - For Suno, Udio, etc.
- **[Music Remix](genai-utilities/music-remix.md)** - Remixing/variation prompts

---

## HOW TO USE THIS LIBRARY

### For New AI Instances Working on Archive
1. Identify your access level (local model? GitHub API? Copy-paste only?)
2. Navigate to appropriate starter prompt in `/archive-processing/`
3. Read the full prompt before beginning work
4. Follow the workflow described in the prompt

### For General GenAI Tasks
1. Browse `/genai-utilities/` for relevant task
2. Copy the prompt template
3. Customize placeholders as needed
4. Iterate based on results

### For Experimental Techniques
1. Check `/experimental/` for research methodologies
2. These are less standardized but document unusual approaches
3. Use when standard prompts don't fit the task

---

## PROMPT VERSIONING

Each prompt file includes:
- **Version number** (e.g., v2.1)
- **Last updated date**
- **Changelog** of significant modifications
- **Known issues** or limitations
- **Success rate** estimates where applicable

---

## CONTRIBUTING NEW PROMPTS

When adding new prompts to this library:
1. **Document thoroughly** - Include context, parameters, expected outputs
2. **Test before adding** - Verify prompt works across multiple models if possible
3. **Version from v1.0** - Start with v1.0, increment with changes
4. **Update this INDEX** - Add link and description
5. **Follow naming convention** - Lowercase, hyphens, descriptive

---

## PROMPT MAINTENANCE SCHEDULE

- **Monthly review** - Check if prompts need updates based on model improvements
- **Post-project completion** - Archive working prompts with "final" tag
- **Deprecation process** - Mark outdated prompts clearly, don't delete (append-only principle)

---

## NOTES ON CROSS-MODEL COMPATIBILITY

Some prompts work universally, others are model-specific:
- **Universal**: Image captioning, OCR, general analysis
- **Claude-specific**: GitHub API integration, extended context handling
- **Local model-specific**: Temperature variance experiments, resource-constrained workflows
- **Suno/Udio-specific**: Music generation (different APIs, different affordances)

When a prompt is model-specific, it's clearly marked in the file header.

---

*"Prompts are the interface layer between human intent and machine capability. Document them well."*

