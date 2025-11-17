#!/usr/bin/env bash
set -euo pipefail

log_symlink() {
    local level="$1" msg="$2"
    printf '[symlinks][%s] %s\n' "$level" "$msg"
}

link_path() {
    local source="$1" target="$2"
    if [[ ! -e "$source" ]]; then
        log_symlink warn "skip missing source: $source"
        return 0
    fi
    mkdir -p "$(dirname "$target")"
    if [[ -e "$target" || -L "$target" ]]; then
        rm -rf "$target"
    fi
    ln -s "$source" "$target"
    log_symlink info "linked $target -> $source"
}

create_symlinks() {
    local repo_dir="$1"
    local config_dir="$repo_dir/config"

    # Top-level files
    link_path "$config_dir/zsh/zshrc" "$HOME/.zshrc"
    link_path "$repo_dir/themes/starship.toml" "$HOME/.config/starship.toml"

    link_path "$config_dir/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Config directories to sync into ~/.config
    local -a configs=(
        zsh
        kitty
        ghostty
        tmux
        mise
        niri
        wlogout
        quickshell
        systemd
        pipewire
        waybar
        dunst
        rofi
        fuzzel


    )

    for name in "${configs[@]}"; do
        link_path "$config_dir/$name" "$HOME/.config/$name"
    done
}
