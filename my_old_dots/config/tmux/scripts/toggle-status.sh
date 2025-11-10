#!/usr/bin/env bash
set -euo pipefail

if ! command -v tmux >/dev/null 2>&1; then
  printf 'tmux not available in this session.\n' >&2
  exit 0
fi

state=$(tmux show-option -gqv status || echo "on")
if [[ "$state" == "on" ]]; then
  tmux set -g status off
  tmux display-message "status bar off"
else
  tmux set -g status on
  tmux display-message "status bar on"
fi
