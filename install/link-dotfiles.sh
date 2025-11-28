#!/usr/bin/env bash
set -euo pipefail

link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
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

# starship
link "$HOME/workstation/config/starship" "$HOME/.config/starship"

# atuin
link "$HOME/workstation/config/atuin" "$HOME/.config/atuin"

# kitty
link "$HOME/workstation/config/kitty" "$HOME/.config/kitty"

# alacritty
link "$HOME/workstation/config/alacritty" "$HOME/.config/alacritty"

# ghostty
link "$HOME/workstation/config/ghostty" "$HOME/.config/ghostty"

# mpd
link "$HOME/workstation/config/mpd" "$HOME/.config/mpd"

# rmpc
link "$HOME/workstation/config/rmpc" "$HOME/.config/rmpc"

# sketchybar (se usar)
link "$HOME/workstation/config/sketchybar" "$HOME/.config/sketchybar"

# wezterm
link "$HOME/workstation/config/wezterm" "$HOME/.config/wezterm"

# zed
link "$HOME/workstation/config/zed" "$HOME/.config/zed"

# mise global config
if [[ -f "$HOME/workstation/mise/global.mise.toml" ]]; then
  link "$HOME/workstation/mise/global.mise.toml" "$HOME/.config/mise/config.toml"
elif [[ -f "$HOME/workstation/config/mise/mise.toml" ]]; then
  # fallback para mise.toml no repo de config
  link "$HOME/workstation/config/mise/mise.toml" "$HOME/.config/mise/config.toml"
fi

# nvim (opcional)
if [[ -d "$HOME/workstation/config/nvim" ]]; then
  link "$HOME/workstation/config/nvim" "$HOME/.config/nvim"
fi

echo "Links atualizados."
