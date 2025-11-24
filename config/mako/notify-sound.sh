#!/usr/bin/env bash
# Play the Batcave notification sound (prefer OGG)
set -euo pipefail

SOUND_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/sounds/cyberpunk"
SOUND_FILE="${SOUND_DIR}/cyberpunk_notification.ogg"

# Fallbacks
FALLBACKS=(
  "${SOUND_DIR}/cyberpunk_notification.mp3"
  "/usr/share/sounds/freedesktop/stereo/message.oga"
  "/usr/share/sounds/freedesktop/stereo/dialog-information.oga"
  "/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"
)

pick_sound() {
  if [[ -f "$SOUND_FILE" ]]; then
    printf '%s\n' "$SOUND_FILE" && return
  fi
  for f in "${FALLBACKS[@]}"; do
    [[ -f "$f" ]] && { printf '%s\n' "$f"; return; }
  done
  exit 0
}

play() {
  local file="$1"
  if command -v pw-play >/dev/null 2>&1; then
    pw-play "$file" >/dev/null 2>&1 &
    return
  fi
  if command -v paplay >/dev/null 2>&1; then
    paplay "$file" >/dev/null 2>&1 &
    return
  fi
  if command -v canberra-gtk-play >/dev/null 2>&1; then
    canberra-gtk-play -f "$file" >/dev/null 2>&1 &
    return
  fi
}

main() {
  local file
  file="$(pick_sound)" || exit 0
  play "$file"
}

main "$@"
