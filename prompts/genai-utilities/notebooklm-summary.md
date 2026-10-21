# NOTEBOOKLM SUMMARY PROMPT
**Version**: v1.0  
**Last Updated**: 2025-12-05  
**Target**: NotebookLM or any model processing documents/audio  
**Use Case**: Extracting detailed summaries with complete transcripts

---

## PROMPT

```
can you give a detailed summary of what this is about, include a full verbatim complete transcript as the last appendix of your response ok?
```

---

## KEY FEATURES

**Two-Part Output:**

**Part 1: Detailed Summary**
- Comprehensive overview of content
- Key themes and topics
- Main points and arguments
- Context and background

**Part 2: Complete Transcript Appendix**
- Full verbatim transcript
- Placed at end of response
- Preserves exact wording
- Reference material for verification

**Use Cases:**
- Processing NotebookLM audio outputs
- Analyzing podcast episodes
- Documenting lectures or presentations
- Archiving conversations
- Creating searchable text from audio/video

---

## USAGE NOTES

**When to use:**
- You need both summary AND raw transcript
- Archiving spoken content as text
- Want to verify summary against source
- Building searchable text databases
- NotebookLM audio review sessions

**Best models:**
- **NotebookLM** - Native platform use case
- **Claude** - Strong summarization + transcription
- **GPT-4** - Good for both tasks
- **Gemini** - Handles long-form content well

**Output structure:**
```
[Detailed Summary - 200-500 words]
- Overview
- Key themes
- Main arguments
- Context

---

APPENDIX: COMPLETE TRANSCRIPT

[Full verbatim transcript]
[Preserves all content]
[For reference and verification]
```

---

## VARIATIONS

**Short Form:**
```
Summarize this briefly and include the full transcript at the end.
```

**Deep Analysis:**
```
Provide detailed analysis of this content with thematic breakdown, key insights, and argument structure. Append full verbatim transcript for reference.
```

**Multi-Source:**
```
Summarize these documents/recordings and include complete transcripts of each as separate appendices.
```

---

## EXAMPLE USE CASE

**NotebookLM Audio Review:**
1. Upload documents to NotebookLM
2. Generate audio overview
3. Feed audio back to AI with this prompt
4. Get: Summary of what NotebookLM said + transcript for reference
5. Archive both summary and transcript

**Result:** Searchable, documented version of audio content

---

## CHANGELOG

**v1.0 (2025-12-05)**
- Initial version with Penny's prompt
- Two-part summary + transcript structure
- NotebookLM use case documented
