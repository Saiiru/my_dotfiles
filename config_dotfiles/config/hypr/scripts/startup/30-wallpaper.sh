#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Initializes the wallpaper daemon and sets the default wallpaper

iDIR="$HOME/.config/swaync/images" # For notify-send icons
SCRIPTSDIR="$HOME/.config/hypr/scripts"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "swww"
check_dependency "notify-send"
check_dependency "$SCRIPTSDIR/WallustSwww.sh"

DEFAULT_WALLPAPER="/home/sairu/dotfiles/config_dotfiles/config/hypr/assets/wallpapers/lucy-cafe.jpg"

# Initializes the wallpaper daemon
swww-daemon --format xrgb &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Wallpaper" "SWWW daemon started."
else
    notify-send -i "$iDIR/error.png" "Error: Wallpaper" "Failed to start SWWW daemon."
    exit 1
fi

# Check if default wallpaper exists
if [[ ! -f "$DEFAULT_WALLPAPER" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Wallpaper" "Default wallpaper not found: $DEFAULT_WALLPAPER. Aborting."
    exit 1
fi

# Sets the default wallpaper
swww img "$DEFAULT_WALLPAPER" &
if [ $? -eq 0 ]; then
    notify-send -u low -i "$iDIR/ja.png" "Wallpaper" "Default wallpaper set."
    # Apply wallust colors based on the new wallpaper
    "${SCRIPTSDIR}/WallustSwww.sh" "$DEFAULT_WALLPAPER" &
else
    notify-send -i "$iDIR/error.png" "Error: Wallpaper" "Failed to set default wallpaper."
fi
