#!/usr/bin/env bash
set -euo pipefail

if command -v gitmux >/dev/null 2>&1; then
  gitmux -cfg "$HOME/.config/tmux/gitmux.yml"
fi
