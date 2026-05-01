# Barlang + Gold Chloride Brand System

## 0) Scope
This document is an implementation-ready specification for:
- Recreating the target calendar widget aesthetic.
- Extending that aesthetic into a full cross-channel brand system (web, print, signage, motion/video).
- Integrating `||||lang` (Barlang) as a visual-structural layer.

## 1) Core Creative Direction
**Working title:** `AURIC BARLANG`

**Aesthetic sentence:** Mid-century institutional modernism (BBN / RAND / IBM / General Dynamics) reinterpreted for 2045 with sparse horizontal dividers, vertical rhythm stacks (`| || |||`), and selective Unicode scientific glyph ornament.

**Primary brand color domain:** the visual metaphor of **gold chloride dissolved in glass**.

### 1.1 Color Intent
Gold chloride in glass historically trends toward ruby/cranberry to magenta-red under transmitted light, with amber-gold highlights in reflective contexts. The brand should model this as a dual-state palette:
- **Transmitted-light state:** deep ruby / wine / magenta
- **Reflective accent state:** electric gold / brass micro-highlights

## 2) Color System (Tokenized)

### 2.1 Core Tokens
- `--bg-0`: `#F7F5F2` (warm paper off-white)
- `--bg-1`: `#E9E5DE` (desaturated card/backdrop)
- `--ink-0`: `#171614` (near-black text)
- `--ink-1`: `#4E4A45` (secondary text)

### 2.2 Auric-Ruby Axis
- `--auric-ruby-900`: `#3A0D18`
- `--auric-ruby-700`: `#6D102A`
- `--auric-ruby-500`: `#9C1F45`
- `--auric-ruby-300`: `#C84D74`
- `--auric-gold-600`: `#C98A12`
- `--auric-gold-400`: `#E0B247`

### 2.3 Activity Meter Colors
Desaturated backgrounds + highly saturated accents:
- Idle bg/accent: `#DDE3E4` / `#007A87`
- Engage bg/accent: `#E8E2D8` / `#C98A12`
- High bg/accent: `#E8D9DB` / `#C2185B`
- Critical bg/accent: `#E3D5D8` / `#7A0036`

## 3) Typography System

### 3.1 Type Families
- **Primary UI Sans:** Inter / IBM Plex Sans / Söhne-style geometric grotesk
- **Editorial Serif (optional):** IBM Plex Serif for print pull quotes
- **Monospace:** IBM Plex Mono for code/Barlang source blocks

### 3.2 Typographic Rules
- Titles: 600–700 weight, tracking `-0.01em`
- Labels: uppercase, 11–12px, tracking `0.06em`
- Body: 15–17px with 1.45 line height
- Numeric/calendar cells: tabular numbers preferred

## 4) Structural Grammar (Horizontal + Vertical)

### 4.1 Base Layout Law
1. Divide vertical page space into stacked bands.
2. Use **sparing horizontal lines** to separate bands.
3. Organize content in each band by offset columns using visual counts:
   - `|` minor
   - `||` medium
   - `|||` major

### 4.2 Line Weights
- Hairline: 1px (`--ink-1` at 24% opacity)
- Standard divider: 1.5px
- Emphasis divider: 2px in `--auric-ruby-500`

### 4.3 Spacing Grid
- Base unit = 8px
- Major vertical rhythm = 24px
- Section rhythm = 48px

## 5) Barlang Visual Spec (v1)

### 5.1 Primitive Set
- Pipes: `|`, `||`, `|||`, `||||`
- Enclosures: `<< >>`, `⌈ ⌉`, `⌊ ⌋`, `⟦ ⟧`
- Signal glyphs: `⋮ ⋱ ⋰ ⋯ ⊹ ⊱ ⊳ ∆ ∇ ∎ ‖`

### 5.2 Usage Modes
- **Semantic mode:** glyphs have explicit meaning (state, privacy, system level)
- **Pure visual mode:** glyphs are decorative cadence marks; no semantic claim

### 5.3 Accessibility Constraint
Any decorative glyph sequence must have a plain-language alternate label in aria/title/context text.

