#!/usr/bin/env bash
set -euo pipefail
file="${TMUX_GRIMORIO_FILE:-$HOME/Documents/Grimorio.md}"
mkdir -p "$(dirname "$file")"
:${EDITOR:=nvim}

if ! command -v "$EDITOR" >/dev/null 2>&1; then
  printf 'WARNING: editor "%s" not found. Set $EDITOR before calling Grimorio.\n' "$EDITOR" >&2
  read -r -p "Press ENTER to close..." _
  exit 0
fi

"$EDITOR" "$file"
