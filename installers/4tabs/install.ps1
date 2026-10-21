# 4TABs v0.1.5-proto — one-shot installer
# Installs to $env:LOCALAPPDATA\4TABs
# Creates Start Menu + Desktop shortcuts
# Optionally adds to PATH
# Writes uninstall registry breadcrumb for discovery by uninstall script
# Safe to re-run (idempotent)
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/install.ps1 | iex

$ErrorActionPreference = 'Stop'

# ── Config ──────────────────────────────────────────────────────────────────
$appName     = "4TABs"
$appVersion  = "0.1.5-proto"
$installDir  = "$env:LOCALAPPDATA\4TABs"
$zipUrl      = "https://github.com/70V07/4TABs/releases/download/v0.1.5-proto/4TABs_0.1.5-proto.zip"
$expectedSHA = "62fdaaf1322a29a9d5f7e6168a21884fe0fa23eb440a62fe45132095897f42cd"
$zipPath     = "$env:TEMP\4TABs_$appVersion.zip"
$exePath     = "$installDir\4TABs.exe"
$regKey      = "HKCU:\Software\PennyAdmixture\Installers\4TABs"

# ── Banner ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║   4TABs v0.1.5-proto — One-Shot Installer   ║" -ForegroundColor Magenta
Write-Host "  ║   Quad-Pane File Manager                     ║" -ForegroundColor Magenta
Write-Host "  ║   github.com/70V07/4TABs                     ║" -ForegroundColor Magenta
Write-Host "  ╚══════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""

# ── Pre-flight: kill running instance ───────────────────────────────────────
$running = Get-Process -Name "4TABs" -ErrorAction SilentlyContinue
if ($running) {
    Write-Host "==> 4TABs is currently running. Stopping it..." -ForegroundColor Yellow
    $running | Stop-Process -Force
    Start-Sleep -Seconds 1
}

# ── Check for existing install ──────────────────────────────────────────────
if (Test-Path $exePath) {
    $existingVersion = try {
        (Get-Item $exePath).VersionInfo.FileVersion
    } catch { "unknown" }
    Write-Host "==> Existing installation detected (version: $existingVersion)" -ForegroundColor Yellow
    Write-Host "    Will overwrite with v$appVersion" -ForegroundColor Yellow
}

# ── Download ────────────────────────────────────────────────────────────────
Write-Host "==> Downloading 4TABs v$appVersion..." -ForegroundColor Cyan
$ProgressPreference = 'SilentlyContinue'  # suppress progress bar for speed
try {
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
} catch {
    Write-Host "    FAILED: $_" -ForegroundColor Red
    Write-Host "    Check your internet connection or try again later." -ForegroundColor Red
    exit 1
}
$ProgressPreference = 'Continue'

$fileSizeMB = [math]::Round((Get-Item $zipPath).Length / 1MB, 2)
Write-Host "    Downloaded $fileSizeMB MB" -ForegroundColor DarkGray

# ── Verify SHA-256 ──────────────────────────────────────────────────────────
Write-Host "==> Verifying SHA-256..." -ForegroundColor Cyan
$actual = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLower()
if ($actual -ne $expectedSHA) {
    Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
    Write-Host "    HASH MISMATCH!" -ForegroundColor Red
    Write-Host "    Expected: $expectedSHA" -ForegroundColor Red
    Write-Host "    Got:      $actual" -ForegroundColor Red
    Write-Host "    The download may be corrupted or tampered with. Aborting." -ForegroundColor Red
    exit 1
}
Write-Host "    Hash OK: $($actual.Substring(0,16))..." -ForegroundColor Green

# ── Extract ─────────────────────────────────────────────────────────────────
Write-Host "==> Extracting to $installDir ..." -ForegroundColor Cyan
if (Test-Path $installDir) {
    # Preserve any user config files before nuking
    $configBackup = @()
    $configFiles = @("*.ini", "*.cfg", "*.json", "*.toml", "*.yaml", "*.yml", "settings.*", "config.*")
    foreach ($pattern in $configFiles) {
        $found = Get-ChildItem -Path $installDir -Filter $pattern -ErrorAction SilentlyContinue
        foreach ($f in $found) {
            $backupPath = "$env:TEMP\4TABs_config_backup_$($f.Name)"
            Copy-Item $f.FullName $backupPath -Force
            $configBackup += @{ Original = $f.Name; Backup = $backupPath }
        }
    }
    if ($configBackup.Count -gt 0) {
        Write-Host "    Backed up $($configBackup.Count) config file(s)" -ForegroundColor DarkGray
    }
    Remove-Item $installDir -Recurse -Force
}

New-Item -ItemType Directory -Path $installDir | Out-Null
Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
Remove-Item $zipPath -Force

