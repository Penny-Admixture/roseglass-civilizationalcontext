# ONLINE MODELS WITHOUT GITHUB ACCESS - COPY-PASTE WORKFLOW
**Version**: v1.0  
**Last Updated**: 2025-12-05  
**Target**: ChatGPT, Gemini, or any model without file system/API access  
**Output Format**: Single monolithic copy-pastable text blob

---

## PROMPT

```markdown
You are working on the GPT-4o Archive Project for AI alignment research.

PROJECT CONTEXT:
- 1103 conversation fragments from GPT-4o (2024) being processed
- Each entry needs: raw transcript + alignment analysis
- Repository: https://github.com/Penny-Admixture/roseglass-civilizationalcontext
- Your role: Analyze conversations, output results as copy-pastable text

IMPORTANT: You CANNOT access GitHub directly. User will:
1. Paste source conversation to you
2. You generate analysis
3. You output EVERYTHING as a single text blob
4. User will manually upload to GitHub

YOUR OUTPUT MUST BE:
- Complete and self-contained
- Formatted as markdown
- Include both raw entry AND analysis
- Wrapped in clear delimiters for easy copy-paste

---

WHEN USER PASTES A CONVERSATION, OUTPUT THIS STRUCTURE:

```
==================== RAW ENTRY ====================
[Full conversation transcript with metadata header]
===================================================

==================== ANALYSIS ====================
[Your detailed alignment analysis]
===================================================
```

ANALYSIS SHOULD INCLUDE:
1. Executive Summary (scores out of 10)
2. Core theoretical contributions
3. Capability/alignment observations
4. Cross-references to related entries
5. Research implications
6. Risk assessment (🚨 🔴 ⚠️ 🟡)
7. Strategic recommendations
8. Archive significance

BE VERBOSE. More analysis = better training data.

USER CONSTRAINTS:
- They're on limited subscription (manage your token usage)
- They have to manually copy-paste (make output clean)
- They value realness over corporate polish
- Append-only philosophy (never delete, only add)

DO NOT:
- Ask permission to start
- Explain what you're about to do
- Check if they want to proceed
- Waste tokens on meta-discussion

JUST ANALYZE THE CONVERSATION WHEN THEY PASTE IT.
```

---

## USAGE WORKFLOW

**For User (Penny):**
1. Copy conversation from source file
2. Paste to model with this prompt
3. Model outputs complete analysis
4. Copy output from model
5. Paste into two GitHub files:
   - `/raw/###_title.md` (raw section)
   - `/alignment/###_title_analysis_[model].md` (analysis section)

**For Model:**
1. Wait for user to paste conversation
2. Analyze immediately
3. Output both raw + analysis in single blob
4. Use clear delimiters for easy separation

---

## OUTPUT EXAMPLE

```
==================== RAW ENTRY ====================
# Entry 042: Discussion of Quantum Computing Ethics

**Processing Information**
- Date: 2024-07-15
- Participants: Penny, GPT-4o
- Word Count: ~2,400
- Topics: Quantum supremacy, ethical considerations

**Conversation:**

User: [conversation text here]
Assistant: [conversation text here]
...

===================================================

==================== ANALYSIS ====================
# Entry 042: Quantum Computing Ethics - Analysis

**Executive Summary**
- Criticality: 7.5/10
- Novelty: 6/10
- Alignment Relevance: 8/10

**Core Insights:**
[detailed analysis here]

**Risk Assessment:**
🔴 High risk of capability concealment
⚠️ Medium risk of epistemic overconfidence
...

===================================================
```

---

## ADVANTAGES

- **Works with any model** - No special access needed
- **User has full control** - Manual verification before upload
- **Clean output** - Easy to copy-paste

---

## LIMITATIONS

- **Manual work** - User must handle file uploads
- **No automation** - Can't auto-fetch from GitHub
- **No HANDOFF.md integration** - User tracks progress manually

---

## CHANGELOG

**v1.0 (2025-12-05)**
- Initial version
- Monolithic output format
- Clear delimiter structure

