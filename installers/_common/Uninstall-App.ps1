# Uninstall-App.ps1 — Universal uninstaller for Penny-Admixture installed apps
# Discovers all apps from HKCU:\Software\PennyAdmixture\Installers and lets you pick
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/_common/Uninstall-App.ps1 | iex

$ErrorActionPreference = 'Stop'
$regBase = "HKCU:\Software\PennyAdmixture\Installers"

Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Yellow
Write-Host "  ║   Penny-Admixture Universal Uninstaller      ║" -ForegroundColor Yellow
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Yellow
Write-Host ""

if (-not (Test-Path $regBase)) {
    Write-Host "  No apps installed via Penny-Admixture installers." -ForegroundColor DarkGray
    Write-Host ""
    return
}

$apps = Get-ChildItem $regBase | ForEach-Object {
    $props = Get-ItemProperty $_.PSPath
    [PSCustomObject]@{
        Name       = $_.PSChildName
        Version    = $props.Version
        InstallDir = $props.InstallDir
        Executable = $props.Executable
        Date       = $props.InstallDate
        RegPath    = $_.PSPath
    }
}

if ($apps.Count -eq 0) {
    Write-Host "  No apps found in registry." -ForegroundColor DarkGray
    return
}

Write-Host "  Installed apps:" -ForegroundColor Cyan
Write-Host ""
$i = 1
foreach ($app in $apps) {
    Write-Host "  [$i] $($app.Name) v$($app.Version)" -ForegroundColor White
    Write-Host "      $($app.InstallDir)" -ForegroundColor DarkGray
    $i++
}
Write-Host ""
Write-Host "  [0] Cancel" -ForegroundColor DarkGray
Write-Host ""

$choice = Read-Host "  Select app to uninstall"
$idx = [int]$choice - 1

if ($choice -eq "0" -or $idx -lt 0 -or $idx -ge $apps.Count) {
    Write-Host "  Cancelled." -ForegroundColor DarkGray
    return
}

$target = $apps[$idx]
Write-Host ""
Write-Host "==> Uninstalling $($target.Name)..." -ForegroundColor Yellow

# Kill process
$procName = [System.IO.Path]::GetFileNameWithoutExtension((Split-Path $target.Executable -Leaf))
$running = Get-Process -Name $procName -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "    Stopping running instance..." -ForegroundColor Yellow
    $running | Stop-Process -Force
    Start-Sleep -Seconds 1
}

# Export configs
if (Test-Path $target.InstallDir) {
    $configPatterns = @("*.ini", "*.cfg", "*.json", "*.toml", "*.yaml", "*.yml")
    $configs = @()
    foreach ($p in $configPatterns) {
        $configs += Get-ChildItem -Path $target.InstallDir -Filter $p -ErrorAction SilentlyContinue |
                    Where-Object { $_.Name -ne '.install-receipt.json' }
    }
    if ($configs.Count -gt 0) {
        $exportDir = "$env:USERPROFILE\Desktop\$($target.Name)_config_export"
        New-Item -ItemType Directory -Path $exportDir -Force | Out-Null
        foreach ($f in $configs) { Copy-Item $f.FullName (Join-Path $exportDir $f.Name) -Force }
        Write-Host "    Exported $($configs.Count) config(s) to Desktop" -ForegroundColor Cyan
    }

    Remove-Item $target.InstallDir -Recurse -Force
    Write-Host "    Removed install directory" -ForegroundColor Green
}

# Remove shortcuts
$shortcutNames = @(
    "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\$($target.Name).lnk",
    "$env:USERPROFILE\Desktop\$($target.Name).lnk"
)
foreach ($lnk in $shortcutNames) {
    if (Test-Path $lnk) {
        Remove-Item $lnk -Force
        Write-Host "    Removed: $(Split-Path $lnk -Leaf)" -ForegroundColor Green
    }
}

# Remove registry
Remove-Item $target.RegPath -Force
Write-Host "    Removed registry entry" -ForegroundColor Green

# Clean empty parent keys
$children = Get-ChildItem $regBase -ErrorAction SilentlyContinue
if ($children.Count -eq 0) {
    Remove-Item $regBase -Force
    $gp = "HKCU:\Software\PennyAdmixture"
    if (Test-Path $gp) {
        $gc = Get-ChildItem $gp -ErrorAction SilentlyContinue
        if ($gc.Count -eq 0) { Remove-Item $gp -Force }
    }
}

Write-Host ""
Write-Host "  $($target.Name) has been completely removed." -ForegroundColor Green
Write-Host ""
