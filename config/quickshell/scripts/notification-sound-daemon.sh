#!/usr/bin/env bash
# Listens to org.freedesktop.Notifications and plays the Cyberpunk SFX.
set -euo pipefail

MP3="$HOME/workstation/config/sounds/cyberpunk_notification.mp3"
PLAYER="$(command -v pw-play || true)"

[[ -f "$MP3" ]] || exit 0
[[ -n "$PLAYER" ]] || exit 0

dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" |
while read -r line; do
  [[ "$line" == *"member=Notify"* ]] || continue
  "$PLAYER" "$MP3" >/dev/null 2>&1 &
done
