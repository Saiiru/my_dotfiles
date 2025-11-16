#!/usr/bin/env bash
set -euo pipefail

install_core_packages() {
    local packages=(
        zsh git curl wget
        kitty tmux
        eza bat fd ripgrep fzf zoxide starship
        neovim
        just
        fastfetch
    )

    echo "[packages] Installing base packages: ${packages[*]}"
    if command -v pacman &>/dev/null; then
        sudo pacman -S --needed --noconfirm "${packages[@]}" || echo "[packages] warning: some pacman installs failed"
    elif command -v apt &>/dev/null; then
        sudo apt install -y "${packages[@]}" || echo "[packages] warning: some apt installs failed"
    else
        echo "[packages] skipping – no supported package manager"
    fi
}
