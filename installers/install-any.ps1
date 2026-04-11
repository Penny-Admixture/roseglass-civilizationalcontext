# install-any.ps1 — Interactive installer launcher
# Fetches catalog.json and presents a menu of all available apps
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/install-any.ps1 | iex

$ErrorActionPreference = 'Stop'
$catalogUrl = "https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/catalog.json"
$rawBase    = "https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers"
$regBase    = "HKCU:\Software\PennyAdmixture\Installers"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║   Penny-Admixture App Installer              ║" -ForegroundColor Magenta
Write-Host "  ║   One-shot installs for obscure GitHub tools ║" -ForegroundColor Magenta
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# ── Fetch catalog ───────────────────────────────────────────────────────────
Write-Host "==> Loading catalog..." -ForegroundColor Cyan
$ProgressPreference = 'SilentlyContinue'
try {
    $catalogJson = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content
    $catalog = $catalogJson | ConvertFrom-Json
} catch {
    Write-Host "    Failed to fetch catalog: $_" -ForegroundColor Red
    return
}
$ProgressPreference = 'Continue'

# ── Check what's already installed ──────────────────────────────────────────
$installedIds = @()
if (Test-Path $regBase) {
    $installedIds = Get-ChildItem $regBase | ForEach-Object { $_.PSChildName }
}

# ── Display menu ────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  Available apps:" -ForegroundColor Cyan
Write-Host ""

$i = 1
foreach ($app in $catalog.apps) {
    $status = ""
    if ($app.id -in $installedIds) {
        $installedVer = (Get-ItemProperty "HKCU:\Software\PennyAdmixture\Installers\$($app.id)").Version
        if ($installedVer -eq $app.version) {
            $status = " [installed]"
        } else {
            $status = " [installed: v$installedVer → update available]"
        }
    }

    $nameColor = if ($status -match "update") { "Yellow" } elseif ($status) { "DarkGray" } else { "White" }
    Write-Host "  [$i] $($app.name) v$($app.version)$status" -ForegroundColor $nameColor
    Write-Host "      $($app.description)" -ForegroundColor DarkGray
    Write-Host "      $($app.source_repo)" -ForegroundColor DarkGray
    Write-Host ""
    $i++
}

Write-Host "  [A] Install ALL" -ForegroundColor Cyan
Write-Host "  [U] Check for updates" -ForegroundColor Cyan
Write-Host "  [0] Cancel" -ForegroundColor DarkGray
Write-Host ""

$choice = Read-Host "  Select"

# ── Handle choice ───────────────────────────────────────────────────────────
if ($choice -eq "0") {
    Write-Host "  Cancelled." -ForegroundColor DarkGray
    return
}

if ($choice -eq "U" -or $choice -eq "u") {
    $updateScript = "$rawBase/_common/Update-Check.ps1"
    Invoke-Expression (Invoke-WebRequest -Uri $updateScript -UseBasicParsing).Content
    return
}

$appsToInstall = @()

if ($choice -eq "A" -or $choice -eq "a") {
    $appsToInstall = $catalog.apps
} else {
    $idx = [int]$choice - 1
    if ($idx -lt 0 -or $idx -ge $catalog.apps.Count) {
        Write-Host "  Invalid selection." -ForegroundColor Red
        return
    }
    $appsToInstall = @($catalog.apps[$idx])
}

foreach ($app in $appsToInstall) {
    Write-Host ""
    Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor DarkGray
    $scriptUrl = "$rawBase/$($app.installer_script)"
    Write-Host "==> Running installer: $scriptUrl" -ForegroundColor Cyan
    try {
        Invoke-Expression (Invoke-WebRequest -Uri $scriptUrl -UseBasicParsing).Content
    } catch {
        Write-Host "    FAILED to install $($app.name): $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "  Done." -ForegroundColor Green
Write-Host ""
