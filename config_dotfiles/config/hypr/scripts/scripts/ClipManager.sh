#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Clipboard Manager. This script uses cliphist, rofi, and wl-copy.

# Variables
rofi_theme="$HOME/.config/rofi/config-clipboard.rasi"
msg='👀 **note**  CTRL DEL = cliphist del (entry)   or   ALT DEL - cliphist wipe (all)'
iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "cliphist"
check_dependency "wl-copy"
check_dependency "notify-send"
check_dependency "pidof"

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

while true; do
    result=$(
        cliphist list | rofi -i -dmenu \
            -kb-custom-1 "Control-Delete" \
            -kb-custom-2 "Alt-Delete" \
            -config "$rofi_theme" \
			-mesg "$msg" 
    )
    rofi_exit_code=$?

    case "$rofi_exit_code" in
        1) # User cancelled Rofi
            exit
            ;;
        0) # User selected an entry (Enter key)
            if [[ -n "$result" ]]; then
                cliphist decode <<<"$result" | wl-copy || notify-send -i "$iDIR/error.png" "Error" "Failed to copy to clipboard."
                notify-send -u low -i "$iDIR/ja.png" "Clipboard" "Entry copied to clipboard."
                exit
            else
                # User pressed Enter on an empty selection, or no history
                continue
            fi
            ;;
        10) # Custom keybinding 1 (Control-Delete)
            if [[ -n "$result" ]]; then
                cliphist delete <<<"$result" || notify-send -i "$iDIR/error.png" "Error" "Failed to delete clipboard entry."
                notify-send -u low -i "$iDIR/ja.png" "Clipboard" "Entry deleted."
            else
                notify-send -i "$iDIR/error.png" "Clipboard" "No entry selected to delete."
            fi
            ;;
        11) # Custom keybinding 2 (Alt-Delete)
            # Confirmation for wiping clipboard
            confirm=$(echo -e "Yes\nNo" | rofi -dmenu -i -p "Wipe all clipboard history?" -config "$rofi_theme")
            if [[ "$confirm" == "Yes" ]]; then
                cliphist wipe || notify-send -i "$iDIR/error.png" "Error" "Failed to wipe clipboard history."
                notify-send -u low -i "$iDIR/ja.png" "Clipboard" "All history wiped."
            else
                notify-send -u low -i "$iDIR/note.png" "Clipboard" "Wipe cancelled."
            fi
            ;;
        *) # Other Rofi exit codes or errors
            notify-send -i "$iDIR/error.png" "Error" "Rofi exited with code $rofi_exit_code."
            exit 1
            ;;
    esac
done
