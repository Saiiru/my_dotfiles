#!/usr/bin/env bash
# Instala JDK/JRE e build tools mínimos em Arch
set -euo pipefail

info() { printf "\033[1;36m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }

need_sudo() { if [[ $EUID -ne 0 ]]; then sudo -v; fi; }

install_pacman() {
  local pkgs=($@)
  local missing=()
  for p in "${pkgs[@]}"; do
    pacman -Qi "$p" &>/dev/null || missing+=("$p")
  done
  if ((${#missing[@]} == 0)); then return; fi
  need_sudo
  sudo pacman -S --needed --noconfirm "${missing[@]}"
}

main() {
  if ! command -v pacman >/dev/null 2>&1; then
    warn "Somente Arch/derivados"; exit 1; fi

  # JDK e ferramentas básicas
  install_pacman jdk17-openjdk maven gradle

  info "Se preferir gerenciar via mise:"
  echo "  mise use -g java@temurin-17 maven"
}

main "$@"
