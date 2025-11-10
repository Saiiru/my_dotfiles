#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Sets the cursor theme and size

# --- Configuration ---
CURSOR_THEME="Bibata-Modern-Classic"
CURSOR_SIZE=24
iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "hyprctl"
check_dependency "notify-send"

# Sets the cursor theme and size
hyprctl setcursor "$CURSOR_THEME" "$CURSOR_SIZE"
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Cursor" "Cursor theme set to $CURSOR_THEME, size $CURSOR_SIZE."
else
    notify-send -i "$iDIR/error.png" "Error: Cursor" "Failed to set cursor theme or size."
fi
