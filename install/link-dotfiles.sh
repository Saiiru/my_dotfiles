#!/usr/bin/env bash
set -euo pipefail

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  # backup se for arquivo regular (não symlink)
  if [[ -f "$dst" && ! -L "$dst" ]]; then
    mv "$dst" "$dst.bak-$(date +%Y%m%d-%H%M%S)"
  fi
  ln -sf "$src" "$dst"
}

# tmux
link "$HOME/workstation/config/tmux/tmux.conf" "$HOME/.config/tmux/tmux.conf"
# zsh
link "$HOME/workstation/config/zsh/.zshrc"   "$HOME/.zshrc"
link "$HOME/workstation/config/zsh/.zshenv"  "$HOME/.zshenv"
link "$HOME/workstation/config/zsh/.zprofile" "$HOME/.zprofile"

# starship (se existir)
if [[ -f "$HOME/workstation/config/starship/starship.toml" ]]; then
  link "$HOME/workstation/config/starship/starship.toml" "$HOME/.config/starship/starship.toml"
fi

# kitty (se existir)
if [[ -d "$HOME/workstation/config/kitty" ]]; then
  link "$HOME/workstation/config/kitty" "$HOME/.config/kitty"
fi

# nvim (opcional, comente se não quiser)
if [[ -d "$HOME/workstation/config/nvim" ]]; then
  link "$HOME/workstation/config/nvim" "$HOME/.config/nvim"
fi

echo "Links atualizados."
