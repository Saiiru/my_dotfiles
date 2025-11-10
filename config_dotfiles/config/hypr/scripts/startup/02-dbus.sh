#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Updates the DBus activation environment

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "dbus-update-activation-environment"
check_dependency "notify-send"

# Updates the DBus activation environment
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "D-Bus" "D-Bus activation environment updated."
else
    notify-send -i "$iDIR/error.png" "Error: D-Bus" "Failed to update D-Bus activation environment."
fi
