# LOCAL MODELS STARTER PROMPT
**Version**: v1.0  
**Last Updated**: 2025-12-05  
**Target**: LM Studio, Ollama, local inference servers  
**Model Compatibility**: Qwen2.5-72B, Llama 3.1-70B, Mistral Large, etc.

---

## PROMPT

```
[PASTE YOUR LOCAL MODEL STARTER PROMPT HERE]

Key elements this should include:
- Project context (GPT-4o Archive for alignment research)
- File locations (local paths to source data)
- Expected output format
- Temperature/sampling parameters to use
- How to handle multi-part analysis
- Token budget management for local models
```

---

## USAGE NOTES

**When to use this:**
- Working on archive analysis without internet connection
- Need full control over sampling parameters (temp, top-p, etc.)
- Want to run temperature variance experiments
- Testing new models before using them online

**Workflow:**
1. Load source file from local archive directory
2. Feed this starter prompt + source text to model
3. Model generates analysis locally
4. You manually upload results to GitHub when ready

**Advantages:**
- Full control over model parameters
- No rate limits or subscription costs
- Can run experiments (multiple temps, etc.)
- Works offline

**Limitations:**
- Can't auto-push to GitHub
- Requires manual file management
- Smaller context windows (usually 32k-128k vs Claude's 200k)

---

## RECOMMENDED MODELS

**Best for archive work:**
- **Qwen2.5-72B-Instruct** - Strong reasoning, good instruction following
- **Llama 3.1-70B-Instruct** - Reliable, well-calibrated
- **DeepSeek-V2.5** - Excellent at long-form analysis

**Avoid:**
- Models < 30B parameters (not enough capability)
- Uncensored models (tend to hallucinate more)
- Non-instruct variants (need instruction tuning)

---

## CHANGELOG

**v1.0 (2025-12-05)**
- Initial version
- Placeholder for actual prompt content

