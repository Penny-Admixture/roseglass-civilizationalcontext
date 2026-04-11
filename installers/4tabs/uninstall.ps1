# 4TABs — Clean Uninstaller
# Removes app files, shortcuts, registry breadcrumbs, and install receipt
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/uninstall.ps1 | iex

$ErrorActionPreference = 'Stop'

$appName    = "4TABs"
$installDir = "$env:LOCALAPPDATA\4TABs"
$regKey     = "HKCU:\Software\PennyAdmixture\Installers\4TABs"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "  ║   4TABs — Uninstaller                        ║" -ForegroundColor Yellow
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""

# ── Kill running instance ───────────────────────────────────────────────────
$running = Get-Process -Name "4TABs" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "==> Stopping running instance..." -ForegroundColor Yellow
    $running | Stop-Process -Force
    Start-Sleep -Seconds 1
}

# ── Offer config export before deletion ─────────────────────────────────────
if (Test-Path $installDir) {
    $configFiles = @("*.ini", "*.cfg", "*.json", "*.toml", "*.yaml", "*.yml", "settings.*", "config.*")
    $foundConfigs = @()
    foreach ($pattern in $configFiles) {
        $found = Get-ChildItem -Path $installDir -Filter $pattern -ErrorAction SilentlyContinue |
                 Where-Object { $_.Name -ne '.install-receipt.json' }
        $foundConfigs += $found
    }
    if ($foundConfigs.Count -gt 0) {
        $exportDir = "$env:USERPROFILE\Desktop\4TABs_config_export"
        Write-Host "==> Found $($foundConfigs.Count) config file(s). Exporting to Desktop..." -ForegroundColor Cyan
        New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
        foreach ($f in $foundConfigs) {
            Copy-Item $f.FullName (Join-Path $exportDir $f.Name) -Force
        }
        Write-Host "    Configs saved to: $exportDir" -ForegroundColor Green
    }
}

# ── Remove install directory ────────────────────────────────────────────────
if (Test-Path $installDir) {
    Write-Host "==> Removing $installDir ..." -ForegroundColor Cyan
    Remove-Item $installDir -Recurse -Force
    Write-Host "    Done." -ForegroundColor Green
} else {
    Write-Host "==> Install directory not found (already removed?)" -ForegroundColor DarkGray
}

# ── Remove shortcuts ───────────────────────────────────────────────────────
$shortcuts = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\4TABs.lnk",
    "$env:USERPROFILE\Desktop\4TABs.lnk"
)
foreach ($lnk in $shortcuts) {
    if (Test-Path $lnk) {
        Remove-Item $lnk -Force
        Write-Host "==> Removed shortcut: $(Split-Path $lnk -Leaf)" -ForegroundColor Green
    }
}

# ── Remove registry breadcrumb ──────────────────────────────────────────────
if (Test-Path $regKey) {
    Remove-Item $regKey -Force
    Write-Host "==> Removed registry key" -ForegroundColor Green
}

# ── Clean up parent registry key if empty ───────────────────────────────────
$parentKey = "HKCU:\Software\PennyAdmixture\Installers"
if (Test-Path $parentKey) {
    $children = Get-ChildItem $parentKey -ErrorAction SilentlyContinue
    if ($children.Count -eq 0) {
        Remove-Item $parentKey -Force
        $grandparent = "HKCU:\Software\PennyAdmixture"
        if (Test-Path $grandparent) {
            $gc = Get-ChildItem $grandparent -ErrorAction SilentlyContinue
            if ($gc.Count -eq 0) { Remove-Item $grandparent -Force }
        }
    }
}

Write-Host ""
Write-Host "  4TABs has been completely removed." -ForegroundColor Green
Write-Host ""
