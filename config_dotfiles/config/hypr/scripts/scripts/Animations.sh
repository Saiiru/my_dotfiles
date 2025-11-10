#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For applying Animations from different users

# Variables
iDIR="$HOME/.config/swaync/images"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
animations_dir="$HOME/.config/hypr/animations"
UserConfigs="$HOME/.config/hypr/UserConfigs"
rofi_theme="$HOME/.config/rofi/config-Animations.rasi"
msg='❗NOTE:❗ This will copy animations into UserAnimations.conf'

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "find"
check_dependency "sed"
check_dependency "sort"
check_dependency "cp"
check_dependency "notify-send"
check_dependency "pidof"
check_dependency "$SCRIPTSDIR/RefreshNoWaybar.sh"

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# Check if animations directory exists and contains files
if [[ ! -d "$animations_dir" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Directory Not Found" "Animations directory not found: $animations_dir. Aborting."
    exit 1
fi

# list of animation files, sorted alphabetically with numbers first
animations_list=$(find -L "$animations_dir" -maxdepth 1 -type f -name "*.conf" | sed 's/.*\///' | sed 's/\.conf$//' | sort -V)

if [[ -z "$animations_list" ]]; then
    notify-send -i "$iDIR/error.png" "Error: No Animations" "No animation .conf files found in $animations_dir. Aborting."
    exit 1
fi

# Rofi Menu
chosen_file=$(echo "$animations_list" | rofi -i -dmenu -config "$rofi_theme" -mesg "$msg")

# Check if a file was selected
if [[ -n "$chosen_file" ]]; then
    full_path="$animations_dir/$chosen_file.conf"    
    cp "$full_path" "$UserConfigs/UserAnimations.conf" && notify-send -u low -i "$iDIR/ja.png" "$chosen_file" "Hyprland Animation Loaded" || notify-send -i "$iDIR/error.png" "Error" "Failed to copy animation file."
fi

sleep 1
"$SCRIPTSDIR/RefreshNoWaybar.sh"
