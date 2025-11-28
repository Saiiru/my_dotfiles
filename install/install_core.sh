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
    tmux zsh neovim starship atuin zsh-syntax-highlighting

  install_pacman "Navegação/Produtividade" \
    fzf gum zoxide eza yazi fd ripgrep bat direnv tldr

  install_pacman "Git/Docker/Processos" \
    lazygit lazydocker k9s btop

  # mprocs não está no repo oficial em algumas installs; tenta via paru/yay se disponível
  if ! pacman -Qi mprocs >/dev/null 2>&1; then
    if command -v paru >/dev/null 2>&1; then
      info "Tentando instalar mprocs via paru"
      paru -S --needed --noconfirm mprocs || warn "mprocs não instalado (paru falhou)"
    elif command -v yay >/dev/null 2>&1; then
      info "Tentando instalar mprocs via yay"
      yay -S --needed --noconfirm mprocs || warn "mprocs não instalado (yay falhou)"
    else
      warn "mprocs não encontrado no pacman; instale via AUR (paru/yay) se precisar."
    fi
  else
    info "mprocs já instalado"
  fi

  install_pacman "Utilitários" \
    dua-cli dust hyperfine glow jq jless sd procs curlie

  # Pacotes opcionais/AUR (tenta paru/yay se existir; não falha se não achar)
  opt_aur=(mprocs timg gojq)
  for pkg in "${opt_aur[@]}"; do
    if pacman -Qi "$pkg" >/dev/null 2>&1; then
      info "$pkg já instalado"
      continue
    fi
    if command -v paru >/dev/null 2>&1; then
      info "Tentando instalar $pkg via paru"
      paru -S --needed --noconfirm "$pkg" || warn "$pkg não instalado (paru falhou)"
    elif command -v yay >/dev/null 2>&1; then
      info "Tentando instalar $pkg via yay"
      yay -S --needed --noconfirm "$pkg" || warn "$pkg não instalado (yay falhou)"
    else
      warn "$pkg não encontrado no pacman; instale via AUR (paru/yay) se precisar."
    fi
  done

  # oh-my-zsh (clone direto, já que no Arch não vem no pacman oficial)
  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    info "Instalando oh-my-zsh (clone)..."
    git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
  else
    info "oh-my-zsh já presente em $HOME/.oh-my-zsh"
  fi

  info "Done. Ative no zsh (se ainda não):"
  echo '  eval "$(zoxide init zsh)"'
  echo '  eval "$(direnv hook zsh)"'
  echo '  command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"'
}

main "$@"
