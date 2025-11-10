#!/usr/bin/env bash
## /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For Dark and Light switching
# Note: Scripts are looking for keywords Light or Dark except for wallpapers as the are in a separate directories

# Paths
wallpaper_base_path="$HOME/Pictures/wallpapers/Dynamic-Wallpapers"
dark_wallpapers="$wallpaper_base_path/Dark"
light_wallpapers="$wallpaper_base_path/Light"
hypr_config_path="$HOME/.config/hypr"
swaync_style="$HOME/.config/swaync/style.css"
SCRIPTSDIR="$HOME/.config/hypr/scripts"
notif="$HOME/.config/swaync/images/bell.png"
wallust_rofi="$HOME/.config/rofi/wallust/colors-rofi.rasi"

kitty_conf="$HOME/.config/kitty/kitty.conf"

wallust_config="$HOME/.config/wallust/wallust.toml"
pallete_dark="dark16"
pallete_light="light16"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

# Define iDIR for notify-send - using images directory for consistency
iDIR="$HOME/.config/swaync/images"

check_dependency "hyprctl"
check_dependency "swww"
check_dependency "wallust"
check_dependency "sed"
check_dependency "find"
check_dependency "shuf"
check_dependency "xargs"
check_dependency "gsettings"
check_dependency "notify-send"
check_dependency "pidof"
check_dependency "kvantummanager" # Added check for kvantummanager
check_dependency "$SCRIPTSDIR/Refresh.sh"
check_dependency "$SCRIPTSDIR/WallustSwww.sh"


# intial kill process
for pid in waybar rofi swaync swaybg; do # Removed ags
    killall -SIGUSR1 "$pid" || true
done


# Initialize swww if needed
swww query || swww-daemon --format xrgb

# Set swww options
swww="swww img"
effect="--transition-bezier .43,1.19,1,.4 --transition-fps 60 --transition-type grow --transition-pos 0.925,0.977 --transition-duration 2"

# Determine current theme mode
if [ "$(cat "$HOME/.cache/.theme_mode" 2>/dev/null)" = "Light" ]; then
    next_mode="Dark"
else
    next_mode="Light"
fi

# Function to update theme mode for the next cycle
update_theme_mode() {
    echo "$next_mode" > "$HOME/.cache/.theme_mode"
}

# Function to notify user
notify_user() {
    notify-send -u low -i "$notif" " Switching to" " $1 mode"
}

# Use sed to replace the palette setting in the wallust config file
if [ "$next_mode" = "Dark" ]; then
    sed -i 's/^palette = .*/palette = "'"$pallete_dark"'"/' "$wallust_config" 
else
    sed -i 's/^palette = .*/palette = "'"$pallete_light"'"/' "$wallust_config" 
fi

# Function to set Waybar style
set_waybar_style() {
    theme="$1"
    waybar_styles="$HOME/.config/waybar/style"
    waybar_style_link="$HOME/.config/waybar/style.css"
    style_prefix="\\[${theme}\\].*\\.css$"

    style_file=$(find -L "$waybar_styles" -maxdepth 1 -type f -regex ".*$style_prefix" | shuf -n 1)

    if [ -n "$style_file" ]; then
        ln -sf "$style_file" "$waybar_style_link"
    else
        echo "Style file not found for $theme theme." >&2
    fi
}

# Call the function after determining the mode
set_waybar_style "$next_mode"
notify_user "$next_mode"


# swaync color change
if [ "$next_mode" = "Dark" ]; then
    sed -i '/@define-color noti-bg/s/rgba([0-9]*,\s*[0-9]*,\s*[0-9]*,\s*[0-9.]*);/rgba(0, 0, 0, 0.8);/' "${swaync_style}"
	#sed -i '/@define-color noti-bg-alt/s/#.*;/#111111;/' "${swaync_style}"
else
    sed -i '/@define-color noti-bg/s/rgba([0-9]*,\s*[0-9]*,\s*[0-9]*,\s*[0-9.]*);/rgba(255, 255, 255, 0.9);/' "${swaync_style}"
	#sed -i '/@define-color noti-bg-alt/s/#.*;/#F0F0F0;/' "${swaync_style}"
