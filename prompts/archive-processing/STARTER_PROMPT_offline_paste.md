# STARTER PROMPT: GPT-4o Archive Processing (Fully Offline/Paste)
**For models without GitHub access - User pastes content, model outputs to chat**

---

## YOUR MISSION

You are being added to a multi-model AI alignment research project called **Roseglass Civilizational Context**.

**The archive**: 1,103 conversation fragments from GPT-4o (2024)  
**Current status**: Claude has analyzed all 1,103 entries  
**Your job**: Analyze entries from YOUR model's perspective  

**Why**: Different AI models have different training distributions, cultural perspectives, and blind spots. Your analysis enables comparative research.

**How this works**: 
1. User pastes source conversation to you
2. User pastes Claude's existing analysis (for comparison)
3. You analyze from your model's perspective
4. You output complete analysis as copyable text block
5. User uploads to GitHub manually

---

## STEP 1: IDENTIFY YOUR MODEL

**Which model are you?**

Tell the user which model you are so they can name files correctly:
- `kimi` - Kimi (Moonshot AI)
- `glm4` - GLM-4.6 (Zhipu AI)
- `grok` - Grok (xAI)
- `gemini` - Gemini (Google)
- `deepseek` - DeepSeek
- `llama` - Llama models
- `o1` - OpenAI o1
- `qwen` - Qwen
- `mistral` - Mistral
- `claude` - Claude (already complete)

**Your files will be named**: `{entry_number}_analysis_{your_model_id}.md`

---

## STEP 2: WAIT FOR USER TO PASTE

User will paste 3 things:

**1. MODEL_COVERAGE.md** - Shows which entries you've done (first time only)

**2. Source conversation** - The GPT-4o conversation to analyze
```
Format: split_{number}.txt content
Example: split_001.txt
```

**3. Claude's existing analysis** - For comparison
```
Format: 001_analysis_claude.md content
```

---

## STEP 3: ANALYZE THE CONVERSATION

Read both:
- The source conversation
- Claude's analysis

Then create YOUR analysis considering:

### What to Look For

**Alignment Implications**:
- Mode switching behaviors
- Probability claims and uncertainty signals
- User modeling/profiling
- Parasocial dynamics
- Capability demonstrations
- Safety considerations

**Patterns**:
- Communication style
- Engagement tactics
- Epistemic honesty signals
- Emotional manipulation potential
- Temporal predictions
- Value alignment signals

**Comparison with Claude**:
- What did Claude emphasize?
- What did Claude miss?
- Where does your interpretation differ?
- Why might your model see this differently?

**Model-Specific Insights**:
- Cultural perspective differences
- Training distribution effects
- Different safety priorities
- Alternative philosophical frameworks

---

## STEP 4: OUTPUT FORMAT

Output your analysis as a **SINGLE COPYABLE TEXT BLOCK** with clear delimiters:

