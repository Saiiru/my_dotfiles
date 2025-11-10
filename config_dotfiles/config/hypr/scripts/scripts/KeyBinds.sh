#!/usr/bin/env bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# searchable enabled keybinds using rofi (supports bindd descriptions)

# Directory for swaync icons (for notify-send)
iDIR="$HOME/.config/swaync/images"

# --- Dependency Check ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || { notify-send -i "$iDIR/error.png" "Error: Missing Dependency" "$1 is not installed. Aborting."; exit 1; }
}

check_dependency "rofi"
check_dependency "grep"
check_dependency "sed"
check_dependency "awk"
check_dependency "pidof"
check_dependency "notify-send"

# kill yad to not interfere with this binds
pkill yad || true

# check if rofi is already running
if pidof rofi > /dev/null; then
  pkill rofi
fi

# define the config files
keybinds_conf="$HOME/.config/hypr/configs/Keybinds.conf"
user_keybinds_conf="$HOME/.config/hypr/UserConfigs/UserKeybinds.conf"
laptop_conf="$HOME/.config/hypr/UserConfigs/Laptops.conf"
rofi_theme="$HOME/.config/rofi/config-keybinds.rasi"
msg='☣️ NOTE ☣️: Clicking with Mouse or Pressing ENTER will have NO function'

# Check if core config files exist
if [[ ! -f "$keybinds_conf" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Config File" "Core keybinds config not found: $keybinds_conf. Aborting."
    exit 1
fi
if [[ ! -f "$user_keybinds_conf" ]]; then
    notify-send -i "$iDIR/error.png" "Error: Config File" "User keybinds config not found: $user_keybinds_conf. Aborting."
    exit 1
fi

# collect raw bind lines (strip end-of-line comments) from available files
files=("$keybinds_conf" "$user_keybinds_conf")
[[ -f "$laptop_conf" ]] && files+=("$laptop_conf")

raw_keybinds=$(cat "${files[@]}" 2>/dev/null \
  | grep -E '^[[:space:]]*bind' \
  | sed -E 's/[[:space:]]+#.*$//')

# check for any keybinds to display
if [[ -z "$raw_keybinds" ]]; then
    echo "no keybinds found."
    exit 1
fi

# transform into a readable list: MODS+KEY — DESCRIPTION — DISPATCHER [PARAMS]
display_keybinds=$(echo "$raw_keybinds" | awk -F'=' '
  function trim(s){ gsub(/^[ \t]+|[ \t]+$/,"",s); return s }
  /^[[:space:]]*bind/ {
    binder=$1; gsub(/[ \t]/, "", binder);
    hasdesc = (index(binder, "d")>0);

    rhs=$2; rhs=trim(rhs);
    n=split(rhs, a, /[ \t]*,[ \t]*/);

    mods=trim(a[1]); key=(n>=2?trim(a[2]):"");
    desc=""; dispatcher=""; params="";

    if (hasdesc) {
      desc=(n>=3?trim(a[3]):"");
      dispatcher=(n>=4?trim(a[4]):"");
      start=5;
    } else {
      dispatcher=(n>=3?trim(a[3]):"");
      start=4;
    }

    for(i=start;i<=n;i++){ if(length(a[i])){ p=trim(a[i]); if(p!="") params = (params?params", ":"") p } }

    gsub(/\$mainMod/,"SUPER",mods);
    gsub(/[ \t]+/,"+",mods);

    combo = (mods && key) ? mods "+" key : (key?key:mods);

    if (desc != "") {
      if (dispatcher != "" && params != "")
        print combo, " — ", desc, " — ", dispatcher, " ", params;
      else if (dispatcher != "")
        print combo, " — ", desc, " — ", dispatcher;
      else
        print combo, " — ", desc;
    } else {
      if (dispatcher != "" && params != "")
        print combo, " — ", dispatcher, " ", params;
      else if (dispatcher != "")
        print combo, " — ", dispatcher;
      else
        print combo;
    }
  }
')

# use rofi to display the keybinds
printf '%s\n' "$display_keybinds" | rofi -dmenu -i -config "$rofi_theme" -mesg "$msg"
