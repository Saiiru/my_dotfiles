# DRAGON-VEGA · Batcave Shell · NEON-NIRI (modular v4)

export WORKSTATION_DIR="${WORKSTATION_DIR:-$HOME/workstation}"
export ZDOTDIR="$WORKSTATION_DIR/config/zsh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

# Core modules
for cfg in "$ZDOTDIR"/core/*.zsh; do
  [ -r "$cfg" ] && source "$cfg"
done

# Theme
[ -r "$ZDOTDIR/themes/penumbra-cyberpunk.zsh" ] && source "$ZDOTDIR/themes/penumbra-cyberpunk.zsh"

# Plugins
[ -r "$ZDOTDIR/plugins/plugins.zsh" ] && source "$ZDOTDIR/plugins/plugins.zsh"

# User aliases / functions
[ -r "$ZDOTDIR/user/aliases.zsh" ] && source "$ZDOTDIR/user/aliases.zsh"
[ -r "$ZDOTDIR/lib/functions.zsh" ] && source "$ZDOTDIR/lib/functions.zsh"

# Prompt / HUD
autoload -Uz promptinit; promptinit
[ -r "$ZDOTDIR/themes/bat-hud.zsh" ] && source "$ZDOTDIR/themes/bat-hud.zsh"

# mise activation
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
