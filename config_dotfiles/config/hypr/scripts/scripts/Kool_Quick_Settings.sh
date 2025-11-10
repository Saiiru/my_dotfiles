#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Rofi menu for KooL Hyprland Quick Settings (SUPER SHIFT E)

# Modify this config file for default terminal and EDITOR
config_file="$HOME/.config/hypr/UserConfigs/01-UserDefaults.conf"

# Directory for swaync images (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "sed"
check_dependency "mktemp"
check_dependency "notify-send"
check_dependency "hyprctl" # Used by some called scripts
check_dependency "jq" # Used by some called scripts
check_dependency "nwg-displays" # Checked inline, but good to list
check_dependency "nwg-look" # Checked inline, but good to list
check_dependency "qt6ct" # Checked inline, but good to list
check_dependency "qt5ct" # Checked inline, but good to list

# Check for existence of called scripts
check_dependency "$scriptsDir/Kitty_themes.sh"
check_dependency "$scriptsDir/Animations.sh"
check_dependency "$scriptsDir/MonitorProfiles.sh"
check_dependency "$scriptsDir/RofiThemeSelector-modified.sh" # Updated reference
check_dependency "$scriptsDir/KeyBinds.sh"
check_dependency "$scriptsDir/GameMode.sh"
check_dependency "$scriptsDir/DarkLight.sh"

tmp_config_file=$(mktemp)
sed 's/^\$//g; s/ = /=/g' "$config_file" > "$tmp_config_file"
source "$tmp_config_file"
rm "$tmp_config_file" # Clean up temporary file
# ##################################### #

# variables
configs="$HOME/.config/hypr/configs"
UserConfigs="$HOME/.config/hypr/UserConfigs"
rofi_theme="$HOME/.config/rofi/config-edit.rasi"
msg=' ⁉️ Choose what to do ⁉️'
scriptsDir="$HOME/.config/hypr/scripts"
UserScripts="$HOME/.config/hypr/UserScripts"

# Validate $term and $edit
if [[ -z "$term" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration" "Default terminal (\$term) not set in $config_file. Aborting."
    exit 1
fi
if [[ -z "$edit" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Configuration" "Default editor (\$edit) not set in $config_file. Aborting."
    exit 1
fi

# Function to display the menu options without numbers
menu() {
    cat <<EOF
view/edit User Defaults
view/edit ENV variables
view/edit Window Rules
view/edit User Keybinds
view/edit User Settings
view/edit Startup Apps
view/edit Decorations
view/edit Animations
view/edit Laptop Keybinds
view/edit Default Keybinds
Choose Kitty Terminal Theme
Configure Monitors (nwg-displays)
Configure Workspace Rules (nwg-displays)
GTK Settings (nwg-look)
QT Apps Settings (qt6ct)
QT Apps Settings (qt5ct)
Choose Hyprland Animations
Choose Monitor Profiles
Choose Rofi Themes
Search for Keybinds
Toggle Game Mode
Switch Dark-Light Theme
EOF
}

# Main function to handle menu selection
main() {
    choice=$(menu | rofi -i -dmenu -config $rofi_theme -mesg "$msg")
    
    # Map choices to corresponding files
    case "$choice" in
    	"view/edit User Defaults") file="$UserConfigs/01-UserDefaults.conf" ;;
        "view/edit ENV variables") file="$UserConfigs/ENVariables.conf" ;;
        "view/edit Window Rules") file="$configs/WindowRules.conf" ;;
        "view/edit User Keybinds") file="$UserConfigs/UserKeybinds.conf" ;;
        "view/edit User Settings") file="$UserConfigs/UserSettings.conf" ;;
        "view/edit Startup Apps") file="$configs/Startup_Apps.conf" ;;
        "view/edit Decorations") file="$UserConfigs/UserDecorations.conf" ;;
        "view/edit Animations") file="$UserConfigs/UserAnimations.conf" ;;
        "view/edit Laptop Keybinds") file="$UserConfigs/Laptops.conf" ;;
        "view/edit Default Keybinds") file="$configs/Keybinds.conf" ;;
        "Choose Kitty Terminal Theme") $scriptsDir/Kitty_themes.sh ;;
        "Configure Monitors (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
        "Configure Workspace Rules (nwg-displays)") 
            if ! command -v nwg-displays &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-displays first"
                exit 1
            fi
            nwg-displays ;;
		"GTK Settings (nwg-look)") 
            if ! command -v nwg-look &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install nwg-look first"
                exit 1
            fi
            nwg-look ;;
		"QT Apps Settings (qt6ct)") 
            if ! command -v qt6ct &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install qt6ct first"
                exit 1
            fi
            qt6ct ;;
		"QT Apps Settings (qt5ct)") 
            if ! command -v qt5ct &>/dev/null; then
                notify-send -i "$iDIR/error.png" "E-R-R-O-R" "Install qt5ct first"
                exit 1
            fi
            qt5ct ;;
        "Choose Hyprland Animations") "$scriptsDir/Animations.sh" ;;
        "Choose Monitor Profiles") "$scriptsDir/MonitorProfiles.sh" ;;
        "Choose Rofi Themes") "$scriptsDir/RofiThemeSelector-modified.sh" ;;
        "Search for Keybinds") "$scriptsDir/KeyBinds.sh" ;;
        "Toggle Game Mode") "$scriptsDir/GameMode.sh" ;;
        "Switch Dark-Light Theme") "$scriptsDir/DarkLight.sh" ;;
        *) return ;;  # Do nothing for invalid choices
    esac

    # Open the selected file in the terminal with the text editor
    if [ -n "$file" ]; then
        $term -e $edit "$file"
    fi
}

# Check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

main