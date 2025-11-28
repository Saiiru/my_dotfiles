#!/usr/bin/env bash
# Wrapper colorido: mantém compatibilidade com tmux e chama o HUD organizado em bin/hud/
RED="\033[38;5;196m"
CYAN="\033[38;5;51m"
RESET="\033[0m"

printf "${RED}🦇  BAT-HUD LAUNCHER${RESET}\n"
exec "$(dirname "$0")/hud/bat_hud.sh" "$@"
