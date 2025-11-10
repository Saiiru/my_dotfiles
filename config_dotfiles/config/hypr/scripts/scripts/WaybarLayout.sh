#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for waybar layout or configs

IFS=$'\n\t'

# Define directories
waybar_layouts="$HOME/.config/waybar/configs"
waybar_config="$HOME/.config/waybar/config"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
rofi_config="$HOME/.config/rofi/config-waybar-layout.rasi"
msg=' 🎌 NOTE: Some waybar LAYOUT NOT fully compatible with some STYLES'
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
check_dependency "pgrep"
check_dependency "pkill"

# Apply selected configuration
apply_config() {
    ln -sf "$waybar_layouts/$1" "$waybar_config" || { notify-send -i "$iDIR/error.png" "Error" "Failed to create symlink for Waybar layout."; return 1; }
    "${SCRIPTSDIR}/Refresh.sh" &
}

main() {
    # Check if waybar layouts directory exists
    if [[ ! -d "$waybar_layouts" ]]; then
        notify-send -i "$iDIR/error.png" "Error: Directory Not Found" "Waybar layouts directory not found: $waybar_layouts. Aborting."
        exit 1
    fi

    # Build sorted list of available layouts
    mapfile -t options < <(
        find -L "$waybar_layouts" -maxdepth 1 -type f -printf '%f\n' | sort
    )

    if [ ${#options[@]} -eq 0 ]; then
        notify-send -i "$iDIR/error.png" "Error: No Layouts" "No layout files found in $waybar_layouts. Aborting."
        exit 1
    fi

    # Resolve current symlink target and basename
    local current_target=$(readlink -f "$waybar_config")
    local current_name=$(basename "$current_target")

    # Mark and locate the active layout
    local default_row=0
    local MARKER="👉"
    for i in "${!options[@]}"; do
        if [[ "${options[i]}" == "$current_name" ]]; then
            options[i]="$MARKER ${options[i]}"
            default_row=$i
            break
        fi
    done

    # Launch rofi with the annotated list, pre‑selecting the active row
    local choice=$(printf '%s\n' "${options[@]}" \
        | rofi -i -dmenu \
               -config "$rofi_config" \
               -mesg "$msg" \
               -selected-row "$default_row"
    )

    # Exit if nothing chosen
    [[ -z "$choice" ]] && { notify-send -u low -i "$iDIR/note.png" "Waybar Layouts" "No option selected. Exiting."; exit 0; }

    # Strip marker before applying
    choice=${choice#"$MARKER "}

    case "$choice" in
        "no panel")
            pgrep -x "waybar" && pkill waybar || true
            notify-send -u low -i "$iDIR/ja.png" "Waybar Layout" "Waybar panel disabled."
            ;;
        *)
            apply_config "$choice" && notify-send -u low -i "$iDIR/ja.png" "Waybar Layout" "Applied: $choice"
            ;;
    esac
}

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

main
