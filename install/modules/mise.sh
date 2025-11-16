#!/usr/bin/env bash
set -euo pipefail

install_mise() {
    if command -v mise &>/dev/null; then
        echo "[mise] already installed"
        return
    fi

    echo "[mise] Installing mise toolchain manager"
    curl https://mise.run | sh
    export PATH="$HOME/.local/bin:$PATH"
}
