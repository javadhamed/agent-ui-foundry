#!/usr/bin/env bash
#
# Agent UI Foundry - One-Click Installer for Linux & macOS
#

set -e

echo "=========================================="
echo "       Agent UI Foundry Installer        "
echo "=========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${TARGET_DIR:-$HOME/.gemini/config/plugins/agent-ui-foundry}"
GLOBAL_SKILLS_DIR="${HOME}/.gemini/config/skills"

echo "[1/3] Preparing target directory: $TARGET_DIR"
mkdir -p "$TARGET_DIR"

echo "[2/3] Installing Foundry UI/UX engines and skills..."
PACKAGES=("awesome-design-md" "hallmark" "ui-ux-pro-max-skill")

for pkg in "${PACKAGES[@]}"; do
    src="$SCRIPT_DIR/packages/$pkg"
    dest="$TARGET_DIR/packages/$pkg"
    if [ -d "$src" ]; then
        echo "  -> Deploying $pkg..."
        mkdir -p "$dest"
        cp -R "$src/"* "$dest/"
    fi
done

echo "[3/3] Linking skills to global assistant..."
if [ -d "$GLOBAL_SKILLS_DIR" ]; then
    # Hallmark
    if [ -d "$TARGET_DIR/packages/hallmark/skills/hallmark" ] && [ ! -e "$GLOBAL_SKILLS_DIR/hallmark" ]; then
        ln -s "$TARGET_DIR/packages/hallmark/skills/hallmark" "$GLOBAL_SKILLS_DIR/hallmark"
        echo "  -> Linked Hallmark Skill"
    fi
else
    echo "  -> Global skills directory not found. Installed to $TARGET_DIR."
fi

echo ""
echo "=========================================="
echo "Installation completed successfully! ⭐"
echo "=========================================="
echo "UI/UX Engines ready:"
echo "  - 84 Brand Design Systems (awesome-design-md)"
echo "  - Anti-AI-Slop & Anatomy Engine (hallmark)"
echo "  - Offline Design Intelligence & BM25 (ui-ux-pro-max-skill)"
echo ""
