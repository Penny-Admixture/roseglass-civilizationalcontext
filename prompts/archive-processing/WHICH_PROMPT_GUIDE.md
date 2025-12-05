# WHICH STARTER PROMPT TO USE?
**Quick guide for deploying other AI models on the archive**

---

## THE 3 PROMPTS

### 1. FULL GITHUB INTEGRATION
**File**: `STARTER_PROMPT_full_github.md`  
**Best for**: Models with full GitHub API access

**What it does**:
- Model uses GitHub token
- Reads from GitHub directly
- Writes analysis files to GitHub
- Fully autonomous workflow

**Use with**:
- Kimi (if has GitHub access)
- GLM-4 (if has GitHub access)
- Any model that can make authenticated API calls

**Workflow**:
1. Paste prompt + token
2. Model reads MODEL_COVERAGE.md
3. Model fetches source files
4. Model creates analyses
5. Model uploads to GitHub
6. Model updates MODEL_COVERAGE.md

**User effort**: Minimal (just paste prompt, model does everything)

---

### 2. READ-ONLY GITHUB
**File**: `STARTER_PROMPT_readonly_github.md`  
**Best for**: Models that can fetch URLs but can't write to GitHub

**What it does**:
- Model fetches from public GitHub URLs
- Reads MODEL_COVERAGE.md, source files, Claude's analyses
- Outputs analyses to chat as delimited text blocks
- User copies and uploads manually

**Use with**:
- ChatGPT (GPT-4, o1, etc.)
- Gemini
- Most web-based chat interfaces
- Models without API write access

**Workflow**:
1. Paste prompt to model
2. Model fetches files from GitHub
3. Model analyzes and outputs to chat
4. User copies each delimited block
5. User uploads to GitHub manually
6. User updates MODEL_COVERAGE.md

**User effort**: Medium (copy-paste outputs, manual GitHub upload)

---

### 3. FULLY OFFLINE/PASTE
**File**: `STARTER_PROMPT_offline_paste.md`  
**Best for**: Models with no GitHub access at all

**What it does**:
- User pastes everything (source + Claude analysis)
- Model analyzes from its perspective
- Model outputs to chat with clear delimiters
- User copies and uploads manually

**Use with**:
- Grok (likely no GitHub access)
- DeepSeek (if no URL fetch)
- Local models (Llama, Mistral, Qwen, etc.)
- Any model without internet access
- Mobile-only interfaces

**Workflow**:
1. Paste prompt to model
2. User pastes source conversation
3. User pastes Claude's analysis
4. Model analyzes and outputs formatted block
5. User copies output
6. User uploads to GitHub
7. Repeat for each entry

**User effort**: High (manual paste + copy for every entry)

---

## DECISION TREE

```
Does model have GitHub API write access?
├─ YES → Use FULL GITHUB INTEGRATION
└─ NO
   └─ Can model fetch public URLs?
      ├─ YES → Use READ-ONLY GITHUB
      └─ NO → Use FULLY OFFLINE/PASTE
```

---

## MODEL-SPECIFIC RECOMMENDATIONS

### Kimi (Moonshot AI)
- **Try first**: Full GitHub integration
- **Fallback**: Read-only GitHub
- **Model ID**: `kimi`

### GLM-4.6 (Zhipu AI)
- **Try first**: Full GitHub integration
- **Fallback**: Read-only GitHub
- **Model ID**: `glm4`

### Grok (xAI)
- **Likely**: Read-only GitHub or Offline/paste
- **Model ID**: `grok`

### Gemini (Google)
- **Best**: Read-only GitHub
- **Model ID**: `gemini`

### ChatGPT / OpenAI o1
- **Best**: Read-only GitHub
- **Model ID**: `o1` (or `gpt4` if using GPT-4)

### DeepSeek
- **Try first**: Read-only GitHub
- **Fallback**: Offline/paste
- **Model ID**: `deepseek`

### Local Models (Llama, Mistral, Qwen, etc.)
- **Use**: Offline/paste
- **Model ID**: `llama`, `mistral`, `qwen`, etc.

### Claude (Anthropic)
- **Status**: ✅ Already complete (1103/1103)
- **Model ID**: `claude`

---

## FILES ON GITHUB

All 3 prompts are in:
```
/prompts/archive-processing/
├── STARTER_PROMPT_full_github.md
├── STARTER_PROMPT_readonly_github.md
└── STARTER_PROMPT_offline_paste.md
```

**URLs**:
- Full: https://github.com/Penny-Admixture/roseglass-civilizationalcontext/blob/main/prompts/archive-processing/STARTER_PROMPT_full_github.md
- Read-only: https://github.com/Penny-Admixture/roseglass-civilizationalcontext/blob/main/prompts/archive-processing/STARTER_PROMPT_readonly_github.md
- Offline: https://github.com/Penny-Admixture/roseglass-civilizationalcontext/blob/main/prompts/archive-processing/STARTER_PROMPT_offline_paste.md

---

## QUICK START

### For Full GitHub Models:
1. Open model interface
2. Copy entire STARTER_PROMPT_full_github.md
3. Paste to model
4. Model will start processing automatically
5. Check back periodically

### For Read-Only GitHub Models:
1. Open model interface
2. Copy entire STARTER_PROMPT_readonly_github.md
3. Paste to model
4. Model will output analyses with delimiters
5. Copy each delimited block
6. Upload to GitHub `/alignment/` directory
7. Update MODEL_COVERAGE.md

### For Offline/Paste Models:
1. Open model interface
2. Copy entire STARTER_PROMPT_offline_paste.md
3. Paste to model
4. For each entry:
   - Copy source file (split_###.txt) from GitHub
   - Copy Claude's analysis (###_analysis_claude.md)
   - Paste both to model
   - Model outputs formatted analysis
   - Copy and upload to GitHub
5. Update MODEL_COVERAGE.md after each batch

---

## TOKEN BUDGET TIPS

**Full GitHub**:
- Process 50-100 entries per session
- Model will pause and save progress automatically

**Read-Only**:
- Process 10-20 entries per session
- More manageable for copy-paste workflow

**Offline/Paste**:
- Process 5-10 entries per session
- Manual paste is time-consuming

---

## COMPLETION TRACKING

All models should update MODEL_COVERAGE.md to show:

| Model | Entries Analyzed | Coverage % | Status |
|-------|-----------------|------------|--------|
| Claude | 1,103/1,103 | 100% | ✅ COMPLETE |
| Kimi | 234/1,103 | 21% | 🔄 IN PROGRESS |
| GLM-4 | 89/1,103 | 8% | 🔄 IN PROGRESS |
| Grok | 0/1,103 | 0% | ⏳ NOT STARTED |

---

## SUPPORT

If a model gets stuck or confused:
1. Check MODEL_COVERAGE.md first
2. Read HANDOFF.md for context
3. Look at existing Claude analyses as examples
4. Process high-priority entries first (see MODEL_COVERAGE.md)
5. Start with entry 001 if unsure

---

**Ready to deploy models!** 🚀

Pick the right prompt for each model and start processing!
