#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Searching via web browsers

# Define the path to the config file
config_file=$HOME/.config/hypr/UserConfigs/01-UserDefaults.conf

# Directory for swaync icons (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "xdg-open"
check_dependency "sed"
check_dependency "notify-send"

# Check if the config file exists
if [[ ! -f "$config_file" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration File" "Configuration file not found: $config_file. Aborting."
    exit 1
fi

# Process the config file in memory, removing the $ and fixing spaces
config_content=$(sed 's/\$//g' "$config_file" | sed 's/ = /=/')

# Source the modified content directly from the variable
eval "$config_content"

# Check if $term is set correctly
if [[ -z "$Search_Engine" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration Variable" "\$Search_Engine is not set in $config_file. Aborting."
    exit 1
fi

# Rofi theme and message
rofi_theme="$HOME/.config/rofi/config-search.rasi"
msg='‼️ **note** ‼️ search via default web browser'

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# Open Rofi and pass the selected query to xdg-open for Google search
query=$(echo "" | rofi -dmenu -config "$rofi_theme" -mesg "$msg")

if [[ -n "$query" ]]; then
    xdg-open "$Search_Engine$query" || notify-send -i "$iDIR/error.png" "Error: Web Browser" "Failed to open search query in web browser."
fi