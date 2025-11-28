#!/usr/bin/env bash
# Instala toolchain Go + CLIs úteis (air, golangci-lint, gotestsum, etc.)
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

  # Go pelo pacman (mise pode sobrepor depois se quiser)
  install_pacman go

  # GOPATH default
  export GOPATH="${GOPATH:-$HOME/go}"
  export PATH="$GOPATH/bin:$PATH"

  local tools=(
    github.com/cosmtrek/air@latest
    github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    gotest.tools/gotestsum@latest
    github.com/cweill/gotests/...@latest
    honnef.co/go/tools/cmd/staticcheck@latest
    github.com/go-delve/delve/cmd/dlv@latest
    github.com/rakyll/hey@latest
  )

  info "Instalando Go tools em $GOPATH/bin"
  for t in "${tools[@]}"; do
    go install "$t"
  done

  info "Concluído. PATH sugerido:"
  echo "  export GOPATH=$GOPATH"
  echo "  export PATH=\"$GOPATH/bin:\$PATH\""
}

main "$@"
