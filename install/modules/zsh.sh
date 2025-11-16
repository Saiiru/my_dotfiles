#!/usr/bin/env bash
set -euo pipefail

configure_zsh() {
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        echo "[zsh] changing default shell to zsh"
        chsh -s "$(which zsh)" || echo "[zsh] warning: shell change may require sudo"
    fi

    mkdir -p "$HOME/.cache/zsh" "$HOME/.local/state/zsh" "$HOME/.local/share/zsh"

    if [[ ! -d "$HOME/.local/share/znap" ]]; then
        echo "[zsh] installing znap"
        git clone --depth 1 https://github.com/marlonrichert/zsh-snap.git "$HOME/.local/share/znap"
    fi
}
