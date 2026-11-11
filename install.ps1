<#
.SYNOPSIS
    Agent UI Foundry - One-Click Installer for Windows
.DESCRIPTION
    Installs and links all design intelligence skills, rules, and engines to your AI coding agents.
#>

[CmdletBinding()]
param(
    [string]$TargetDir = "$HOME\.gemini\config\plugins\agent-ui-foundry"
)

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "       Agent UI Foundry Installer        " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# 1. Target Directory Setup
Write-Host "[1/3] Preparing target directory: $TargetDir" -ForegroundColor Yellow
if (-not (Test-Path $TargetDir)) {
    New-Item -ItemType Directory -Path $TargetDir -Force | Out-Null
}

# 2. Copy packages and core assets
Write-Host "[2/3] Installing Foundry engines and skills..." -ForegroundColor Yellow
$Packages = @("awesome-design-md", "elephant-goldfish-model", "hallmark", "ui-ux-pro-max-skill")

foreach ($pkg in $Packages) {
    $src = Join-Path $ScriptDir "packages\$pkg"
    $dest = Join-Path $TargetDir "packages\$pkg"
    if (Test-Path $src) {
        Write-Host "  -> Deploying $pkg..." -ForegroundColor Gray
        if (-not (Test-Path $dest)) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }
        Copy-Item -Path "$src\*" -Destination $dest -Recurse -Force
    }
}

# 3. Create global skill links if standard skill dir exists
$GlobalSkillsDir = "$HOME\.gemini\config\skills"
if (Test-Path $GlobalSkillsDir) {
    Write-Host "[3/3] Linking skills to global assistant..." -ForegroundColor Yellow
    
    # Link Hallmark skill
    $hallmarkSkillSrc = Join-Path $TargetDir "packages\hallmark\skills\hallmark"
    $hallmarkSkillDest = Join-Path $GlobalSkillsDir "hallmark"
    if ((Test-Path $hallmarkSkillSrc) -and (-not (Test-Path $hallmarkSkillDest))) {
        New-Item -ItemType Junction -Path $hallmarkSkillDest -Value $hallmarkSkillSrc | Out-Null
        Write-Host "  -> Linked Hallmark Skill" -ForegroundColor Green
    }

    # Link EGM skills
    $egmSkillsSrc = Join-Path $TargetDir "packages\elephant-goldfish-model\skills"
    if (Test-Path $egmSkillsSrc) {
        Get-ChildItem -Directory $egmSkillsSrc | ForEach-Object {
            $destPath = Join-Path $GlobalSkillsDir $_.Name
            if (-not (Test-Path $destPath)) {
                New-Item -ItemType Junction -Path $destPath -Value $_.FullName | Out-Null
                Write-Host "  -> Linked EGM Skill: $($_.Name)" -ForegroundColor Green
            }
        }
    }
} else {
    Write-Host "[3/3] Global skills directory not found. Packages installed locally in $TargetDir." -ForegroundColor Gray
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Installation completed successfully! ⭐" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Engines ready:"
Write-Host "  - 84 Design Systems (awesome-design-md)"
Write-Host "  - Anti-AI-Slop & Anatomy Engine (hallmark)"
Write-Host "  - Offline Design Intelligence & BM25 (ui-ux-pro-max-skill)"
Write-Host "  - Spec Architecture & Review Loop (elephant-goldfish-model)"
Write-Host ""
