#!/usr/bin/env bash
# Play notification sound using the main Cyberpunk MP3 from the repo.
set -euo pipefail

export PATH="/usr/bin:/bin:/usr/local/bin:${PATH:-}"

KIND="${1:-normal}" # not used, but kept for future variants
MP3="$HOME/workstation/config/sounds/cyberpunk_notification.mp3"

[[ -f "$MP3" ]] || exit 0

{
  echo "[notify-sound] $(date '+%F %T') kind=${KIND} mp3=${MP3}"
} >> /tmp/quickshell-sound.log 2>&1

if command -v pw-play >/dev/null 2>&1; then
  pw-play "$MP3" >/dev/null 2>&1 &
  exit 0
fi

if command -v ffplay >/dev/null 2>&1; then
  ffplay -nodisp -autoexit -loglevel quiet "$MP3" >/dev/null 2>&1 &
  exit 0
fi

if command -v paplay >/dev/null 2>&1; then
  paplay "$MP3" >/dev/null 2>&1 &
  exit 0
fi

# If nothing available, do nothing silently
exit 0
