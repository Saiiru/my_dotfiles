#!/usr/bin/env bash
# Instala base de CLI e tooling para Arch/derivados (pacman)
set -euo pipefail

info() { printf "\033[1;36m[INFO]\033[0m %s\n" "$*"; }
warn() { printf "\033[1;33m[WARN]\033[0m %s\n" "$*"; }

need_sudo() {
  if [[ $EUID -ne 0 ]]; then
    sudo -v
  fi
}

install_pacman() {
  local label="$1"; shift
  local pkgs=($@)
  local missing=()
  for p in "${pkgs[@]}"; do
    pacman -Qi "$p" &>/dev/null || missing+=("$p")
  done
  if ((${#missing[@]} == 0)); then
    info "$label: nada a instalar"
    return
  fi
  info "$label: instalando ${missing[*]}"
  need_sudo
  sudo pacman -S --needed --noconfirm "${missing[@]}"
}

main() {
  if ! command -v pacman >/dev/null 2>&1; then
    warn "Este instalador é para Arch/derivados (pacman)."
    exit 1
  fi

  install_pacman "Núcleo" \
    base-devel git curl wget

  install_pacman "Shell/Terminal" \
    tmux zsh neovim

  install_pacman "Navegação/Produtividade" \
    fzf gum zoxide eza yazi fd ripgrep bat direnv tldr

  install_pacman "Git/Docker/Processos" \
    lazygit lazydocker k9s btop mprocs

  install_pacman "Utilitários" \
    dua-cli dust hyperfine timg glow jq gojq jless sd procs curlie

  info "Done. Ative no zsh (se ainda não):"
  echo '  eval "$(zoxide init zsh)"'
  echo '  eval "$(direnv hook zsh)"'
}

main "$@"
