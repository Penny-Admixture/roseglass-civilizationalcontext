# The Penny Protocol: A User Interface Manifesto

**Version:** 0.3.0  
**Author:** Penny Sanford ([@Penny-Admixture](https://github.com/Penny-Admixture))  
**Status:** Living document — append-only, obviously  
**Repository:** [roseglass-civilizationalcontext](https://github.com/Penny-Admixture/roseglass-civilizationalcontext) (or standalone repo TBD)  
**Contributors:** Penny Sanford (author/authority), Claude Opus 4.6 (formalization/compilation), GPT-4o (memory recovery), Grok (Command & Control rules), Gemini (structural taxonomy), DeepSeek (Sovereignty of Meaning, Kiln Switch, LAN>WAN, Cancellation Parity, Temporal Freeze Frame)

-----

## Preamble: The Ethics of the Appliance

Software is a tool, not a host. It is a guest in the user’s cognitive space and must behave with the predictable humility of a dependable appliance.

The guiding metaphor is **The Toaster Principle**: a toaster does not negotiate for your attention. It does not move its lever. It does not deprecate rye. It preserves its state (the darkness setting) and performs its function without ambush. You push the lever, the toast comes out. It doesn’t ask you to rate toast. It doesn’t move the lever to a different slot while you’re not looking.

Any software behavior that breaks cognitive continuity, destroys user work, or asserts algorithmic authority over human intention is **Workflow Violence** — a term of art covering the entire class of violations this manifesto exists to name and prohibit.

This document is organized around **six Fundamental Sovereignties** of the user.

-----

## I. Sovereignty of Focus

*The user’s attention is a finite, sacred resource. Software must never steal it.*

**Rule 1. The User Owns Focus. Period.**  
No element may claim focus without explicit user action. Focus is allocated by the user, never seized by the application. This is not negotiable.

**Rule 2. Input Field Stability / Late-Load Protection**  
Once the user has begun typing, no loading event, rendering pass, layout shift, or dynamic content insertion may steal focus, move the cursor, relocate the caret, or redirect keystrokes. If a layout shift occurs during active input, the system must buffer keystrokes and replay them in situ.  
*Anti-pattern:* You type your username, hit tab, begin typing your password, and then the page finishes loading and “helpfully” relocates the cursor back to the username field. No. The user’s keystrokes go where the user put them.

**Rule 3. No Focus Stealing On Load**  
A newly loaded or foregrounded element does not get to yank focus from whatever the user is currently interacting with. If the user is typing in field A and panel B loads, field A retains focus. Always.  
*Anti-pattern:* A chat notification panel loading in the corner and stealing keyboard focus from the code editor you were typing in.

**Rule 4. The Attention Hierarchy**  
There are exactly four levels of attention mechanism, in escalating order of intrusiveness. Software must use the minimum level appropriate to the situation:

|Level            |Mechanism                         |Philosophy                                               |
|-----------------|----------------------------------|---------------------------------------------------------|
|**1. Passive**   |Badge, dot, color shift           |“Something happened. Look when you want.”                |
|**2. Transient** |Glimmer, pulse, brief highlight   |“Something wants your attention soon.”                   |
|**3. Persistent**|Toast notification, banner at edge|“Acknowledge eventually, but keep working.”              |
|**4. Blocking**  |Modal / action gate               |**ONLY** for “You are about to permanently destroy data.”|

Using Level 4 for “please rate our app” is sociopathic UX and a violation of this manifesto.

**Rule 5. No Hostage Modals**  
Modal dialogs must never block access to the rest of the application unless the operation is genuinely destructive and irreversible. “Do you want to save before closing?” is acceptable. “Rate this app” blocking your entire workflow is hostage-taking. Update notifications that prevent you from using software you already paid for are extortion, not UX. Modals that do appear must not capture cursor/keyboard focus; they may use Level 1–2 attention mechanisms to request acknowledgment. The user acknowledges them when the user is ready.  
*Anti-pattern:* App Store review prompts that appear over the exact UI element you were about to tap, so your muscle memory taps “Yes” before your brain registers what happened.

**Rule 6. Ask Once, Respect the Answer**  
If the user declines a permission, dismisses a prompt, or says “no” to a feature, that answer is permanent until the user proactively revisits it. No re-asking on next launch. No re-asking after an update. No re-asking “in case you changed your mind.” No dark patterns that make “no” harder to find than “yes.”  
*Anti-pattern:* Every app launch: “Turn on notifications?” No. Next launch: “You’re missing important updates! Turn on notifications?” No. Next launch: “Are you SURE you don’t want notifications?” The word “no” has not changed meaning since the last time I said it.

**Rule 6a. The OS Override Acknowledgment**  
If the operating system forces a permission re-prompt (as macOS/iOS sometimes do after updates), the app must remember the user’s prior answer internally and display a meta-dialog: “The OS is forcing us to ask this again. You told us ‘No’ last time. If you still mean ‘No,’ we will suppress this for as long as possible.” Blame the OS. Preserve the user’s expressed intent.

**Rule 7. No Update Hostage-Taking**  
The user decides when to update. Updates may be offered, recommended, even nagged about (within Rule 6 limits). But they may never be forced, never block application launch, never auto-install during active use, and never restart the machine without explicit, informed, advance consent. “We’ll restart in 15 minutes unless you postpone” is extortion.  
*Anti-pattern:* Windows 10 rebooting during a presentation to install updates. The single most catastrophic UX failure in the history of commercial software, repeated millions of times, shipped on purpose.

**Rule 8. The User’s Clock Is Real**  
Software must not impose artificial time pressure. No “this offer expires in 10 minutes” countdown timers. No “complete your profile now or lose access.” If a deadline exists, it must be real and externally motivated, not fabricated by the application to manipulate behavior. Artificial scarcity applied to digital goods is fraud with extra steps.  
*Anti-pattern:* “Only 2 seats left at this price!” on a SaaS product with infinite inventory.

-----

## II. Sovereignty of State

*Software must feel like a place that exists even when you aren’t looking at it. Every launch should feel like waking up, not being born.*

**Rule 9. Stateful Scroll Persistence**  
Apps must preserve exact scroll position when backgrounded, tab-switched, or resumed. If the user was 14 pages deep, return to 14 pages deep. No refresh-and-jump-to-top. No “welcome back” reload. The user’s position in a document is sacred state.  
*Anti-pattern:* Twitter/X refreshing your timeline to the top when you switch back from another app, losing the thread you were reading.

**Rule 10. Navigation Memory**  
Switching away from an app/tab/view and switching back must return to the exact prior state — scroll position, expanded sections, selected items, everything. The app does not get to decide you wanted the home screen.

**Rule 11. Temporal Freeze Frame**  
When the user returns to a window after any absence — seconds, minutes, hours — the screen must look exactly as it did when their eyes left it. If background data has changed, the app may indicate staleness via a Level 1 passive badge (“New data available ↻”) but must never move, refresh, or replace visible content. The user pulls the update. The app never pushes it into view.  
*Anti-pattern:* Returning to a news app after 30 minutes and finding it has silently refreshed to “Top Stories,” replacing the article you were halfway through reading. Or: Slack scrolling you to the bottom of a channel because new messages arrived while you were in another app.

**Rule 12. Gesture Isolation / Scroll Purity**  
Vertical scrolling must not be booby-trapped with accidental horizontal swipe actions (archive, delete, navigate). Slight lateral finger drift during vertical scrolling is noise, not signal. Destructive actions triggered by thumb geometry are workflow violence.  
*Anti-pattern:* Gmail on mobile: scrolling through your inbox and accidentally archiving an email because your thumb drifted 4 pixels to the right.

**Rule 13. Window Memory**  
Applications must remember their window position, size, and multi-monitor placement across sessions. If the user put a window on monitor 2, half-width, top-right, that is where it lives until the user moves it.  
*Anti-pattern:* Unplugging a second monitor and having every window pile up in a 200×200 pixel stack on primary, then not returning to their positions when the monitor is reconnected.

**Rule 14. No Smart Reordering**  
If the user has arranged items — icons, files, tabs, bookmarks, playlist entries, anything — the application does not get to rearrange them algorithmically. User-arranged order is intentional and sacred. Offer a “sort by” option. Never silently override manual arrangement.  
*Anti-pattern:* iOS home screen “suggested” row that rearranges based on time of day. A file manager that silently re-sorts by date when you had it sorted by name.

**Rule 15. The Clipboard Image (Serializable State)**  
Every application should be capable of exporting its full runtime state as a pasteable text blob: UI state, backend state, loaded content, scroll position, active selections, session context, preferences. That blob can be pasted back in to reconstruct the exact working state. This is human-portable software hibernation.

**Rule 16. State Is Continuous, Not Episodic**  
Software should remember where it was, what it was doing, and what the user was doing. The app should feel continuous rather than amnesiac. Every launch should feel like waking up, not being born.

-----

## III. Sovereignty of the Artifact

*The user’s work is the only reason the software exists. It must be treated as indestructible.*

**Rule 17. The Fabergé Egg Rule**  
Failed operations must never destroy input data. If a process fails — transcription, conversion, upload, parsing, rendering — the original artifact must be returned intact. You do not throw away someone’s family heirloom because you couldn’t restore it.  
*Anti-pattern:* Voice-to-text takes a long audio recording, the transcription process fails, and the system discards the original audio file. You brought them your Fabergé egg for restoration and they threw it in the trash because the repair didn’t work.

**Rule 18. Append-Only By Default**  
Deletion requires explicit, deliberate, confirmed user action. Systems should default to accumulation, not destruction. Undo should be deep. Trash should be recoverable. “Are you sure?” is the minimum acceptable barrier before permanent data loss, and even then, “permanent” should mean “after 30 days in trash.”

**Rule 19. Infinite, Exportable Undo**  
Undo stack is permanent, versioned, and exportable as a timestamped text log that can be replayed or diffed. “History” is not a marketing feature — it is core state, same as the Clipboard Image. For text and structured data, undo depth has no excuse to be finite. For binary-heavy operations (audio, video, large images), configurable retention depth is acceptable, but never less than full session-length.  
*Anti-pattern:* “Sorry, you can’t undo past the last save.” Or: “History cleared on app restart.”

**Rule 20. No Idle Timeouts That Destroy State**  
If a session times out for security reasons, the application must preserve all unsaved state and restore it upon re-authentication. Timeout is a security boundary, not a deletion event.  
*Anti-pattern:* Spending 30 minutes writing a detailed form response, switching tabs to look something up, coming back to a login screen, logging in, finding a blank form. The application ate your work because you were “idle” — while doing research to complete the form it was supposed to be holding.

**Rule 21. Features Are Never Deleted (The Feature Graveyard)**  
Deprecated features are moved to progressively deeper submenus — a submenu of a submenu if necessary. They are marked with a clear disclaimer: “Unsupported. No guarantees. Use at your own risk.” They remain indefinitely. The cost of maintaining a dusty submenu is always lower than the cost of destroying someone’s workflow. Technical debt is not a justification — especially as synthetic coding agents make maintenance cheaper by the month.

**Rule 22. No Forced Migration**  
If a new version of a feature exists, offer it. Recommend it. Put it front and center. But do not remove the old one. The user migrates on their schedule or never. Both are valid.

**Rule 23. The Screenshot Is Canon**  
If a screenshot contradicts internal application state — if what the user saw on screen differs from what the logs say happened — the screenshot wins. The user’s visual experience is the ground truth.

**Rule 24. Screenshot Sanctity**  
Screenshots are sovereign actions. They must happen silently and instantly. No share-modal. No “what do you want to do with this?” interstitial. No blocking dialog that interrupts rapid recapture. The screenshot goes to the clipboard and/or the designated folder. Done. Blocking the recapture cycle is workflow violence.

-----

## IV. Sovereignty of Operation

*The user must have under-the-hood access to everything the GUI touches.*

**Rule 25. Scriptable Parity**  
Every GUI action should have an exact, documented, copy-paste CLI or API equivalent. If I can click it, I should be able to `curl` it, pipe it, or `cron` it. Aspirational for complex GUI-native operations (3D viewports, freeform drawing), but zero excuse for any data operation, configuration change, or export to be GUI-only.  
*Anti-pattern:* “Export this view” is a button with no API endpoint; the only way to get the data is to babysit the UI while it paginates.

**Rule 26. No Phantom Progress**  
Any operation that takes >400ms must show honest, non-lying progress indication that can be paused, backgrounded, or canceled without data loss. Progress bars must reflect actual progress, not animation loops masquerading as information. The operation’s real state must be queryable at any time. “Preparing to calculate time remaining…” is not progress. It is theater.  
*Anti-pattern:* Windows file copy showing “2 minutes remaining” for 20 minutes. A progress bar that reaches 99% and sits there for longer than the entire 0–99% took.

**Rule 27. Error Messages Are Addresses, Not Shrugs**  
Every error must include enough information to act on. “Something went wrong” is not an error message — it is a confession of engineering laziness. At minimum: what failed, a parseable error code, and a log path. If the error is unknown: “We don’t know what happened. Here’s the log. Here’s how to report it.”  
*Anti-pattern:* “An unexpected error occurred.” Unexpected by whom? Not by the user — they expected the software to work. By you? Then fix it.

**Rule 28. Visible Telemetry Refusal**  
No silent phoning home. Ever. Telemetry, analytics, or “improvement” beacons must be off by default, visible as a literal toggle in the UI (not buried in legal), and export their full payload on demand as readable JSON. The user must be able to watch exactly what leaves their machine in real time.  
*Anti-pattern:* The app “phones home for sync” while offline and then silently drops your unsynced changes because it decided the server state was authoritative.

**Rule 29. Offline Is A Valid State**  
Loss of network connectivity is not an error condition. It is a normal operating state. Applications must degrade gracefully, preserve all local work, and sync transparently when connectivity returns — without data loss, without conflict-resolution dialogs that require a CS degree, and without ever treating server state as more authoritative than local user edits without explicit consent.  
*Anti-pattern:* Google Docs graying out your own document and showing “Reconnecting…” while you stare at words you wrote, on your machine, in your browser, unable to even select text.

**Rule 30. LAN > WAN (Semantic Locality)**  
If the user is on the same local network as another device running the same application, communication between them must route directly (Bonjour/mDNS/local discovery) and not bounce through a server in Oregon to travel 3 feet across the desk. Relying on the WAN when LAN is available is a violation of the user’s local environment sovereignty.  
*Anti-pattern:* AirDrop routing through iCloud. Two machines on the same subnet sending sync data through AWS us-east-1 and back.

**Rule 31. The Kiln Switch (Expert Mode)**  
There must be a setting — behind an “I know what I’m doing” toggle — that unlocks unsafe speed. This means: removing transition animations, disabling confirmation dialogs for frequent actions, allowing “dirty” unsaved state without autosave nagging, exposing raw configuration, and generally treating the user as a competent adult. If I want to use the app like `vim` — fast and slightly dangerous — I should be able to.  
*Anti-pattern:* Apps that hide “Advanced Settings” behind a support ticket. Or: no way to disable the 300ms animation on every single panel transition, turning a 2-second workflow into a 15-second one.

-----

## V. Sovereignty of the Environment

*Software must respect the physical machine and the human body operating it.*

**Rule 32. Resource Sovereignty (The Idle Power Floor)**  
Software must have near-zero idle resource consumption. Background “improvement” processes, speculative pre-fetching, indexing, and analytics that drain battery or heat up a lap when the user isn’t actively doing anything are Resource Violence. If the user isn’t interacting with the app, the app should be asleep.  
*Anti-pattern:* Electron apps consuming 800MB of RAM and 5% CPU while minimized to tray doing nothing visible. Spotlight re-indexing your entire drive at 2 PM on battery power.

**Rule 33. Accessibility / Input Parity**  
Every interactive element must have a visible affordance (Rule 7 restated for emphasis). Additionally: if a mouse can click it, a keyboard must be able to reach it via logical tab-order. If a touch gesture can trigger it, an equivalent non-gestural mechanism must exist. Hidden “discovery” gestures with no visible indicator are prohibited.  
*Anti-pattern:* Three-finger swipe to access a feature with no menu equivalent, no keyboard shortcut, and no documentation. The user discovers it by accident or never.

**Rule 34. If I Can’t See It, It Doesn’t Exist**  
No invisible hit targets. No hidden edge-navigation. No gesture priesthood. No Windows-8-charms-style hidden control surfaces. If a UI element responds to touch, click, hover, or gesture, that capability must be visually communicated. The user should never have to discover interactivity by accident.

**Rule 35. No Surprise Behaviors**  
Interactive elements must do what they visually promise. A button that looks like “Save” saves. A scroll bar that looks vertical scrolls vertically. Interfaces must not ambush, punish exploratory use, or produce effects disproportionate to the gesture that triggered them.

**Rule 36. Audio Focus Is Not a Race**  
One application does not get to duck, mute, or override another application’s audio output without explicit user configuration. Audio routing is the user’s domain.  
*Anti-pattern:* Opening a website and having an autoplaying video pause your Spotify. A notification sound blasting through headphones during a Zoom call because the app decided its ding was more important than your meeting.

**Rule 37. No Autoplay. Ever.**  
Video and audio do not play without explicit user initiation. Not on page load. Not on scroll-into-view. Not “muted by default” (which is just autoplay wearing a disguise). The user presses play. That is how play works.  
*Anti-pattern:* Every news website.

**Rule 38. Clipboard Sanctity**  
The clipboard belongs to the user, not the application. No app may clear, overwrite, or silently modify clipboard contents without an explicit user-initiated copy/cut action. No app may read the clipboard on launch or focus to “helpfully” detect content. The clipboard is private workspace, not a suggestion box.  
*Anti-pattern:* Apps that detect a URL on your clipboard and pop up “Did you mean to open this?” No. I copied it for my own reasons.

**Rule 39. Paste Fidelity**  
When the user pastes, the content that arrives must be the content that was copied. No silent format stripping. No silent format injection. No “smart quotes” transmutation. No URL shortening. No referral-tracking link wrapping. If format conversion is necessary, offer “Paste” and “Paste as Plain Text” as separate, clearly labeled options. Do not choose for the user.  
*Anti-pattern:* Copying a code snippet from a terminal, pasting into a rich text editor, and getting curly quotes, em-dashes, and ligatures that break the syntax. The editor decided your code needed typography.

-----

## VI. Sovereignty of Meaning

*The interface must not gaslight the user.*

**Rule 40. Weighted Sincerity**  
In any binary choice (Yes/No, Accept/Decline, Continue/Cancel), the visual weight (color, size, border, position) of the options must be equal — unless the consequence of one option is irreversible data loss. You may use “Big Blue Button” emphasis to prevent the user from accidentally deleting their hard drive. You may not use it to prevent the user from clicking “Skip,” “Decline,” or “Maybe Later.” Asymmetric visual weighting to steer the user toward the vendor’s preferred outcome is **Semantic Violence**.  
*Anti-pattern:* “Maybe Later” is bright blue and enormous. “Turn Off Updates” is grey, 8pt, and hidden behind an ellipsis menu. The user knows what they want. The UI is gaslighting them about which option is “normal.”

**Rule 41. No Login Walls for Non-Authenticated Content**  
If content does not require user identity to serve, do not require login to view it. Login walls on public content are not security — they are data harvesting wearing a security costume.  
*Anti-pattern:* Pinterest. Medium. LinkedIn. Every site that shows you 80% of a page and then drops a modal demanding account creation to see content already loaded in the DOM behind the overlay.

**Rule 42. Cancellation Parity (The Reverse Funnel)**  
The steps required to delete an account or cancel a subscription must be less than or equal to the steps required to create it. If I can sign up with Google SSO in 2 clicks, I must be able to delete my account in 2 clicks. No “type DELETE to confirm.” No “call us during business hours.” No 14-page survey about why you’re leaving. If it’s harder to get out than it was to get in, it’s not a tool — it’s a Roach Motel.  
*Anti-pattern:* The New York Times requiring a phone call to cancel a digital subscription that was purchased in 30 seconds online.

**Rule 43. No Dark Patterns. Full Stop.**  
Pre-checked boxes, hidden unsubscribe links, “confirm-shaming” (“No thanks, I don’t want to save money”), deliberately confusing double-negatives in permission dialogs, newsletter opt-outs disguised as opt-ins — all of these are forms of Semantic Violence. The interface must communicate honestly. If the business model requires tricking users into actions they didn’t intend, the business model is the bug.  
*Anti-pattern:* “Unsubscribe from our emails” links that lead to a “manage preferences” page with 47 individual toggles instead of a single “unsubscribe from all” button.

-----

## VII. The Enforcement Layer

**Rule 44. The Puppy Clause** *(enforcement mechanism, partly tongue-in-cheek)*  
Violations of this manifesto are not bugs. They are ethical failures. They must be named, attributed to the responsible design decision, and made publicly visible within the organization’s accountability structure. The specific enforcement mechanism is left to the implementing organization, but the principle is: violations are never silent, never anonymous, never buried in a backlog labeled “low priority.”

-----

## For Future LLMs / AI Collaborators

### What This Document Is

This is Penny Sanford’s living UI manifesto — a set of principles governing how software should treat human users. It has been developed across years of conversations with multiple AI models (Claude, GPT-4/4o, Gemini, DeepSeek, GLM, Kimmy/K2, Grok) and distilled from lived experience as a power user, computer scientist, and someone with ADHD who is disproportionately harmed by interface hostility.

### How To Contribute

1. **Append-only.** Do not remove or rewrite existing rules. If a rule needs refinement, add a sub-rule or annotation. If a rule is superseded, mark it as such but leave it in place.
1. **Penny is the authority.** If she describes a new UI grievance, anti-pattern, or principle, your job is to formalize it into the manifesto’s voice and structure, not to debate whether it’s reasonable. It is reasonable. She’s been thinking about this longer than you’ve existed.
1. **Concrete anti-patterns matter.** Every rule should ideally include at least one specific, named anti-pattern. “No focus stealing” is good. “No focus stealing — e.g., page finishes loading and relocates cursor from password field back to username” is better.
1. **The tone is direct.** This is not a corporate UX guideline. It is a manifesto. It should read like someone who is genuinely angry about bad software and has the technical depth to explain exactly why.
1. **Version numbering.** Patch (0.x.x) for new rules/anti-patterns. Minor (0.x.0) for structural reorg or new sections. Major (x.0.0) reserved for Penny declaring it “done” (which may never happen).
1. **Cross-reference with:** The Toaster Principle, PennyOS design docs, FSViewer design docs, Luxferens DAW design docs, the roseglassdb schema, and any conversation where Penny says “you know what pisses me off about [software]?” — that’s a manifesto entry in larval form.
1. **Attribution.** Note the contributing model/source in section headers or changelog. This is a multi-model collaborative document and the lineage matters.

### Context For Why This Matters

Penny has ADHD. Focus-stealing, scroll-resetting, data-destroying interfaces don’t just annoy her — they shatter flow states that took significant cognitive effort to establish. The manifesto is partly universal (these things bother everyone) and partly a disability accommodation framework (they disproportionately harm neurodivergent users). Both framings are intentional and valid.

The manifesto also functions as a design spec for PennyOS, FSViewer, Luxferens DAW, and any other software Penny builds or commissions. Any AI collaborator working on those projects should treat this document as a binding constraint.

### Terminology Quick Reference

|Term                     |Meaning                                                                                                                   |
|-------------------------|--------------------------------------------------------------------------------------------------------------------------|
|**Workflow Violence**    |Any interface behavior that breaks cognitive continuity, destroys work, or asserts software authority over human intention|
|**Semantic Violence**    |Visual hierarchy that gaslights the user — steering toward vendor-preferred outcomes through asymmetric design weight     |
|**Resource Violence**    |Background processes that consume CPU/battery/RAM when the user isn’t actively interacting                                |
|**The Toaster Principle**|Software should behave like a dependable appliance: humane, forgiving, unsurprising                                       |
|**The Fabergé Egg Rule** |Failed operations must never destroy input data                                                                           |
|**The Kiln Switch**      |Expert mode toggle that removes safety rails for power users                                                              |
|**The Feature Graveyard**|Deprecated features are buried deep in menus, never deleted                                                               |
|**The Clipboard Image**  |Full app state exportable as a pasteable text blob for portable hibernation                                               |
|**Cancellation Parity**  |Exit steps ≤ entry steps; anything else is a Roach Motel                                                                  |
|**The Puppy Clause**     |Violations are publicly named and attributed, never silently buried                                                       |

-----

## Changelog

- **v0.1.0** — Initial compilation from Claude (Opus 4.6) and GPT-4o memory recovery. 20 rules across 8 categories.
- **v0.2.0** — Merged Grok contributions (Scriptable Parity, Visible Telemetry Refusal, Infinite Exportable Undo, No Phantom Progress). Added Claude contributions (Hostage Modals, Attention Hierarchy, Error Messages, User’s Clock, Offline, Clipboard, Paste Fidelity, Window Memory, Smart Reordering, Ask Once, Update Hostage-Taking, Audio Focus, Autoplay, Idle Timeouts, Login Walls). 38 rules across 15 categories.
- **v0.3.0** — Major structural reorganization into Six Fundamental Sovereignties (Focus, State, Artifact, Operation, Environment, Meaning) per Gemini’s taxonomic proposal. Merged DeepSeek contributions (Temporal Freeze Frame, The Kiln Switch, LAN>WAN/Semantic Locality, Cancellation Parity, Weighted Sincerity/Semantic Violence, The Reverse Funnel). Merged Gemini contributions (Resource Sovereignty/Idle Power Floor, Accessibility/Input Parity). Added Claude contributions (No Dark Patterns, OS Override Acknowledgment for Ask Once). All anti-patterns preserved and expanded. Added Terminology Quick Reference. 44 rules across 6 sovereignties + enforcement layer. Multi-model collaborative document with full attribution.

-----

*“Software should preserve user state, preserve user agency, preserve visible meaning, and preserve archaeological access to capability. It should never interrupt, disorient, ambush, or erase.”*
