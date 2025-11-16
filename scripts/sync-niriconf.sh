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

python3 <<PY
from pathlib import Path
root = Path("$TARGET")
config = root / "config.kdl"
text = config.read_text()
text = text.replace('layout "us"', 'layout "br"')
lines = []
for line in text.splitlines():
    if 'spawn-at-startup "waybar"' in line:
        line = '// ' + line
    if 'spawn-at-startup "swaync"' in line:
        line = '// ' + line
    lines.append(line)
config.write_text("\n".join(lines) + "\n")
PY
success "Applied workstation tweaks (layout=br, Waybar/Swaync disabled)"

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
