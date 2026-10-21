# Music Flamingo — Clean Uninstaller
# Removes venv, scripts, shortcuts, registry. Optionally removes cached model weights.
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/uninstall.ps1 | iex

$ErrorActionPreference = 'Stop'

$appName    = "MusicFlamingo"
$installDir = "$env:LOCALAPPDATA\MusicFlamingo"
$regKey     = "HKCU:\Software\PennyAdmixture\Installers\MusicFlamingo"
$hfCache    = "$env:USERPROFILE\.cache\huggingface\hub\models--nvidia--music-flamingo-hf"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "  ║   Music Flamingo — Uninstaller                       ║" -ForegroundColor Yellow
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""

# ── Remove install directory ────────────────────────────────────────────────
if (Test-Path $installDir) {
    Write-Host "==> Removing $installDir ..." -ForegroundColor Cyan
    Remove-Item $installDir -Recurse -Force
    Write-Host "    Done." -ForegroundColor Green
} else {
    Write-Host "==> Install directory not found." -ForegroundColor DarkGray
}

# ── Remove shortcuts ───────────────────────────────────────────────────────
$shortcuts = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Music Flamingo.lnk",
    "$env:USERPROFILE\Desktop\Music Flamingo.lnk"
)
foreach ($lnk in $shortcuts) {
    if (Test-Path $lnk) {
        Remove-Item $lnk -Force
        Write-Host "==> Removed shortcut: $(Split-Path $lnk -Leaf)" -ForegroundColor Green
    }
}

# ── Remove registry ────────────────────────────────────────────────────────
if (Test-Path $regKey) {
    Remove-Item $regKey -Force
    Write-Host "==> Removed registry key" -ForegroundColor Green
}

# Clean parent keys if empty
$parentKey = "HKCU:\Software\PennyAdmixture\Installers"
if (Test-Path $parentKey) {
    $children = Get-ChildItem $parentKey -ErrorAction SilentlyContinue
    if ($children.Count -eq 0) {
        Remove-Item $parentKey -Force
        $gp = "HKCU:\Software\PennyAdmixture"
        if (Test-Path $gp) {
            $gc = Get-ChildItem $gp -ErrorAction SilentlyContinue
            if ($gc.Count -eq 0) { Remove-Item $gp -Force }
        }
    }
}

# ── Offer to remove cached model weights ───────────────────────────────────
if (Test-Path $hfCache) {
    $cacheSize = [math]::Round((Get-ChildItem $hfCache -Recurse | Measure-Object -Property Length -Sum).Sum / 1GB, 1)
    Write-Host ""
    Write-Host "  Found cached model weights: ~${cacheSize} GB" -ForegroundColor Yellow
    Write-Host "  Location: $hfCache" -ForegroundColor DarkGray
    $remove = Read-Host "  Delete cached model weights? (y/n)"
    if ($remove -eq "y" -or $remove -eq "Y") {
        Remove-Item $hfCache -Recurse -Force
        Write-Host "  Cached weights removed." -ForegroundColor Green
    } else {
        Write-Host "  Cached weights kept (can reuse if reinstalled)." -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "  Music Flamingo has been removed." -ForegroundColor Green
Write-Host ""
