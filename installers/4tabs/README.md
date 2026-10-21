# 4TABs

**Quad-pane file manager with tabbed navigation.**

Source: [70V07/4TABs](https://github.com/70V07/4TABs)

## Install

```powershell
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/install.ps1 | iex
```

## What it does

- Downloads `4TABs_0.1.5-proto.zip` from the official GitHub release
- Verifies SHA-256: `62fdaaf13...7f42cd`
- Extracts to `%LOCALAPPDATA%\4TABs`
- Creates Start Menu and Desktop shortcuts
- Writes registry breadcrumb for clean uninstall
- Writes `.install-receipt.json` inside the install dir
- Preserves user config files across reinstalls
- Launches the app

## Uninstall

```powershell
irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/uninstall.ps1 | iex
```

Removes: app directory, shortcuts, registry entries. Exports any config files to Desktop before deletion.

## Version History

| Version | Date | SHA-256 (first 16) | Notes |
|---------|------|---------------------|-------|
| 0.1.5-proto | 2026-04-11 | `62fdaaf132...` | Initial proto release |

## Why this exists

4TABs is a promising quad-pane file manager that only ships as a zip on GitHub releases. No installer, no package manager entry. This script makes it a one-liner.
