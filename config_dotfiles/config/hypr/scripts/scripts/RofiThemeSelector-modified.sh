#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# A modified version of Rofi-Theme-Selector, concentrating only on ~/.local and also, applying only 10 @themes in ~/.config/rofi/config.rasi
# as opposed to continous adding of //@theme

# This code is released in public domain by Dave Davenport <qball@gmpclient.org>

iDIR="$HOME/.config/swaync/images"

# --- Helper Functions ---

# Function to send a notification
notify_user() {
  notify-send -u low -i "$iDIR/ja.png" "$1" "$2"
}

# Function to check for dependencies
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify_user "Error" "$1 is not installed. Aborting."; exit 1; }
}

# --- Dependency Checks ---
check_dependency "rofi"
check_dependency "sed"
check_dependency "mktemp"
check_dependency "notify-send"
check_dependency "find"
check_dependency "grep"
check_dependency "awk" # For get_focused_monitor in WallustSwww.sh, if it were called here.

TMP_CONFIG_FILE=$(mktemp).rasi
rofi_config_file="${XDG_CONFIG_HOME:-${HOME}/.config}/rofi/config.rasi"

##
# Array with parts to the found themes.
# And array with the printable name.
##
declare -a themes
declare -a theme_names

##
# Function that tries to find all installed rofi themes.
# This fills in #themes array and formats a displayable string #theme_names
##
# Find themes in defined directories
find_themes() {
    directories=("$HOME/.local/share/rofi/themes" "$HOME/.config/rofi/themes")
    
    for TD in "${directories[@]}"; do
        if [ -d "$TD" ]; then
            for file in "$TD"/*.rasi; do
                if [ -f "$file" ] && [ ! -L "$file" ]; then
                    themes+=("$file")
                    theme_names+=("$(basename "${file%.*}")")
                fi
            done
        fi
    done
}

##
# Function to add or update theme in the config.rasi
##
add_theme_to_config() {
    local theme_name="$1"
    local theme_path

    # Determine the correct path for the theme
    if [[ -f "$HOME/.local/share/rofi/themes/$theme_name.rasi" ]]; then
        theme_path="$HOME/.local/share/rofi/themes/$theme_name.rasi"
    elif [[ -f "$HOME/.config/rofi/themes/$theme_name.rasi" ]]; then
        theme_path="$HOME/.config/rofi/themes/$theme_name.rasi"
    else
        notify_user "Error" "Theme not found: $theme_name"
        return 1
    fi

    # Resolve symlinks if present
    if [[ -L "$theme_path" ]]; then
        theme_path=$(readlink -f "$theme_path")
    fi

    # Convert path to use ~ for home directory
    theme_path_with_tilde="~${theme_path#$HOME}"

    # Comment out any existing @theme entry
    sed -i "s/^\(\s*@theme.*\)/\/\/\1/" "$rofi_config_file"

    # Add the new @theme entry at the end of the file
    echo -e "@theme \"$theme_path_with_tilde\"" >> "$rofi_config_file"

    # Limit the number of @theme lines to a maximum of 9 (including the active one)
    local max_lines=9
    local total_commented_lines=$(grep -c '^\s*//@theme' "$rofi_config_file")

    if [ "$total_commented_lines" -gt "$max_lines" ]; then
        local excess=$((total_commented_lines - max_lines))
        for ((i = 1; i <= excess; i++)); do
            # Delete the first commented out @theme line
            sed -i '0,/^\s*\/\/@theme/ { /^\s*\/\/@theme/d; }' "$rofi_config_file"
        done
    fi
}

##
# Create a copy of rofi config
##
create_config_copy()
{
    rofi -dump-config > "${TMP_CONFIG_FILE}"
    # remove theme entry.
    sed -i 's/^\s*theme:\s\+".*"\s*;//g' "${TMP_CONFIG_FILE}"
}

###
# Print the list out so it can be displayed by rofi.
##
create_theme_list()
{
    OLDIFS=${IFS}
    IFS='|'
    for themen in "${theme_names[@]}"
    do
        echo "${themen}"
    done
    IFS=${OLDIFS}
}

##
# Thee indicate what entry is selected.
##
declare -i SELECTED

select_theme()
{
    local MORE_FLAGS=(-dmenu -format i -no-custom -p "Theme" -markup -config "${TMP_CONFIG_FILE}" -i)
    MORE_FLAGS+=(-kb-custom-1 "Alt-a")
    MORE_FLAGS+=(-u 2,3 -a 4,5 )
    local CUR="default"
    while true
    do
        declare -i RTR
        declare -i RES
        local MESG="""You can preview themes by hitting <b>Enter</b>.
<b>Alt-a</b> to accept the new theme.
<b>Escape</b> to cancel
Current theme: <b>${CUR}</b>
<span weight=\"bold\" size=\"xx-small\">When setting a new theme this will override previous theme settings.
Please update your config file if you have local modifications.</span>"""
        THEME_FLAG=
        if [ -n "${SELECTED}" ]
        then
            THEME_FLAG="-theme ${themes[${SELECTED}]}"
        fi
        RES=$( create_theme_list | rofi ${THEME_FLAG} "${MORE_FLAGS[@]}" -cycle -selected-row "${SELECTED}" -mesg "${MESG}")
        RTR=$?
        if [ "${RTR}" = 10 ]
        then
            return 0;
        elif [ "${RTR}" = 1 ]
        then
            return 1;
        elif [ "${RTR}" = 65 ]
        then
            return 1;
        fi
        CUR=${theme_names[${RES}]}
        SELECTED=${RES}
    done
}

############################################################################################################
# Actual program execution
###########################################################################################################
##
# Find all themes
##
find_themes

##
# Do check if there are themes.
##
if [ ${#themes[@]} = 0 ]
then
    notify_user "No Themes Found" "No Rofi themes (.rasi files) were found in the configured directories."
    exit 0
fi

##
# Create copy of config to play with in preview
##
create_config_copy

##
# Show the themes to user.
##
if select_theme && [ -n "${SELECTED}" ]
then
    # Apply the selected theme
    add_theme_to_config "${theme_names[${SELECTED}]}"

    # Send notification with the selected theme name
    selection="${theme_names[${SELECTED}]}"
    notify_user "Rofi Theme Applied" "$selection"
fi

##
# Remove temp. config.
##
rm -- "${TMP_CONFIG_FILE}"
