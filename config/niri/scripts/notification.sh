#!/bin/bash

# Path to the sound files (disabled by default)
SOUND_FILE_UPDATE="$HOME/.config/niri/sounds/update.wav"
SOUND_FILE_SYSTEM="$HOME/.config/niri/sounds/system-startup.wav"
SOUND_FILE_LOGOUT="$HOME/.config/niri/sounds/poweroff.mp3"
ENABLE_SOUND="${NIRI_NOTIFICATION_SOUNDS:-0}"

play_sound() {
    local file="$1"
    [[ "$ENABLE_SOUND" == "1" && -f "$file" ]] || return 0
    command -v paplay >/dev/null 2>&1 || return 0
    paplay "$file"
}

notify_with_sound() {
    notify-send "$1"
    play_sound "$SOUND_FILE_UPDATE"
}

startup_with_sound() {
    play_sound "$SOUND_FILE_SYSTEM"
}

logout_with_sound() {
    play_sound "$SOUND_FILE_LOGOUT"
}

case $1 in
  sys)
        startup_with_sound 
      ;;
  logout)
        logout_with_sound 
      ;;
  notify)
      if [ -n "$2" ]; then
          notify_with_sound "$2"
      else
          echo "Please provide a message for the notification."
      fi
      ;;
  *)
      echo "Usage: $0 {sys|notify} [message]"
      ;;
esac