## 6) Calendar Widget Recreation Spec

### 6.1 Dimensions and Surface
- Width: 320px
- Height: 360px
- Radius: 10px
- Shadow: `0 8px 24px rgba(23,22,20,.08)`
- Border: `1px solid rgba(23,22,20,.12)`

### 6.2 Internal Layout
- Header row: month/year + controls
- Weekday row: uppercase condensed labels
- 7x6 day matrix
- Footer row: action controls

### 6.3 Interaction States
- Hover day: soft desaturated fill
- Selected day: filled `--auric-ruby-500`, white text
- Today ring: 1.5px `--auric-gold-400`
- Focus-visible: 2px outline with 2px offset

### 6.4 Barlang Layer (Optional Toggle)
- Show subtle header marker: `||<<CAL>>||`
- Optionally replace weekday labels with symbolic mini-tags
- Preserve machine-readable date values under all visual substitutions

## 7) Web Design Language

### 7.1 Components
- Top nav with horizontal anchor line
- Panel cards with sparse top border accent
- Activity meter component using `⋮ ⋱ ⋰ ⋯`
- Barlang callout blocks: `||<<label>>||`

### 7.2 CSS Token Contract
Provide all colors/spacing/type as CSS custom properties in `:root` and `[data-theme]` variants.

### 7.3 Motion
- Duration bands: 120ms / 240ms / 420ms
- Easing: `cubic-bezier(.2,.8,.2,1)`
- Motion language: glide + settle, no bounce

## 8) Print System

### 8.1 Letterhead
- Top left: wordmark
- Top right: `||` stack marker
- Horizontal rule at y=28mm
- Body block starts y=40mm
- Footer microline with Unicode ornament at 8% tint

### 8.2 Business Documents
- Section starts with compact Barlang divider
- Tables use minimal borders and strong column alignment

## 9) Email System

### 9.1 HTML Email Safe Design
- 600px max width
- Inline styles fallback
- Unicode ornaments constrained to UTF-safe set
- Signature line with `| || |||` motif as text (not image)

## 10) Video / Motion Graphics

### 10.1 Intro Card
- 1 horizontal scanline draws in
- Vertical bars appear in sequence (`| -> || -> |||`)
- Title resolves from blur to sharp

### 10.2 Lower Thirds
- Left anchor bar + short divider line
- Role/title text with optional glyph tag

## 11) Lobby Signage Spec

### 11.1 Material
- Brushed aluminum face
- Inset enamel channels in ruby tones
- Backlit acrylic for gold accents

### 11.2 Composition
- Dominant horizontal axis line across sign
- Vertical offset stacks near left margin
- Minimal unicode motif engraved at lower right

## 12) Activity Meter Spec

Glyph track: `⋮⋱⋰⋯`
- Background strip: desaturated neutral per state
- Foreground pulse: saturated accent
- Animation: left-to-right phase sweep every 1.4s
- Colorblind-safe alt mode with texture overlays

## 13) Governance

### 13.1 Do / Don’t
**Do**
- Keep horizontal lines sparse and intentional
- Use glyphs as structure first, decoration second
- Maintain strict alignment and rhythm

**Don’t**
- Overfill with symbols in dense UI contexts
- Replace legibility with mystique
- Break baseline grid

### 13.2 Versioning
- `Barlang Visual Spec v1.0`
- Token changes require semver bump and changelog note

## 14) Deliverables Checklist
1. Figma library (tokens + components)
2. Web token package (CSS/JSON)
3. Calendar component (framework-specific)
4. Print templates (letterhead, report, envelope)
5. Motion kit (intro/lower-third templates)
6. Signage fabrication sheet
7. Accessibility QA report

## 15) Starter Prompt for Codex (Implementation)
"Implement `AURIC BARLANG` brand system with tokenized CSS variables, reusable calendar component, and Barlang ornament utilities. Enforce sparse horizontal separators, vertical offset rhythm (`| || |||`), desaturated backgrounds with saturated accents, and accessible fallbacks for all decorative glyphs. Include web, print, email, and motion-ready assets with clear docs."
