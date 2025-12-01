#!/usr/bin/env bash
# Wrapper colorido: resolve symlink e chama o HUD real em bin/hud/
set -euo pipefail

RED="\033[38;5;196m"
CYAN="\033[38;5;51m"
RESET="\033[0m"

printf "${RED}🦇  BAT-HUD LAUNCHER${RESET}\n"

# Resolve caminho real do script (caso esteja em ~/.local/bin via symlink)
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do
  DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE"
done
DIR="$(cd -P "$(dirname "$SOURCE")" && pwd)"

exec "$DIR/hud/bat_hud.sh" "$@"
