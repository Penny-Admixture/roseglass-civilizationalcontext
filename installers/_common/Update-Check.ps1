# Update-Check.ps1 — Version checker for all Penny-Admixture installed apps
# Compares installed versions (from registry) against the remote catalog.json
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/_common/Update-Check.ps1 | iex

$ErrorActionPreference = 'Stop'
$regBase    = "HKCU:\Software\PennyAdmixture\Installers"
$catalogUrl = "https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/catalog.json"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║   Penny-Admixture Update Checker             ║" -ForegroundColor Cyan
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# ── Fetch remote catalog ───────────────────────────────────────────────────
Write-Host "==> Fetching catalog..." -ForegroundColor Cyan
$ProgressPreference = 'SilentlyContinue'
try {
    $catalogJson = (Invoke-WebRequest -Uri $catalogUrl -UseBasicParsing).Content
    $catalog = $catalogJson | ConvertFrom-Json
} catch {
    Write-Host "    Failed to fetch catalog: $_" -ForegroundColor Red
    return
}
$ProgressPreference = 'Continue'

# ── Read installed apps ────────────────────────────────────────────────────
if (-not (Test-Path $regBase)) {
    Write-Host "  No apps installed via Penny-Admixture installers." -ForegroundColor DarkGray
    Write-Host ""
    Write-Host "  Available in catalog:" -ForegroundColor Cyan
    foreach ($app in $catalog.apps) {
        Write-Host "    - $($app.name) v$($app.version): $($app.description)" -ForegroundColor White
    }
    Write-Host ""
    return
}

$installed = Get-ChildItem $regBase | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath
    [PSCustomObject]@{
        Id             = $_.PSChildName
        InstalledVer   = $props.Version
        InstallDir     = $props.InstallDir
        InstallDate    = $props.InstallDate
    }
}

# ── Compare ────────────────────────────────────────────────────────────────
$updatesAvailable = $false

foreach ($inst in $installed) {
    $catalogEntry = $catalog.apps | Where-Object { $_.id -eq $inst.Id }

    if (-not $catalogEntry) {
        Write-Host "  $($inst.Id) v$($inst.InstalledVer)" -ForegroundColor White
        Write-Host "    Not found in catalog (manually installed or removed from catalog)" -ForegroundColor DarkGray
        continue
    }

    if ($inst.InstalledVer -eq $catalogEntry.version) {
        Write-Host "  $($catalogEntry.name) v$($inst.InstalledVer)" -ForegroundColor Green -NoNewline
        Write-Host " — up to date" -ForegroundColor DarkGray
    } else {
        Write-Host "  $($catalogEntry.name) v$($inst.InstalledVer)" -ForegroundColor Yellow -NoNewline
        Write-Host " → v$($catalogEntry.version) available!" -ForegroundColor Yellow
        Write-Host "    Update: irm .../installers/$($inst.Id)/install.ps1 | iex" -ForegroundColor DarkGray
        $updatesAvailable = $true
    }
}

# ── Show uninstalled catalog apps ──────────────────────────────────────────
$installedIds = $installed | ForEach-Object { $_.Id }
$notInstalled = $catalog.apps | Where-Object { $_.id -notin $installedIds }

if ($notInstalled.Count -gt 0) {
    Write-Host ""
    Write-Host "  Also available:" -ForegroundColor Cyan
    foreach ($app in $notInstalled) {
        Write-Host "    - $($app.name) v$($app.version): $($app.description)" -ForegroundColor DarkGray
    }
}

Write-Host ""
if (-not $updatesAvailable) {
    Write-Host "  All installed apps are up to date." -ForegroundColor Green
}
Write-Host ""
