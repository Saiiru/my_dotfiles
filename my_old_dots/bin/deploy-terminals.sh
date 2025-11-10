#!/usr/bin/env bash
# Symlink Kitty, Ghostty, and tmux configs from the dotfiles repo.

set -euo pipefail

REPO_DIR="${REPO_DIR:-$HOME/dotfiles}"
TS="$(date +%Y%m%d-%H%M%S)"

backup_then_link() {
    local src="$1"
    local dest="$2"

    mkdir -p "$(dirname "$dest")"

    if [[ -e "$dest" && ! -L "$dest" ]]; then
        mv "$dest" "${dest}.bak.${TS}"
        printf '↺ Backed up %s -> %s\n' "$dest" "${dest}.bak.${TS}"
    fi

    ln -sfn "$src" "$dest"
    printf '✓ Linked %s -> %s\n' "$dest" "$src"
}

backup_then_link "$REPO_DIR/config/kitty"   "$HOME/.config/kitty"
backup_then_link "$REPO_DIR/config/ghostty" "$HOME/.config/ghostty"
backup_then_link "$REPO_DIR/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"

printf '\nDone. Restart Kitty/Ghostty or reload tmux with <prefix>+r.\n'
