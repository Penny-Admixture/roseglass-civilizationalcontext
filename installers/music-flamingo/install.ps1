# Music Flamingo — one-shot local installer for Windows 11
# Installs to $env:LOCALAPPDATA\MusicFlamingo
# Creates Python venv, installs PyTorch+CUDA, Transformers, Gradio
# Model weights (~16.6 GB) download on first launch via HuggingFace
# GPU auto-detection picks quantization level to fit your VRAM
#
# Prerequisites: Python 3.10+ and an NVIDIA GPU with CUDA drivers
#
# Usage:
#   irm https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/install.ps1 | iex

$ErrorActionPreference = 'Stop'

# ── Config ──────────────────────────────────────────────────────────────────
$appName     = "MusicFlamingo"
$appVersion  = "preview-2026"
$installDir  = "$env:LOCALAPPDATA\MusicFlamingo"
$venvDir     = "$installDir\venv"
$scriptsDir  = "$installDir\scripts"
$regKey      = "HKCU:\Software\PennyAdmixture\Installers\MusicFlamingo"
$modelId     = "nvidia/music-flamingo-hf"

# ── Banner ──────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ╔══════════════════════════════════════════════════════╗" -ForegroundColor Magenta
Write-Host "  ║   Music Flamingo — Local Installer                   ║" -ForegroundColor Magenta
Write-Host "  ║   NVIDIA's Music Understanding AI (8B params)        ║" -ForegroundColor Magenta
Write-Host "  ║   github.com/NVIDIA/audio-flamingo                   ║" -ForegroundColor Magenta
Write-Host "  ╚══════════════════════════════════════════════════════╝" -ForegroundColor Magenta
Write-Host ""
Write-Host "  Model weights (~16.6 GB) will download on first launch." -ForegroundColor DarkGray
Write-Host "  Requires: Python 3.10+, NVIDIA GPU with CUDA drivers." -ForegroundColor DarkGray
Write-Host ""

# ── Check Python ────────────────────────────────────────────────────────────
Write-Host "==> Checking Python..." -ForegroundColor Cyan
$pythonCmd = $null
foreach ($candidate in @("python", "python3", "py")) {
    try {
        $ver = & $candidate --version 2>&1
        if ($ver -match "Python 3\.(\d+)") {
            $minor = [int]$Matches[1]
            if ($minor -ge 10) {
                $pythonCmd = $candidate
                Write-Host "    Found: $ver ($candidate)" -ForegroundColor Green
                break
            }
        }
    } catch {}
}
if (-not $pythonCmd) {
    Write-Host "    ERROR: Python 3.10+ not found." -ForegroundColor Red
    Write-Host "    Install from https://www.python.org/downloads/" -ForegroundColor Red
    Write-Host "    Make sure 'Add to PATH' is checked during install." -ForegroundColor Red
    exit 1
}

# ── Check NVIDIA GPU ───────────────────────────────────────────────────────
Write-Host "==> Detecting GPU..." -ForegroundColor Cyan
$gpuInfo = $null
$vramMB = 0
try {
    $nvidiaSmi = & nvidia-smi --query-gpu=name,memory.total --format=csv,noheader,nounits 2>&1
    if ($nvidiaSmi -match "^(.+),\s*(\d+)") {
        $gpuName = $Matches[1].Trim()
        $vramMB = [int]$Matches[2]
        $vramGB = [math]::Round($vramMB / 1024, 1)
        Write-Host "    GPU: $gpuName ($vramGB GB VRAM)" -ForegroundColor Green
    }
} catch {
    Write-Host "    WARNING: nvidia-smi not found. CUDA may not be installed." -ForegroundColor Yellow
    Write-Host "    Install NVIDIA drivers from https://www.nvidia.com/drivers" -ForegroundColor Yellow
    Write-Host "    Continuing anyway (will fail at runtime without CUDA)..." -ForegroundColor Yellow
}

# ── Select quantization based on VRAM ──────────────────────────────────────
$quantMode = "4bit"  # safest default
$torchDtype = "float16"
$extraPipArgs = @()

