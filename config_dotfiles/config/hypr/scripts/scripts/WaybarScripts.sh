#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  #
# This file used on waybar modules sourcing defaults set in $HOME/.config/hypr/UserConfigs/01-UserDefaults.conf

# Define the path to the config file
config_file=$HOME/.config/hypr/UserConfigs/01-UserDefaults.conf
iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

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
if [[ -z "$term" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration Variable" "\$term is not set in $config_file. Aborting."
    exit 1
fi

# Check if $files is set correctly
if [[ -z "$files" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration Variable" "\$files is not set in $config_file. Aborting."
    exit 1
fi

# Execute accordingly based on the passed argument
if [[ "$1" == "--btop" ]]; then
    check_dependency "btop"
    "$term" --title btop sh -c 'btop'
elif [[ "$1" == "--nvtop" ]]; then
    check_dependency "nvtop"
    "$term" --title nvtop sh -c 'nvtop'
elif [[ "$1" == "--nmtui" ]]; then
    check_dependency "nmtui"
    "$term" nmtui
elif [[ "$1" == "--term" ]]; then
    "$term" &
elif [[ "$1" == "--files" ]]; then
    "$files" &
else
    notify-send -i "$iDIR/error.png" "Usage Error" "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
    echo "Usage: $0 [--btop | --nvtop | --nmtui | --term | --files]"
    echo "--btop       : Open btop in a new term"
    echo "--nvtop      : Open nvtop in a new term"
    echo "--nmtui      : Open nmtui in a new term"
    echo "--term   : Launch a term window"
    echo "--files  : Launch a file manager"
fi