#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad.
# Edit the Touchpad_Device on ~/.config/hypr/UserConfigs/Laptops.conf according to your system
# use hyprctl devices to get your system touchpad device name
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

notif="$HOME/.config/swaync/images/ja.png"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$notif" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprctl"
check_dependency "notify-send"

export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    notify-send -u low -i "$notif"  " Enabling" " touchpad"
    hyprctl keyword '$TOUCHPAD_ENABLED' "true" -r || notify-send -i "$notif" "Error" "Failed to enable touchpad via hyprctl."
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i "$notif" " Disabling" " touchpad"
    hyprctl keyword '$TOUCHPAD_ENABLED' "false" -r || notify-send -i "$notif" "Error" "Failed to disable touchpad via hyprctl."
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_touchpad
else
  if [ "$(cat "$STATUS_FILE")" = "true" ]; then
    disable_touchpad
  elif [ "$(cat "$STATUS_FILE")" = "false" ]; then
    enable_touchpad
  fi
fi
