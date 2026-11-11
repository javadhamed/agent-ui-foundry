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
Write-Host "[2/3] Installing Foundry UI/UX engines and skills..." -ForegroundColor Yellow
$Packages = @("awesome-design-md", "hallmark", "ui-ux-pro-max-skill")

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
} else {
    Write-Host "[3/3] Global skills directory not found. Packages installed locally in $TargetDir." -ForegroundColor Gray
}

Write-Host ""
Write-Host "==========================================" -ForegroundColor Green
Write-Host "Installation completed successfully! ⭐" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host "UI/UX Engines ready:"
Write-Host "  - 84 Brand Design Systems (awesome-design-md)"
Write-Host "  - Anti-AI-Slop & Anatomy Engine (hallmark)"
Write-Host "  - Offline Design Intelligence & BM25 (ui-ux-pro-max-skill)"
Write-Host ""
