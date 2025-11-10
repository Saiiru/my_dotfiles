#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts the GNOME keyring daemon

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "gnome-keyring-daemon"
check_dependency "notify-send"

# Starts the GNOME keyring daemon
gnome-keyring-daemon --start --components=secrets &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Keyring" "GNOME Keyring daemon started."
else
    notify-send -i "$iDIR/error.png" "Error: Keyring" "Failed to start GNOME Keyring daemon."
fi
