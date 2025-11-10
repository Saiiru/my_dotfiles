#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For manually starting xdg-desktop-portal-hyprland

iDIR="$HOME/.config/swaync/images" # For notify-send icons

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "killall"
check_dependency "notify-send"

# List of potential xdg-desktop-portal-hyprland paths
xdp_hyprland_paths=(
    "/usr/lib/xdg-desktop-portal-hyprland"
    "/usr/libexec/xdg-desktop-portal-hyprland"
)

# List of potential xdg-desktop-portal paths
xdp_generic_paths=(
    "/usr/lib/xdg-desktop-portal"
    "/usr/libexec/xdg-desktop-portal"
)

# Function to find and start a portal
start_portal() {
    local portal_name="$1"
    local portal_paths=("${!2}") # Indirect expansion for array
    local started=false

    for path in "${portal_paths[@]}"; do
        if [[ -x "$path" ]]; then
            "$path" &
            if [ $? -eq 0 ]; then
                notify-send -u low -i "$iDIR/ja.png" "XDG Portals" "Started $portal_name from $path."
                started=true
                break
            else
                notify-send -i "$iDIR/error.png" "Error: XDG Portal" "Failed to start $portal_name from $path."
            fi
        fi
    done

    if ! "$started"; then
        notify-send -i "$iDIR/error.png" "Error: XDG Portal" "No executable found or failed to start $portal_name."
        exit 1
    fi
}

sleep 1
# Kill existing portal processes
killall xdg-desktop-portal-hyprland || true
killall xdg-desktop-portal-wlr || true
killall xdg-desktop-portal-gnome || true
killall xdg-desktop-portal || true
sleep 1

# Start xdg-desktop-portal-hyprland
start_portal "xdg-desktop-portal-hyprland" "xdp_hyprland_paths[@]"

sleep 2

# Start xdg-desktop-portal
start_portal "xdg-desktop-portal" "xdp_generic_paths[@]"

notify-send -u low -i "$iDIR/ja.png" "XDG Portals" "All Hyprland portals initialized."