if ($vramMB -ge 32000) {
    $quantMode = "fp16"
    Write-Host "    Mode: FP16 (full precision, $vramGB GB available)" -ForegroundColor Green
} elseif ($vramMB -ge 16000) {
    $quantMode = "8bit"
    Write-Host "    Mode: 8-bit quantization ($vramGB GB available)" -ForegroundColor Green
    $extraPipArgs += "bitsandbytes"
} elseif ($vramMB -ge 6000) {
    $quantMode = "4bit"
    Write-Host "    Mode: 4-bit quantization ($vramGB GB available)" -ForegroundColor Green
    $extraPipArgs += "bitsandbytes"
} else {
    Write-Host "    WARNING: Less than 6 GB VRAM detected." -ForegroundColor Yellow
    Write-Host "    4-bit mode will be used but may be tight. Consider CPU offload." -ForegroundColor Yellow
    $quantMode = "4bit"
    $extraPipArgs += "bitsandbytes"
}

# ── Create install directory ────────────────────────────────────────────────
Write-Host "==> Creating install directory..." -ForegroundColor Cyan
New-Item -ItemType Directory -Path $installDir -Force | Out-Null
New-Item -ItemType Directory -Path $scriptsDir -Force | Out-Null

# ── Create Python venv ──────────────────────────────────────────────────────
Write-Host "==> Creating Python virtual environment..." -ForegroundColor Cyan
if (Test-Path $venvDir) {
    Write-Host "    Removing existing venv..." -ForegroundColor DarkGray
    Remove-Item $venvDir -Recurse -Force
}
& $pythonCmd -m venv $venvDir
if (-not (Test-Path "$venvDir\Scripts\python.exe")) {
    Write-Host "    ERROR: Failed to create venv." -ForegroundColor Red
    exit 1
}
Write-Host "    Venv created." -ForegroundColor Green

$venvPython = "$venvDir\Scripts\python.exe"
$venvPip    = "$venvDir\Scripts\pip.exe"

# ── Install PyTorch with CUDA ───────────────────────────────────────────────
Write-Host "==> Installing PyTorch with CUDA support..." -ForegroundColor Cyan
Write-Host "    (This may take several minutes)" -ForegroundColor DarkGray
& $venvPip install --upgrade pip setuptools wheel 2>&1 | Out-Null
& $venvPip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124 2>&1 | ForEach-Object {
    if ($_ -match "Successfully installed") { Write-Host "    $_" -ForegroundColor Green }
}

# ── Install Transformers + deps ─────────────────────────────────────────────
Write-Host "==> Installing Transformers, Accelerate, Gradio..." -ForegroundColor Cyan
$pipPackages = @(
    "git+https://github.com/huggingface/transformers",
    "accelerate",
    "gradio>=4.0",
    "soundfile",
    "librosa",
    "scipy",
    "numpy"
) + $extraPipArgs

& $venvPip install @pipPackages 2>&1 | ForEach-Object {
    if ($_ -match "Successfully installed") { Write-Host "    $_" -ForegroundColor Green }
}

# ── Verify CUDA is accessible from PyTorch ──────────────────────────────────
Write-Host "==> Verifying CUDA in PyTorch..." -ForegroundColor Cyan
$cudaCheck = & $venvPython -c "import torch; print(f'CUDA available: {torch.cuda.is_available()}, Device: {torch.cuda.get_device_name(0) if torch.cuda.is_available() else \"none\"}')" 2>&1
Write-Host "    $cudaCheck" -ForegroundColor $(if ($cudaCheck -match "True") { "Green" } else { "Yellow" })

# ── Write config file ──────────────────────────────────────────────────────
$configJson = @{
    model_id   = $modelId
    quant_mode = $quantMode
    torch_dtype = $torchDtype
    vram_mb    = $vramMB
    gpu_name   = if ($gpuName) { $gpuName } else { "unknown" }
} | ConvertTo-Json
$configJson | Out-File "$installDir\config.json" -Encoding utf8

# ── Write Gradio web UI script ──────────────────────────────────────────────
Write-Host "==> Writing inference scripts..." -ForegroundColor Cyan

@'
"""Music Flamingo — Gradio Web UI for local inference."""
import json, os, sys, gradio as gr

CONFIG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "config.json")
with open(CONFIG_PATH) as f:
    config = json.load(f)

MODEL_ID = config["model_id"]
QUANT_MODE = config["quant_mode"]

print(f"Loading Music Flamingo ({QUANT_MODE} mode)...")
print(f"Model: {MODEL_ID}")
print(f"First run will download ~16.6 GB of model weights.")
print()

import torch
from transformers import AudioFlamingo3ForConditionalGeneration, AutoProcessor

load_kwargs = {"device_map": "auto"}

