#!/usr/bin/env bash
# Converte config/sounds/cyberpunk_notification.mp3 para OGG(s) usados pelo Quickshell
set -euo pipefail

SRC="$HOME/workstation/config/sounds/cyberpunk_notification.mp3"
DEST_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sounds/batcave"
mkdir -p "$DEST_DIR"

if [[ ! -f "$SRC" ]]; then
  echo "[convert] Fonte não encontrada: $SRC" >&2
  exit 0
fi

convert_one() {
  local target="$1"
  if command -v ffmpeg >/dev/null 2>&1; then
    ffmpeg -y -i "$SRC" -c:a libvorbis -q:a 5 "$target" >/dev/null 2>&1
  elif command -v sox >/dev/null 2>&1; then
    sox "$SRC" "$target"
  else
    cp "$SRC" "$target"
  fi
}

convert_one "$DEST_DIR/notify-normal.ogg"
convert_one "$DEST_DIR/notify-low.ogg"
convert_one "$DEST_DIR/notify-critical.ogg"

echo "[convert] Sons prontos em $DEST_DIR"
