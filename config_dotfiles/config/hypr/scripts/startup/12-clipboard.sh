#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Starts the clipboard history manager for both text and images

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "wl-paste"
check_dependency "cliphist"
check_dependency "notify-send"

# Starts the clipboard history manager for both text and images
wl-paste --type text --watch cliphist store &
if [ $? -ne 0 ]; then
    notify-send -i "$iDIR/error.png" "Error: Clipboard" "Failed to start wl-paste for text clipboard history."
fi

wl-paste --type image --watch cliphist store &
if [ $? -ne 0 ]; then
    notify-send -i "$iDIR/error.png" "Error: Clipboard" "Failed to start wl-paste for image clipboard history."
fi

if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Clipboard" "Clipboard history managers started."
fi
