#!/usr/bin/env bash
set -euo pipefail

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RED='\033[1;31m'
NC='\033[0m'

info(){ printf "${CYAN}[INFO]${NC} %s\n" "$*"; }
success(){ printf "${GREEN}[ OK ]${NC} %s\n" "$*"; }
warn(){ printf "${YELLOW}[WARN]${NC} %s\n" "$*"; }
fatal(){ printf "${RED}[FAIL]${NC} %s\n" "$*" >&2; exit 1; }

ROOT="${WORKSTATION_DIR:-$HOME/workstation}"
[[ -d "$ROOT" ]] || fatal "Workstation directory not found: $ROOT"
UPSTREAM="$ROOT/niriconf"
TARGET="$ROOT/config/niri"
REPO_URL="https://github.com/shell-ninja/niriconf.git"

if [[ -d "$UPSTREAM/.git" ]]; then
    info "Updating niriconf repository"
    git -C "$UPSTREAM" pull --ff-only >/dev/null
else
    info "Cloning niriconf repository"
    git clone "$REPO_URL" "$UPSTREAM" >/dev/null
fi

info "Syncing config/niri with upstream dotfiles"
rm -rf "$TARGET"
mkdir -p "$TARGET"
rsync -a "$UPSTREAM/dotfiles/config/niri/" "$TARGET/"
success "Copied niriconf niri config"

export TARGET_DIR="$TARGET"
python3 <<'PY'
from pathlib import Path
import os
root = Path(os.environ["TARGET_DIR"])
config = root / "config.kdl"
text = config.read_text()

def replace_once(old, new):
    global text
    if old in text:
        text = text.replace(old, new, 1)

replace_once('layout "us"', 'layout "br"')
replace_once('gaps 20', 'gaps 12')
replace_once('default-column-width { proportion 0.5; }', 'default-column-width { proportion 0.55; }')
replace_once('background-color "transparent"', 'background-color "#0d0d16f5"')

old_preset = """    preset-column-widths {
        proportion 0.33333
        proportion 0.5
        proportion 0.66667
        proportion 1.0
    }
"""
new_preset = """    preset-column-widths {
        proportion 0.40
        proportion 0.55
        proportion 0.70
        proportion 1.00
    }
"""
if old_preset in text:
    text = text.replace(old_preset, new_preset, 1)

hook = '    Mod+Shift+l          { set-column-width "+10%"; }\n    Mod+Shift+k'
insert = '    Mod+Shift+l          { set-column-width "+10%"; }\n    Mod+R                { switch-preset-column-width; }\n    Mod+Shift+R          { switch-preset-window-height; }\n    Mod+Shift+k'
if 'switch-preset-column-width' not in text and hook in text:
    text = text.replace(hook, insert, 1)

lines = []
for line in text.splitlines():
    stripped = line.strip()
    if 'spawn-at-startup "waybar"' in stripped and not stripped.startswith('//'):
        line = '// ' + line
    if 'spawn-at-startup "swaync"' in stripped and not stripped.startswith('//'):
        line = '// ' + line
    lines.append(line)

config.write_text("\n".join(lines) + "\n")
PY
success "Applied workstation tweaks (layout, bindings)"

info "Refreshing symlinks"
"$ROOT/scripts/create-symlinks.sh"

if command -v niri >/dev/null 2>&1; then
    if niri validate >/dev/null 2>&1; then
        success "niri validate passed"
    else
        warn "niri validate reported errors; run 'niri validate' for details"
    fi
fi

success "niriconf sync complete"
