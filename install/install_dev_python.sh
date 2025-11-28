#!/usr/bin/env bash
# Instala Python + uv + ferramentas base em Arch
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

  install_pacman python python-pip

  if ! command -v uv >/dev/null 2>&1; then
    info "Instalando uv..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
  else
    info "uv já instalado"
  fi

  info "Ferramentas opcionais globais (instale via uv tool se quiser):"
  echo "  uv tool install jupyterlab"
  echo "  uv tool install ipython"
  echo "  uv tool install ruff"
}

main "$@"
