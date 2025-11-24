# DRAGON-VEGA · Batcave Shell · NEON-NIRI

export WORKSTATION_DIR="${WORKSTATION_DIR:-$HOME/workstation}"
export ZDOTDIR="$WORKSTATION_DIR/config/zsh"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"

for cfg in "$ZDOTDIR"/config.d/*.zsh; do
  [ -r "$cfg" ] && source "$cfg"
done

[ -r "$ZDOTDIR/theme/penumbra-cyberpunk.zsh" ] && source "$ZDOTDIR/theme/penumbra-cyberpunk.zsh"
[ -r "$ZDOTDIR/plugins.zsh" ] && source "$ZDOTDIR/plugins.zsh"
[ -r "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"
[ -r "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"
[ -r "$ZDOTDIR/prompt/bat_hud.zsh" ] && source "$ZDOTDIR/prompt/bat_hud.zsh"

if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi
