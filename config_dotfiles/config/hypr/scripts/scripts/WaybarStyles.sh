#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for waybar styles

IFS=$'\n\t'

# Define directories
waybar_styles="$HOME/.config/waybar/style"
waybar_style="$HOME/.config/waybar/style.css"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
rofi_config="$HOME/.config/rofi/config-waybar-style.rasi"
msg=' 🎌 NOTE: Some waybar STYLES NOT fully compatible with some LAYOUTS'
iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "find"
check_dependency "ln"
check_dependency "readlink"
check_dependency "basename"
check_dependency "sort"
check_dependency "notify-send"
check_dependency "$SCRIPTSDIR/Refresh.sh"
check_dependency "pidof"
check_dependency "pkill"

# Apply selected style
apply_style() {
    ln -sf "$waybar_styles/$1.css" "$waybar_style" || { notify-send -i "$iDIR/error.png" "Error" "Failed to create symlink for Waybar style."; return 1; }
    "${SCRIPTSDIR}/Refresh.sh" &
}

main() {
    # Check if waybar styles directory exists
    if [[ ! -d "$waybar_styles" ]]; then
        notify-send -i "$iDIR/error.png" "Error: Directory Not Found" "Waybar styles directory not found: $waybar_styles. Aborting."
        exit 1
    fi

    # gather all style names (without .css) into an array
    mapfile -t options < <(
        find -L "$waybar_styles" -maxdepth 1 -type f -name '*.css' \
            -exec basename {} .css \; \
            | sort
    )

    if [ ${#options[@]} -eq 0 ]; then
        notify-send -i "$iDIR/error.png" "Error: No Styles" "No .css files found in $waybar_styles. Aborting."
        exit 1
    fi

    # resolve current symlink and strip .css
    local current_target=$(readlink -f "$waybar_style")
    local current_name=$(basename "$current_target" .css)

    # mark the active style and record its index
    local default_row=0
    local MARKER="👉"
    for i in "${!options[@]}"; do
        if [[ "${options[i]}" == "$current_name" ]]; then
            options[i]="$MARKER ${options[i]}"
            default_row=$i
            break
        fi
    done

    # launch rofi with the annotated list and pre‑selected row
    local choice=$(printf '%s\n' "${options[@]}" \
        | rofi -i -dmenu \
               -config "$rofi_config" \
               -mesg "$msg" \
               -selected-row "$default_row"
    )

    [[ -z "$choice" ]] && { notify-send -u low -i "$iDIR/note.png" "Waybar Styles" "No option selected. Exiting."; exit 0; }

    # remove annotation and apply
    choice=${choice#"$MARKER "}
    apply_style "$choice" && notify-send -u low -i "$iDIR/ja.png" "Waybar Style" "Applied: $choice"
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

main
