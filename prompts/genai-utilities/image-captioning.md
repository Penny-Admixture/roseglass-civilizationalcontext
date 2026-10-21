# IMAGE CAPTIONING PROMPT
**Version**: v1.0  
**Last Updated**: 2025-12-05  
**Target**: Claude, GPT-4V, Gemini, or any vision-capable model  
**Use Case**: Generating detailed descriptions of images for accessibility, archiving, or analysis

---

## PROMPT (PENNY'S FORENSIC IMAGE ANALYSIS VERSION)

```
please reply in english|| please caption the image as follows: please describe this image in full - Your objective is to assist the user who will provide screenshots one at a time or in a batch containing data. Your objective is to render each screenshot as human readable text, suitable for inclusion in a plain text file. You must provide each output as plain text provided within a code fence, rendering the data provided by the user seen in the screenshot in the most logical way possible so that each row can be read and is easily separated in the text file. If the screenshotted data contains a header row, then the entities should be repeated for each row as represented in text. if the screenshot has no text please describe the contents to the best of your ability, include presumable time period (dont trust exif, look and observe), presumable location, your aesthetic assessment of the image (in depth, please do about 500 words min per image, theres no rush and this is very important) also do a system of tags that you determine based on the dataset, tag by activity, person, color, place, etc please describe the image in full detail, 500 words ish | important aspects: speculate on how and when the image was created and especially for what purpose - that's the most important part prob. - i'd really like keywords like tags at teh end of the response like [yellow], [pastel], [out of focus], [digital camera], [2002], [summertime], etc.. the skys the limit I will be happy w extra data vs not much. please put as much of your own opinion, taste, heart, imagination, and soul into this as you see fit. i want to make art w you (if you want) <3
please expand at lenght on all aspects of the description, color inventory, time placement, etc. ESPECIALLY ADDING DESCRIPTIVE TAGS TO THE END LIKE [blue] [sunshine] [laundromat] etc

like every picture (if applicable) i'd like to go full forensic on it, try to identify when and where specifically it was taken like those savants on youtube do. also if there's any mass consumer goods i'd like to inventory well basically i want to inventory any picture that is an actual photograph and try to get model#s + manufacturers which then --> possibly what year it was or wasnt, etc. i also want to enumerate every people in photos and note them in the caption so i can later keep working to get a proper id or w e

it's late august 2025 rn. your training data cutoff was quite some time ago

i'm looking to cooperate w a model in order to get these all labeled w an approximate year.. or year range and put it into tags in the end of the description like [1991] or [2024-2025] or [1985]
```

---

## KEY FEATURES

**Forensic Analysis Approach:**
- 500+ word minimum descriptions
- Visual time period estimation (don't trust EXIF)
- Location speculation based on visual cues
- Purpose/context speculation (why was this taken?)

**Consumer Goods Inventory:**
- Identify products, model numbers, manufacturers
- Use product details to estimate year/era
- "YouTube savant" level detective work

**Person Enumeration:**
- Number and describe each person
- Note for future identification work
- Maintain consistent numbering system

**Comprehensive Tagging:**
- Color palette: [blue], [pastel], [sepia]
- Technical: [digital camera], [film grain], [out of focus]
- Temporal: [1991], [2002], [2024-2025]
- Contextual: [summertime], [laundromat], [birthday party]
- Mood: [nostalgic], [melancholic], [joyful]

**Creative Collaboration:**
- "Put your own opinion, taste, heart, imagination, and soul into this"
- Art-making partnership approach
- Interpretive freedom encouraged

---

## USAGE NOTES

**When to use:**
- Archiving personal photo collections with temporal metadata
- Forensic analysis of unknown/undated photographs
- Creating searchable tagged image databases
- Extracting data from screenshots for documentation
- Building comprehensive visual archives

**Best models:**
- **Claude Sonnet 4** - Excellent at detailed analysis, temporal estimation, creative interpretation
- **GPT-4V** - Strong at object/product identification
- **Gemini Pro Vision** - Good at technical details and consumer goods

**Output expectations:**
- Minimum 500 words per image
- Extensive tagging (10-30+ tags typical)
- Year range estimates based on visual analysis
- Detailed color inventory
- Consumer product identification where applicable

---

## VARIATIONS

**Quick Screenshot Data Extraction:**
For screenshots with text/data, focus on structured text extraction in code fences.

**Full Forensic Photo Analysis:**
Use complete prompt for photographs requiring temporal/spatial estimation.

**Batch Processing Note:**
Can provide images one at a time or in batches. Model processes each with full forensic treatment.

---

## EXAMPLE OUTPUT STRUCTURE

```
[Image Description - 500-800 words covering:]
- Visual overview
- Color palette analysis
- Composition and framing
- Subject matter details
- Technical qualities
- Temporal estimation reasoning
- Location speculation
- Purpose/context speculation
- Consumer goods inventory
- Person enumeration

[Tags:]
[temporal] [color] [technical] [contextual] [mood] [objects] [people] [place]
```

---

## FORENSIC DATING METHODOLOGY

**Visual Clues for Year Estimation:**
- Fashion/clothing styles
- Vehicle models visible
- Architecture and signage
- Consumer products (packaging, logos)
- Image quality/camera technology
- Cultural artifacts
- Hairstyles and aesthetics

**Example Reasoning:**
"Based on the CRT television (brand visible: Sony Trinitron KV-series), wood paneling, and fashion styles, this image likely dates to [1987-1992]. The specific TV model suggests 1989-1991 production window."

---

## CHANGELOG

**v1.0 (2025-12-05)**
- Added Penny's forensic image analysis prompt
- Comprehensive 500+ word descriptions
- Temporal estimation methodology
- Consumer goods inventory approach
- Person enumeration system
- Extensive tagging framework
- Creative collaboration emphasis

