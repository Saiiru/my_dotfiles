#!/usr/bin/env bash
# Listens to DBus notifications and triggers the sound script
set -euo pipefail

SCRIPT_DIR="$HOME/.config/mako"
SOUND_SCRIPT="$SCRIPT_DIR/notify-sound.sh"

if [[ ! -x "$SOUND_SCRIPT" ]]; then
  exit 0
fi

exec dbus-monitor "interface='org.freedesktop.Notifications',member='Notify'" \
  | while read -r line; do
      case "$line" in
        *"member=Notify"*)
          "$SOUND_SCRIPT" || true
          ;;
      esac
    done