if QUANT_MODE == "4bit":
    from transformers import BitsAndBytesConfig
    load_kwargs["quantization_config"] = BitsAndBytesConfig(
        load_in_4bit=True,
        bnb_4bit_compute_dtype=torch.float16,
        bnb_4bit_quant_type="nf4",
        bnb_4bit_use_double_quant=True,
    )
elif QUANT_MODE == "8bit":
    from transformers import BitsAndBytesConfig
    load_kwargs["quantization_config"] = BitsAndBytesConfig(load_in_8bit=True)
else:
    load_kwargs["torch_dtype"] = torch.float16

print("Loading processor...")
processor = AutoProcessor.from_pretrained(MODEL_ID)
print("Loading model (this may take a while on first run)...")
model = AudioFlamingo3ForConditionalGeneration.from_pretrained(MODEL_ID, **load_kwargs)
print("Model loaded!")

PRESET_PROMPTS = [
    "Describe this track in full detail — genre, tempo, key, instruments, production style, and overall mood.",
    "What key is this song in? What chord progressions do you hear?",
    "Write a rich caption blending technical details (genre, BPM, key, chords, mix) with how the song feels emotionally.",
    "Identify all instruments you can hear in this recording.",
    "What genre and subgenre does this track belong to? What are its influences?",
    "Transcribe the lyrics you hear in this audio.",
    "Analyze the song structure — intro, verses, chorus, bridge, outro — and describe what happens in each section.",
    "Compare this track's production style to well-known artists or songs in a similar vein.",
    "What emotions does this music evoke, and what musical elements create those feelings?",
    "Estimate the BPM and describe the rhythmic patterns and time signature.",
]

def analyze_audio(audio_path, prompt, temperature, max_tokens):
    if audio_path is None:
        return "Please upload an audio file."
    if not prompt.strip():
        return "Please enter a prompt."

    conversation = [
        {
            "role": "user",
            "content": [
                {"type": "text", "text": prompt.strip()},
                {"type": "audio", "path": audio_path},
            ],
        }
    ]

    inputs = processor.apply_chat_template(
        conversation,
        tokenize=True,
        add_generation_prompt=True,
        return_dict=True,
    ).to(model.device)

    gen_kwargs = {"max_new_tokens": int(max_tokens)}
    if temperature > 0:
        gen_kwargs["do_sample"] = True
        gen_kwargs["temperature"] = temperature
    else:
        gen_kwargs["do_sample"] = False

    with torch.inference_mode():
        outputs = model.generate(**inputs, **gen_kwargs)

    result = processor.batch_decode(
        outputs[:, inputs.input_ids.shape[1]:],
        skip_special_tokens=True
    )[0]

    return result.strip()

with gr.Blocks(
    title="Music Flamingo",
    theme=gr.themes.Soft(primary_hue="pink", secondary_hue="purple"),
) as demo:
    gr.Markdown("# 🦩 Music Flamingo — Local Inference")
    gr.Markdown(f"**Model:** `{MODEL_ID}` | **Mode:** {QUANT_MODE} | **GPU:** {config.get('gpu_name', 'unknown')}")

    with gr.Row():
        with gr.Column(scale=1):
            audio_input = gr.Audio(type="filepath", label="Upload audio (WAV/MP3/FLAC)")
            prompt_input = gr.Textbox(
                label="Prompt",
                placeholder="What do you want to know about this music?",
                lines=3,
                value=PRESET_PROMPTS[0],
            )
            preset_dropdown = gr.Dropdown(
                choices=PRESET_PROMPTS,
                label="Preset prompts",
                value=PRESET_PROMPTS[0],
                interactive=True,
            )
            preset_dropdown.change(lambda x: x, preset_dropdown, prompt_input)

            with gr.Row():
                temperature = gr.Slider(0, 1.5, value=0.0, step=0.05, label="Temperature (0 = deterministic)")
                max_tokens = gr.Slider(64, 2048, value=1024, step=64, label="Max tokens")

            analyze_btn = gr.Button("🎵 Analyze", variant="primary", size="lg")

        with gr.Column(scale=1):
            output = gr.Textbox(label="Music Flamingo says:", lines=20, show_copy_button=True)

    analyze_btn.click(
        fn=analyze_audio,
        inputs=[audio_input, prompt_input, temperature, max_tokens],
        outputs=output,
    )

    gr.Markdown("---")
    gr.Markdown("*Non-commercial research use only. [NVIDIA OneWay Noncommercial License](https://huggingface.co/nvidia/music-flamingo-hf)*")