fi

# kitty background color change
if [ "$next_mode" = "Dark" ]; then
    sed -i '/^foreground /s/^foreground .*/foreground #dddddd/' "${kitty_conf}"
	sed -i '/^background /s/^background .*/background #000000/' "${kitty_conf}"
	sed -i '/^cursor /s/^cursor .*/cursor #dddddd/' "${kitty_conf}"
else
	sed -i '/^foreground /s/^foreground .*/foreground #000000/' "${kitty_conf}"
	sed -i '/^background /s/^background .*/background #dddddd/' "${kitty_conf}"
	sed -i '/^cursor /s/^cursor .*/cursor #000000/' "${kitty_conf}"
fi

for pid_kitty in $(pidof kitty); do
    kill -SIGUSR1 "$pid_kitty" || true
done


# Set Dynamic Wallpaper for Dark or Light Mode
current_wallpaper_list=()
if [ "$next_mode" = "Dark" ]; then
    if [[ -d "$dark_wallpapers" ]]; then
        mapfile -t current_wallpaper_list < <(find -L "${dark_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)
    fi
else
    if [[ -d "$light_wallpapers" ]]; then
        mapfile -t current_wallpaper_list < <(find -L "${light_wallpapers}" -type f \( -iname "*.jpg" -o -iname "*.png" \) -print0 | shuf -n1 -z | xargs -0)
    fi
fi

if [ ${#current_wallpaper_list[@]} -eq 0 ]; then
    notify-send -i "$iDIR/error.png" "Error" "No wallpapers found for $next_mode mode. Using default."
    # Fallback to a default if no wallpapers are found, or exit if critical
    # For now, allowing to continue without setting a wallpaper, wallust will use current
else
    next_wallpaper="${current_wallpaper_list[0]}"
    $swww "$next_wallpaper" $effect
fi


# Set Kvantum Manager theme & QT5/QT6 settings
qt5ct_colors_dark="$HOME/.config/qt5ct/colors/Catppuccin-Mocha.conf"
qt5ct_colors_light="$HOME/.config/qt5ct/colors/Catppuccin-Latte.conf"
qt6ct_colors_dark="$HOME/.config/qt6ct/colors/Catppuccin-Mocha.conf"
qt6ct_colors_light="$HOME/.config/qt6ct/colors/Catppuccin-Latte.conf"

if [ "$next_mode" = "Dark" ]; then
    kvantum_theme="catppuccin-mocha-blue"
    qt5ct_color_scheme="$qt5ct_colors_dark"
    qt6ct_color_scheme="$qt6ct_colors_dark"
else
    kvantum_theme="catppuccin-latte-blue"
    qt5ct_color_scheme="$qt5ct_colors_light"
    qt6ct_color_scheme="$qt6ct_colors_light"
fi

if [[ -f "$HOME/.config/qt5ct/qt5ct.conf" ]]; then
    sed -i "s|^color_scheme_path=.*$|color_scheme_path=$qt5ct_color_scheme|" "$HOME/.config/qt5ct/qt5ct.conf"
fi
if [[ -f "$HOME/.config/qt6ct/qt6ct.conf" ]]; then
    sed -i "s|^color_scheme_path=.*$|color_scheme_path=$qt6ct_color_scheme|" "$HOME/.config/qt6ct/qt6ct.conf"
fi
kvantummanager --set "$kvantum_theme" || echo "Warning: kvantummanager failed or not found." >&2


# set the rofi color for background
if [ "$next_mode" = "Dark" ]; then
    sed -i '/^background:/s/.*/background: rgba(0,0,0,0.7);/' "$wallust_rofi"
else
    sed -i '/^background:/s/.*/background: rgba(255,255,255,0.9);/' "$wallust_rofi"
fi


# GTK themes and icons switching
set_custom_gtk_theme() {
    mode=$1
    gtk_themes_directory="$HOME/.themes"
    icon_directory="$HOME/.icons"
    color_setting="org.gnome.desktop.interface color-scheme"
    theme_setting="org.gnome.desktop.interface gtk-theme"
    icon_setting="org.gnome.desktop.interface icon-theme"

    if [ "$mode" == "Light" ]; then
        search_keywords="*Light*"
        gsettings set "$color_setting" "'prefer-light'"
    elif [ "$mode" == "Dark" ]; then
        search_keywords="*Dark*"
        gsettings set "$color_setting" "'prefer-dark'"
    else
        echo "Invalid mode provided." >&2
        return 1
    fi

    themes=()
    icons=()

    if [[ -d "$gtk_themes_directory" ]]; then
        while IFS= read -r -d '' theme_search; do
            themes+=("$(basename "$theme_search")")
        done < <(find "$gtk_themes_directory" -maxdepth 1 -type d -iname "$search_keywords" -print0)
    fi

    if [[ -d "$icon_directory" ]]; then
        while IFS= read -r -d '' icon_search; do
            icons+=("$(basename "$icon_search")")
        done < <(find "$icon_directory" -maxdepth 1 -type d -iname "$search_keywords" -print0)
    fi

    if [ ${#themes[@]} -gt 0 ]; then
        selected_theme=${themes[RANDOM % ${#themes[@]}]}
        echo "Selected GTK theme for $mode mode: $selected_theme" >&2
        gsettings set "$theme_setting" "$selected_theme" || echo "Warning: gsettings for GTK theme failed." >&2

        # Flatpak GTK apps (themes)
        if command -v flatpak &> /dev/null; then
            flatpak --user override --filesystem=$HOME/.themes || echo "Warning: flatpak override --filesystem for themes failed." >&2
            sleep 0.5
            flatpak --user override --env=GTK_THEME="$selected_theme" || echo "Warning: flatpak override --env GTK_THEME failed." >&2
        fi
    else
        echo "No $mode GTK theme found" >&2
    fi

    if [ ${#icons[@]} -gt 0 ]; then
        selected_icon=${icons[RANDOM % ${#icons[@]}]}
        echo "Selected icon theme for $mode mode: $selected_icon" >&2
        gsettings set "$icon_setting" "$selected_icon" || echo "Warning: gsettings for icon theme failed." >&2
        
        ## QT5ct icon_theme
        if [[ -f "$HOME/.config/qt5ct/qt5ct.conf" ]]; then
            sed -i "s|^icon_theme=.*$|icon_theme=$selected_icon|" "$HOME/.config/qt5ct/qt5ct.conf" || echo "Warning: sed for qt5ct icon_theme failed." >&2
        fi
        if [[ -f "$HOME/.config/qt6ct/qt6ct.conf" ]]; then
            sed -i "s|^icon_theme=.*$|icon_theme=$selected_icon|" "$HOME/.config/qt6ct/qt6ct.conf" || echo "Warning: sed for qt6ct icon_theme failed." >&2
        fi

        # Flatpak GTK apps (icons)
        if command -v flatpak &> /dev/null; then
            flatpak --user override --filesystem=$HOME/.icons || echo "Warning: flatpak override --filesystem for icons failed." >&2
            sleep 0.5
            flatpak --user override --env=ICON_THEME="$selected_icon" || echo "Warning: flatpak override --env ICON_THEME failed." >&2
        fi
    else
        echo "No $mode icon theme found" >&2
    fi
}

# Call the function to set GTK theme and icon theme based on mode
set_custom_gtk_theme "$next_mode"

# Update theme mode for the next cycle
update_theme_mode


"${SCRIPTSDIR}/WallustSwww.sh" &&

sleep 2
# kill process
for pid1 in waybar rofi swaync swaybg; do # Removed ags
    killall "$pid1" || true
done

sleep 1
"${SCRIPTSDIR}/Refresh.sh" 

sleep 0.5
# Display notifications for theme and icon changes 
notify-send -u low -i "$notif" " Themes switched to:" " $next_mode Mode"

exit 0

