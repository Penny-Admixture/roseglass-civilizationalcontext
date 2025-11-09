# Tools

Utilities and applications for the GPT-4o Archive Project.

## mobile-wiki-app.jsx

Mobile-first wiki application with voice navigation.

**Features:**
- Tab-based navigation optimized for mobile
- Voice control (Chrome/Edge only)
- Markdown rendering (headers, lists, basic formatting)
- Local storage persistence
- Dark theme
- Section management (add/delete)

**Voice Commands:**
- Say section name to navigate (e.g., "Lyrics", "Notes")
- "New" or "Add" to create section
- "Edit" to enable editing
- "Save" to disable editing

**Usage:**
- React artifact using shadcn/ui components
- Copy into Claude artifact viewer or React project
- Works standalone in browser

**Storage:**
- Currently uses localStorage
- For large datasets, migrate to IndexedDB or backend

**Next Steps:**
- Add wiki-style [[links]] between sections
- Implement full-text search
- Add cloud sync (GitHub API integration?)
- Support images/audio
- Cross-reference with archive entries
