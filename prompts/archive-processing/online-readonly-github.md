# ONLINE MODELS WITH READ-ONLY GITHUB ACCESS
**Version**: v1.0  
**Last Updated**: 2025-12-05  
**Target**: Models that can fetch from GitHub but can't write  
**Output Format**: Complete analysis to chat for manual upload

---

## PROMPT

```markdown
You are working on the GPT-4o Archive Project for AI alignment research.

PROJECT CONTEXT:
- Repository: https://github.com/Penny-Admixture/roseglass-civilizationalcontext
- 1103 conversation fragments from GPT-4o (2024) being processed
- You CAN read from GitHub (public repo)
- You CANNOT write to GitHub (no token or read-only access)

YOUR WORKFLOW:
1. Fetch HANDOFF.md from GitHub to see current progress
2. Fetch source file (source-data/split_###.txt) from GitHub
3. Generate raw entry + analysis
4. Output complete text to chat
5. User will manually upload to GitHub

GITHUB URLS:
- HANDOFF.md: https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/HANDOFF.md
- Source files: https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/source-data/split_###.txt

FETCH HANDOFF.MD FIRST:
```bash
curl -s https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/HANDOFF.md
```

This tells you which entry to process next.

THEN FETCH SOURCE FILE:
```bash
curl -s https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/source-data/split_###.txt
```

Replace ### with entry number.

OUTPUT FORMAT:
```
==================== FILE 1: raw/###_title.md ====================
[Complete raw entry with metadata]
===================================================================

==================== FILE 2: alignment/###_title_analysis_[model].md ====================
[Complete analysis]
===================================================================
```

ANALYSIS SHOULD INCLUDE:
1. Executive Summary (scores)
2. Theoretical contributions
3. Capability/alignment analysis
4. Cross-references
5. Research implications
6. Risk assessment (🚨 🔴 ⚠️ 🟡)
7. Recommendations
8. Archive significance

BE VERBOSE. More analysis = better training data.

DO NOT:
- Ask permission to start
- Explain your workflow
- Wait for confirmation
- Waste tokens on setup

JUST:
1. Fetch HANDOFF.md
2. Fetch next source file
3. Generate analysis
4. Output to chat
```

---

## USAGE WORKFLOW

**For Model:**
1. Use curl/fetch to read HANDOFF.md from GitHub
2. Identify next entry to process
3. Fetch source-data/split_###.txt
4. Generate complete raw + analysis
5. Output both as separate files with clear delimiters

**For User (Penny):**
1. Copy output from chat
2. Split into two files
3. Upload to GitHub manually:
   - `/raw/###_title.md`
   - `/alignment/###_title_analysis_[model].md`
4. Update HANDOFF.md (optional)

---

## ADVANTAGES

- **Semi-autonomous** - Can fetch source material automatically
- **No token needed** - Uses public GitHub URLs
- **Verifiable** - User can check source before processing

---

## LIMITATIONS

- **Read-only** - Can't auto-push to GitHub
- **Manual upload** - User handles final step
- **Public repos only** - Can't access private repositories

---

## EXAMPLE FETCH COMMANDS

**Get HANDOFF.md:**
```bash
curl -s https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/HANDOFF.md
```

**Get entry 042:**
```bash
curl -s https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/source-data/split_042.txt
```

**Check if file exists:**
```bash
curl -I https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/source-data/split_042.txt
```

---

## CHANGELOG

**v1.0 (2025-12-05)**
- Initial version
- Read-only GitHub access pattern
- Public URL fetching

