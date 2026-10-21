# Install-FromManifest.ps1 — Shared installer framework
# Reads a manifest.json and performs a standardized install
#
# Usage (from another script):
#   $manifestUrl = "https://raw.githubusercontent.com/.../manifest.json"
#   irm https://raw.githubusercontent.com/.../Install-FromManifest.ps1 | iex
#   Install-FromManifest -ManifestPath "./manifest.json"
#
# Or standalone:
#   . .\Install-FromManifest.ps1
#   Install-FromManifest -ManifestUrl "https://raw.githubusercontent.com/..."

function Install-FromManifest {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$false)] [string]$ManifestPath,
        [Parameter(Mandatory=$false)] [string]$ManifestUrl,
        [switch]$NoLaunch,
        [switch]$NoShortcuts,
        [switch]$Force
    )

    $ErrorActionPreference = 'Stop'

    # ── Load manifest ───────────────────────────────────────────────────────
    if ($ManifestUrl) {
        $ProgressPreference = 'SilentlyContinue'
        $manifestJson = (Invoke-WebRequest -Uri $ManifestUrl -UseBasicParsing).Content
        $ProgressPreference = 'Continue'
    } elseif ($ManifestPath) {
        $manifestJson = Get-Content $ManifestPath -Raw
    } else {
        throw "Provide either -ManifestPath or -ManifestUrl"
    }

    $manifest = $manifestJson | ConvertFrom-Json
    $app = $manifest.app
    $ver = $manifest.current_version
    $verInfo = $manifest.versions | Where-Object { $_.version -eq $ver }

    if (-not $verInfo) {
        throw "Version '$ver' not found in manifest versions array"
    }

    $installDir  = $ExecutionContext.InvokeCommand.ExpandString($manifest.install_target)
    $exeName     = $manifest.executable
    $exePath     = Join-Path $installDir $exeName
    $zipUrl      = $verInfo.download_url
    $expectedSHA = $verInfo.sha256
    $zipPath     = "$env:TEMP\$($app.id)_$ver.zip"
    $regKey      = "HKCU:\Software\PennyAdmixture\Installers\$($app.id)"

    # ── Banner ──────────────────────────────────────────────────────────────
    Write-Host ""
    Write-Host "  Installing $($app.name) v$ver" -ForegroundColor Magenta
    Write-Host "  $($app.description)" -ForegroundColor DarkGray
    Write-Host "  Source: $($app.source_repo)" -ForegroundColor DarkGray
    Write-Host ""

    # ── Kill if running ─────────────────────────────────────────────────────
    $procName = [System.IO.Path]::GetFileNameWithoutExtension($exeName)
    $running = Get-Process -Name $procName -ErrorAction SilentlyContinue
    if ($running) {
        Write-Host "==> Stopping running instance..." -ForegroundColor Yellow
        $running | Stop-Process -Force
        Start-Sleep -Seconds 1
    }

    # ── Download ────────────────────────────────────────────────────────────
    Write-Host "==> Downloading..." -ForegroundColor Cyan
    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $zipUrl -OutFile $zipPath -UseBasicParsing
    $ProgressPreference = 'Continue'

    # ── Verify ──────────────────────────────────────────────────────────────
    Write-Host "==> Verifying SHA-256..." -ForegroundColor Cyan
    $actual = (Get-FileHash $zipPath -Algorithm SHA256).Hash.ToLower()
    if ($actual -ne $expectedSHA) {
        Remove-Item $zipPath -Force -ErrorAction SilentlyContinue
        throw "Hash mismatch for $($app.name)! Expected $expectedSHA, got $actual"
    }
    Write-Host "    Hash OK" -ForegroundColor Green

    # ── Extract ─────────────────────────────────────────────────────────────
    Write-Host "==> Extracting to $installDir ..." -ForegroundColor Cyan
    if (Test-Path $installDir) { Remove-Item $installDir -Recurse -Force }
    New-Item -ItemType Directory -Path $installDir | Out-Null
    Expand-Archive -Path $zipPath -DestinationPath $installDir -Force
    Remove-Item $zipPath -Force

    # Flatten nested dir if needed
    $innerDirs = Get-ChildItem -Path $installDir -Directory
    if ($innerDirs.Count -eq 1 -and -not (Test-Path $exePath)) {
        $innerExe = Join-Path $innerDirs[0].FullName $exeName
        if (Test-Path $innerExe) {
            Get-ChildItem -Path $innerDirs[0].FullName | Move-Item -Destination $installDir -Force
            Remove-Item $innerDirs[0].FullName -Force
        }
    }

    # ── Shortcuts ───────────────────────────────────────────────────────────
    if (-not $NoShortcuts) {
        $wsh = New-Object -ComObject WScript.Shell

        $startLnk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\$($app.name).lnk"
        $sc = $wsh.CreateShortcut($startLnk)
        $sc.TargetPath = $exePath; $sc.WorkingDirectory = $installDir
        $sc.Description = "$($app.name) v$ver"; $sc.Save()

        $deskLnk = "$env:USERPROFILE\Desktop\$($app.name).lnk"
        $dc = $wsh.CreateShortcut($deskLnk)
        $dc.TargetPath = $exePath; $dc.WorkingDirectory = $installDir
        $dc.Description = "$($app.name) v$ver"; $dc.Save()

        Write-Host "==> Shortcuts created" -ForegroundColor Green
    }

    # ── Registry ────────────────────────────────────────────────────────────
    if (-not (Test-Path $regKey)) { New-Item -Path $regKey -Force | Out-Null }
    Set-ItemProperty -Path $regKey -Name "InstallDir"  -Value $installDir
    Set-ItemProperty -Path $regKey -Name "Version"     -Value $ver
    Set-ItemProperty -Path $regKey -Name "Executable"  -Value $exePath
    Set-ItemProperty -Path $regKey -Name "InstallDate" -Value (Get-Date -Format "o")
    Set-ItemProperty -Path $regKey -Name "SourceRepo"  -Value $app.source_repo

    # ── Receipt ─────────────────────────────────────────────────────────────
    @{
        app = $app.name; version = $ver; install_dir = $installDir
        install_date = (Get-Date -Format "o"); sha256 = $expectedSHA
    } | ConvertTo-Json | Out-File "$installDir\.install-receipt.json" -Encoding utf8

    # ── Launch ──────────────────────────────────────────────────────────────
    Write-Host ""
    Write-Host "  $($app.name) v$ver installed successfully." -ForegroundColor Green
    Write-Host ""

    if (-not $NoLaunch -and (Test-Path $exePath)) {
        Write-Host "==> Launching..." -ForegroundColor Cyan
        Start-Process $exePath
    }
}
