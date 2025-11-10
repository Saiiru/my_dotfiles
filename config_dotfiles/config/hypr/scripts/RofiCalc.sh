#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */
# /* Calculator (using qalculate) and rofi */
# /* Submitted by: https://github.com/JosephArmas */

rofi_theme="$HOME/.config/rofi/config-calc.rasi"
iDIR="$HOME/.config/swaync/images" # Define iDIR for notify-send

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "qalc"
check_dependency "wl-copy"
check_dependency "notify-send"

# Kill Rofi if already running before execution
if pgrep -x "rofi" >/dev/null; then
    pkill rofi
fi

# main function
calc_result="Enter expression" # Initialize with an informative message

while true; do
    result=$(
        rofi -i -dmenu \
            -config "$rofi_theme" \
            -mesg "$calc_result"
    )

    if [ $? -ne 0 ]; then # Rofi exited (e.g., via Escape)
        exit
    fi

    if [ -n "$result" ]; then
        calc_result=$(qalc -t "$result")
        if [ $? -eq 0 ]; then # Check if qalc was successful
            echo "$calc_result" | wl-copy
            notify-send -e -u low -i "$iDIR/ja.png" "Calculation Result" "'$calc_result' copied to clipboard."
        else
            calc_result="Error: Invalid expression or qalc failed."
            notify-send -e -u critical -i "$iDIR/error.png" "Calculation Error" "$calc_result"
        fi
    fi
done