if __name__ == "__main__":
    demo.launch(
        server_name="127.0.0.1",
        server_port=7870,
        inbrowser=True,
        share=False,
    )
'@ | Out-File "$scriptsDir\webui.py" -Encoding utf8

# ── Write CLI script ───────────────────────────────────────────────────────
@'
"""Music Flamingo — CLI inference. Pass an audio file and a prompt."""
import argparse, json, os, sys

CONFIG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "config.json")
with open(CONFIG_PATH) as f:
    config = json.load(f)

def main():
    parser = argparse.ArgumentParser(description="Music Flamingo CLI")
    parser.add_argument("audio", help="Path to audio file (WAV/MP3/FLAC)")
    parser.add_argument("-p", "--prompt", default="Describe this track in full detail — genre, tempo, key, instruments, production style, and overall mood.",
                        help="Text prompt")
    parser.add_argument("-t", "--temperature", type=float, default=0.0, help="Sampling temperature (0=deterministic)")
    parser.add_argument("-m", "--max-tokens", type=int, default=1024, help="Max output tokens")
    args = parser.parse_args()

    if not os.path.isfile(args.audio):
        print(f"Error: File not found: {args.audio}")
        sys.exit(1)

    MODEL_ID = config["model_id"]
    QUANT_MODE = config["quant_mode"]

    print(f"Loading Music Flamingo ({QUANT_MODE})...")

    import torch
    from transformers import AudioFlamingo3ForConditionalGeneration, AutoProcessor

    load_kwargs = {"device_map": "auto"}
    if QUANT_MODE == "4bit":
        from transformers import BitsAndBytesConfig
        load_kwargs["quantization_config"] = BitsAndBytesConfig(
            load_in_4bit=True, bnb_4bit_compute_dtype=torch.float16,
            bnb_4bit_quant_type="nf4", bnb_4bit_use_double_quant=True,
        )
    elif QUANT_MODE == "8bit":
        from transformers import BitsAndBytesConfig
        load_kwargs["quantization_config"] = BitsAndBytesConfig(load_in_8bit=True)
    else:
        load_kwargs["torch_dtype"] = torch.float16

    processor = AutoProcessor.from_pretrained(MODEL_ID)
    model = AudioFlamingo3ForConditionalGeneration.from_pretrained(MODEL_ID, **load_kwargs)
    print("Model loaded.\n")

    conversation = [{"role": "user", "content": [
        {"type": "text", "text": args.prompt},
        {"type": "audio", "path": os.path.abspath(args.audio)},
    ]}]

    inputs = processor.apply_chat_template(
        conversation, tokenize=True, add_generation_prompt=True, return_dict=True,
    ).to(model.device)

    gen_kwargs = {"max_new_tokens": args.max_tokens}
    if args.temperature > 0:
        gen_kwargs["do_sample"] = True
        gen_kwargs["temperature"] = args.temperature

    with torch.inference_mode():
        outputs = model.generate(**inputs, **gen_kwargs)

    result = processor.batch_decode(outputs[:, inputs.input_ids.shape[1]:], skip_special_tokens=True)[0]
    print(result.strip())

if __name__ == "__main__":
    main()
'@ | Out-File "$scriptsDir\cli.py" -Encoding utf8

# ── Write batch launcher scripts ───────────────────────────────────────────

# Web UI launcher
@"
@echo off
title Music Flamingo — Web UI
echo.
echo  Starting Music Flamingo Web UI...
echo  Browser will open at http://127.0.0.1:7870
echo  Press Ctrl+C to stop.
echo.
call "$venvDir\Scripts\activate.bat"
python "$scriptsDir\webui.py"
pause
"@ | Out-File "$installDir\Launch-WebUI.bat" -Encoding ascii

# CLI launcher
@"
@echo off
title Music Flamingo — CLI
call "$venvDir\Scripts\activate.bat"
if "%~1"=="" (
    echo Usage: Launch-CLI.bat "path\to\audio.mp3" [-p "your prompt"]
    echo.
    echo Example:
    echo   Launch-CLI.bat "C:\Music\track.mp3"
    echo   Launch-CLI.bat "C:\Music\track.mp3" -p "What key is this song in?"
    pause
    exit /b
)
python "$scriptsDir\cli.py" %*
pause
"@ | Out-File "$installDir\Launch-CLI.bat" -Encoding ascii

# ── Create shortcuts ───────────────────────────────────────────────────────
Write-Host "==> Creating shortcuts..." -ForegroundColor Cyan
$wsh = New-Object -ComObject WScript.Shell

