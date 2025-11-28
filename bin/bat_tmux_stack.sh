#!/usr/bin/env bash
# Wrapper colorido para o seletor de layouts (organizado em bin/hud/)
CYAN="\033[38;5;45m"
RESET="\033[0m"
printf "${CYAN}  STACK LAYOUTS${RESET}\n"
exec "$(dirname "$0")/hud/bat_tmux_stack.sh" "$@"