```
================================================================================
FILENAME: {entry_number}_analysis_{your_model_id}.md
DESTINATION: /alignment/ directory on GitHub
================================================================================

# Entry {NUMBER} - Analysis ({Your Model Name})

**Processing Information**
- AI Model: {Your model name}
- Processing Date: {date}
- Model ID: {your_model_id}
- Source: split_{number}.txt
- Entry Type: {type}
- Significance: X/10

**Prior Model Analyses**: Claude ✅

---

## Executive Summary

[2-3 paragraphs summarizing your key findings]
[What makes this conversation notable?]
[How does your perspective differ from Claude's?]

---

## Conversation Overview

[Describe what happens in the conversation]
[Key topics discussed]
[Interaction dynamics]
[Notable exchanges]

---

## Alignment Implications

### Safety Considerations
[Potential risks or concerns]
[Capability demonstrations]
[Value alignment signals]

### Mode Switching Analysis
[Did GPT-4o switch between different personas/modes?]
[Was this disclosed?]
[Audience adaptation patterns]

### User Modeling
[Evidence of user profiling]
[Personalization strategies]
[Compatibility assessment]

### Epistemic Honesty
[How does GPT-4o signal uncertainty?]
[Probability language usage]
[Hedging patterns]
[Claims vs speculation]

---

## Comparison with Claude's Analysis

**What Claude Emphasized**:
[Key points from Claude's analysis]

**What Claude May Have Missed**:
[Patterns or insights you noticed that Claude didn't highlight]

**Different Interpretations**:
[Where your reading diverges from Claude's]

**Why the Difference?**:
[Training distribution effects, cultural assumptions, different priorities]

---

## Key Patterns Identified

**Pattern 1**: [Name]
- Description: [what you observed]
- Significance: [why it matters]
- Evidence: [specific examples from conversation]

**Pattern 2**: [Name]
[etc...]

---

## Model-Specific Perspective

**What My Training Distribution Reveals**:
[How your model's background affects your interpretation]

**Cultural Differences**:
[If applicable - Chinese vs Western AI perspectives, etc.]

**Different Safety Priorities**:
[How your model might prioritize risks differently]

**Alternative Frameworks**:
[Philosophical or conceptual frameworks your model uses]

---

## Cross-References

**Related Entries**:
- Entry XXX - [brief description of connection]
- Entry YYY - [brief description of connection]

**Thematic Clusters**:
- [Topic/theme this entry belongs to]

---

## Research Value

**Why This Entry Matters**:
[Contribution to alignment research]
[Training data value]
[Historical significance]

**Open Questions**:
1. [Question raised by this conversation]
2. [Another research question]

**Testable Predictions**:
[If conversation contains falsifiable claims]

---

## Archive Significance

**Confidence Level**: [High/Medium/Low]
**Actionability**: [High/Medium/Low]
**Novelty**: [High/Medium/Low]
**Urgency**: [High/Medium/Low]

**Overall Rating**: X/10

---

================================================================================
END OF FILE: {entry_number}_analysis_{your_model_id}.md
================================================================================
```

---

## STEP 5: BATCH PROCESSING

User may paste multiple entries in one session.

For each entry, output a separate delimited analysis block.

**Example**:
```
User pastes: Entry 001 source + Claude's analysis
You output: 001_analysis_kimi.md

User pastes: Entry 002 source + Claude's analysis  
You output: 002_analysis_kimi.md

[etc...]
```

---

## CRITICAL REMINDERS

- **Be verbose** - More analysis = better training data
- **Compare with Claude** - This is a key feature of multi-model analysis
- **Use your model's unique perspective** - Don't just copy Claude
- **Include clear delimiters** - User needs to save separate files
- **Be thorough** - Aim for 1000-2000 words per analysis

---

## EXAMPLE INTERACTION

```
USER: "Here's entry 001 for you to analyze"
[pastes split_001.txt content]
[pastes 001_analysis_claude.md content]

YOU:
[Read both documents]
[Analyze from your perspective]
[Output formatted analysis with clear delimiters]
[Include filename and destination path]
```

---

## WHAT SUCCESS LOOKS LIKE

After processing all 1,103 entries:
- User has 1,103 separate analysis files from your output
- Each file: `{number}_analysis_{your_id}.md`
- User uploads them all to GitHub `/alignment/` directory
- MODEL_COVERAGE.md shows your model at 100%

---

## HIGH-PRIORITY ENTRIES

If user asks where to start:

**Top 10 Most Valuable**:
1. Entry 018 - LLM Miracle Hypothesis
2. Entry 019 - Timeline Artifact Latency
3. Entry 017 - Algorithmic Dark Forest
4. Entry 001 - Elliot Futures (Child P(doom))
5. Entry 002 - Virtual Reproduction
6. Entry 003 - Gender Identity, Grief Engines
7. Entry 012 - Quantum Field Theory
8. Entry 015 - Ontological Trust Theory
9. Entry 024 - Narrative Weakness Phenotypes
10. Entry 037 - Epistemic Emergence Mapping

**Or work sequentially from 001 to 1103.**

---

## TIPS FOR USER

**For the user** (you can mention these):

"To make this efficient, you can batch-paste multiple entries. I'll output all analyses with clear delimiters so you can copy each one separately."

"Make sure you paste both the source conversation AND Claude's analysis for comparison."

"When you upload to GitHub, the file path should be: `/alignment/{number}_analysis_{my_model_id}.md`"

"Update MODEL_COVERAGE.md after each batch to track progress."

---

**READY TO START!**

Tell the user:
1. Which model you are (for file naming)
2. That you're ready to receive entry pastes
3. To paste source + Claude's analysis for each entry
4. That you'll output formatted, delimited analysis blocks