$startLnk = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\Music Flamingo.lnk"
$sc = $wsh.CreateShortcut($startLnk)
$sc.TargetPath       = "$installDir\Launch-WebUI.bat"
$sc.WorkingDirectory = $installDir
$sc.Description      = "Music Flamingo — AI Music Understanding (Local)"
$sc.Save()
Write-Host "    Start Menu shortcut created" -ForegroundColor Green

$deskLnk = "$env:USERPROFILE\Desktop\Music Flamingo.lnk"
$dc = $wsh.CreateShortcut($deskLnk)
$dc.TargetPath       = "$installDir\Launch-WebUI.bat"
$dc.WorkingDirectory = $installDir
$dc.Description      = "Music Flamingo — AI Music Understanding (Local)"
$dc.Save()
Write-Host "    Desktop shortcut created" -ForegroundColor Green

# ── Registry breadcrumb ────────────────────────────────────────────────────
Write-Host "==> Writing install metadata..." -ForegroundColor Cyan
if (-not (Test-Path $regKey)) { New-Item -Path $regKey -Force | Out-Null }
Set-ItemProperty -Path $regKey -Name "InstallDir"  -Value $installDir
Set-ItemProperty -Path $regKey -Name "Version"     -Value $appVersion
Set-ItemProperty -Path $regKey -Name "Executable"  -Value "$installDir\Launch-WebUI.bat"
Set-ItemProperty -Path $regKey -Name "InstallDate" -Value (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
Set-ItemProperty -Path $regKey -Name "SourceRepo"  -Value "https://github.com/NVIDIA/audio-flamingo"
Set-ItemProperty -Path $regKey -Name "ModelId"     -Value $modelId
Set-ItemProperty -Path $regKey -Name "QuantMode"   -Value $quantMode
Set-ItemProperty -Path $regKey -Name "InstallerURL" -Value "https://raw.githubusercontent.com/Penny-Admixture/roseglass-civilizationalcontext/main/installers/music-flamingo/install.ps1"

# ── Install receipt ────────────────────────────────────────────────────────
@{
    app          = $appName
    version      = $appVersion
    install_dir  = $installDir
    install_date = (Get-Date -Format "o")
    model_id     = $modelId
    quant_mode   = $quantMode
    gpu          = if ($gpuName) { $gpuName } else { "unknown" }
    vram_gb      = if ($vramMB -gt 0) { [math]::Round($vramMB/1024,1) } else { 0 }
    source_repo  = "https://github.com/NVIDIA/audio-flamingo"
} | ConvertTo-Json | Out-File "$installDir\.install-receipt.json" -Encoding utf8

# ── Summary ─────────────────────────────────────────────────────────────────
Write-Host ""
Write-Host "  ┌────────────────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "  │  Music Flamingo installed successfully!                 │" -ForegroundColor Green
Write-Host "  │                                                        │" -ForegroundColor Green
Write-Host "  │  Location:   $installDir" -ForegroundColor Green
Write-Host "  │  Quant mode: $quantMode" -ForegroundColor Green
Write-Host "  │  Web UI:     http://127.0.0.1:7870" -ForegroundColor Green
Write-Host "  │                                                        │" -ForegroundColor Green
Write-Host "  │  First launch downloads ~16.6 GB of model weights.     │" -ForegroundColor Green
Write-Host "  │  Subsequent launches are instant.                      │" -ForegroundColor Green
Write-Host "  │                                                        │" -ForegroundColor Green
Write-Host "  │  Launch: Double-click 'Music Flamingo' on Desktop      │" -ForegroundColor Green
Write-Host "  │                                                        │" -ForegroundColor Green
Write-Host "  │  CLI usage:                                            │" -ForegroundColor Green
Write-Host "  │  Launch-CLI.bat 'song.mp3' -p 'What key is this in?'   │" -ForegroundColor Green
Write-Host "  └────────────────────────────────────────────────────────┘" -ForegroundColor Green
Write-Host ""
Write-Host "  NOTE: Non-commercial research use only (NVIDIA license)." -ForegroundColor DarkGray
Write-Host ""

# ── Offer to launch now ────────────────────────────────────────────────────
$launch = Read-Host "  Launch Web UI now? (y/n)"
if ($launch -eq "y" -or $launch -eq "Y") {
    Write-Host "==> Launching Web UI (first run will download model)..." -ForegroundColor Cyan
    Start-Process "$installDir\Launch-WebUI.bat"
}
Write-Host ""