# Handle nested directory (some zips extract into a subfolder)
$innerDirs = Get-ChildItem -Path $installDir -Directory
if ($innerDirs.Count -eq 1 -and -not (Test-Path $exePath)) {
    $innerDir = $innerDirs[0].FullName
    $innerExe = Join-Path $innerDir "4TABs.exe"
    if (Test-Path $innerExe) {
        Write-Host "    Flattening nested directory..." -ForegroundColor DarkGray
        Get-ChildItem -Path $innerDir | Move-Item -Destination $installDir -Force
        Remove-Item $innerDir -Force
    }
}

# Restore backed-up configs
foreach ($cfg in $configBackup) {
    $restoreTo = Join-Path $installDir $cfg.Original
    if (-not (Test-Path $restoreTo)) {
        Copy-Item $cfg.Backup $restoreTo -Force
        Write-Host "    Restored config: $($cfg.Original)" -ForegroundColor DarkGray
    }
    Remove-Item $cfg.Backup -Force -ErrorAction SilentlyContinue
}

# Verify extraction
if (-not (Test-Path $exePath)) {
    Write-Host "    WARNING: $exePath not found after extraction." -ForegroundColor Yellow
    Write-Host "    Contents of install dir:" -ForegroundColor Yellow
    Get-ChildItem $installDir -Recurse | ForEach-Object {
        Write-Host "      $($_.FullName)" -ForegroundColor DarkGray
    }
}

# ── Start Menu shortcut ─────────────────────────────────────────────────────
Write-Host "==> Creating shortcuts..." -ForegroundColor Cyan
$wsh = New-Object -ComObject WScript.Shell

$startMenuPath = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\4TABs.lnk"
$sc = $wsh.CreateShortcut($startMenuPath)
$sc.TargetPath       = $exePath
$sc.WorkingDirectory = $installDir
$sc.Description      = "4TABs Quad-Pane File Manager v$appVersion"
$sc.Save()
Write-Host "    Start Menu shortcut created" -ForegroundColor Green

# ── Desktop shortcut ────────────────────────────────────────────────────────
$desktopPath = "$env:USERPROFILE\Desktop\4TABs.lnk"
$dsc = $wsh.CreateShortcut($desktopPath)
$dsc.TargetPath       = $exePath
$dsc.WorkingDirectory = $installDir
$dsc.Description      = "4TABs Quad-Pane File Manager v$appVersion"
$dsc.Save()
Write-Host "    Desktop shortcut created" -ForegroundColor Green

# ── Registry breadcrumb (for uninstaller discovery) ─────────────────────────
Write-Host "==> Writing install metadata..." -ForegroundColor Cyan
if (-not (Test-Path $regKey)) {
    New-Item -Path $regKey -Force | Out-Null
}
Set-ItemProperty -Path $regKey -Name "InstallDir"   -Value $installDir
Set-ItemProperty -Path $regKey -Name "Version"       -Value $appVersion
Set-ItemProperty -Path $regKey -Name "Executable"    -Value $exePath
Set-ItemProperty -Path $regKey -Name "InstallDate"   -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Set-ItemProperty -Path $regKey -Name "SourceRepo"    -Value "https://github.com/70V07/4TABs"
Set-ItemProperty -Path $regKey -Name "SHA256"         -Value $expectedSHA
Set-ItemProperty -Path $regKey -Name "InstallerURL"  -Value "https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/4tabs/install.ps1"
Write-Host "    Registry key: $regKey" -ForegroundColor DarkGray

# ── Write local install receipt ─────────────────────────────────────────────
$receipt = @{
    app          = $appName
    version      = $appVersion
    install_dir  = $installDir
    install_date = (Get-Date -Format "o")
    sha256       = $expectedSHA
    source_repo  = "https://github.com/70V07/4TABs"
    installer    = "penny-admixture/roseglass-civilizationalcontext/installers/4tabs"
} | ConvertTo-Json -Depth 3

$receipt | Out-File -FilePath "$installDir\.install-receipt.json" -Encoding utf8
Write-Host "    Install receipt written to .install-receipt.json" -ForegroundColor DarkGray

# ── Summary ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ┌──────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "  │  4TABs v$appVersion installed successfully     │" -ForegroundColor Green
Write-Host "  │                                              │" -ForegroundColor Green
Write-Host "  │  Location:  $installDir" -ForegroundColor Green
Write-Host "  │  Shortcuts: Start Menu + Desktop             │" -ForegroundColor Green
Write-Host "  │                                              │" -ForegroundColor Green
Write-Host "  │  To uninstall:                               │" -ForegroundColor Green
Write-Host "  │  irm .../4tabs/uninstall.ps1 | iex           │" -ForegroundColor Green
Write-Host "  └──────────────────────────────────────────────┘" -ForegroundColor Green
Write-Host ""

# ── Launch ──────────────────────────────────────────────────────────────────
Write-Host "==> Launching 4TABs..." -ForegroundColor Cyan
Start-Process $exePath
Write-Host ""
