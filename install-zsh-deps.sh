#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# INSTALL ZSH KORA NEON DEPENDENCIES
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
set -euo pipefail

echo "📦 Installing ZSH dependencies..."
sudo pacman -S --needed --noconfirm \
  zsh git curl unzip ripgrep fd fzf bat eza btop procs \
  wl-clipboard zoxide

# --- AUR packages ---
# Check if paru or yay is installed
if command -v paru >/dev/null; then
    AUR_HELPER="paru"
elif command -v yay >/dev/null; then
    AUR_HELPER="yay"
else
    echo "AUR helper (paru or yay) not found. Please install oh-my-posh-bin manually."
    exit 1
fi

echo "📦 Installing AUR dependencies (oh-my-posh)..."
$AUR_HELPER -S --needed --noconfirm oh-my-posh-bin

echo ""

echo "✅ ZSH dependencies installed successfully!"
