# 🔧 Installers

**Curated one-shot PowerShell installers for obscure, source-only, or hard-to-find GitHub tools.**

Most of these projects have no MSI, no Chocolatey package, no Winget manifest, no Scoop bucket — just a zip on a releases page, or a Python model on HuggingFace. These scripts turn multi-step installs into a single `irm | iex` one-liner.

## Quick Install (any app)

```powershell
# Interactive menu — pick from all available apps
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/install-any.ps1 | iex
```

## Direct Install (specific app)

```powershell
# 4TABs — Quad-pane file manager
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/install.ps1 | iex

# Music Flamingo — NVIDIA AI music analysis (requires Python 3.10+, NVIDIA GPU)
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/install.ps1 | iex
```

## Catalog

| App | Version | Description | Source |
|-----|---------|-------------|--------|
| [4TABs](4tabs/) | 0.1.5-proto | Quad-pane file manager | [70V07/4TABs](https://github.com/70V07/4TABs) |
| [Music Flamingo](music-flamingo/) | preview-2026 | NVIDIA 8B AI for music understanding | [NVIDIA/audio-flamingo](https://github.com/NVIDIA/audio-flamingo) |

## Uninstall

Every app ships with a paired uninstaller:

```powershell
# Uninstall a specific app
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/uninstall.ps1 | iex
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/uninstall.ps1 | iex
```

Or use the universal uninstaller:

```powershell
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/_common/Uninstall-App.ps1 | iex
```

## Structure

```
installers/
├── catalog.json              # Machine-readable index of all apps
├── install-any.ps1           # Interactive multi-app launcher
├── README.md                 # This file
├── _common/
│   ├── Install-FromManifest.ps1   # Shared installer framework
│   ├── Uninstall-App.ps1          # Universal uninstaller
│   └── Update-Check.ps1          # Version checker / update notifier
└── <app-name>/
    ├── install.ps1           # One-shot installer (irm|iex ready)
    ├── uninstall.ps1         # Clean uninstaller
    ├── manifest.json         # App metadata + version history
    └── README.md             # Per-app docs + install instructions
```

## Design Principles

- **SHA-256 on everything** (where applicable). Every binary download is hash-verified before extraction.
- **`irm | iex` compatible.** Every installer works as a remote one-liner. No cloning required.
- **Shortcuts created automatically.** Start Menu + Desktop. No hunting.
- **Clean uninstall.** Every app gets a paired uninstaller that removes files, shortcuts, PATH entries, and registry breadcrumbs.
- **No admin required.** Everything installs to `$env:LOCALAPPDATA` by default. No UAC prompts.
- **GPU auto-detection.** AI/ML installers detect VRAM and select the right quantization level automatically.
- **Append-only version history.** `manifest.json` tracks every version ever packaged, not just the latest.

## Adding a New App

1. Create `installers/<app-name>/`
2. Add `manifest.json` with app metadata (copy from an existing one)
3. Write `install.ps1` and `uninstall.ps1`
4. Add a `README.md` with install instructions
5. Update `catalog.json` with the new entry
6. Update this README's catalog table
