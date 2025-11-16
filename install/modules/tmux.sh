#!/usr/bin/env bash
set -euo pipefail

setup_tmux_plugins() {
    local plugins_dir="$HOME/.tmux/plugins"
    local tpm_dir="$plugins_dir/tpm"

    mkdir -p "$plugins_dir"

    if [[ -d "$tpm_dir/.git" ]]; then
        git -C "$tpm_dir" pull --ff-only >/dev/null 2>&1 || true
        echo "[tmux] TPM already installed"
    else
        echo "[tmux] Installing TPM into $tpm_dir"
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi
}
