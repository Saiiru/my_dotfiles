# ZSH modular (core/options/completions/keybinds) + Bat-HUD prompt
# Sem Starship; prompt de duas linhas, sem espaços extras dentro dos colchetes.

ZSH_CONFIG_ROOT="${ZSH_CONFIG_ROOT:-$HOME/workstation/config/zsh}"

# Núcleo
[[ -r "$ZSH_CONFIG_ROOT/core/10-env.zsh" ]]         && source "$ZSH_CONFIG_ROOT/core/10-env.zsh"
[[ -r "$ZSH_CONFIG_ROOT/core/20-options.zsh" ]]      && source "$ZSH_CONFIG_ROOT/core/20-options.zsh"
[[ -r "$ZSH_CONFIG_ROOT/core/30-completions.zsh" ]]  && source "$ZSH_CONFIG_ROOT/core/30-completions.zsh"
[[ -r "$ZSH_CONFIG_ROOT/core/40-keybinds.zsh" ]]     && source "$ZSH_CONFIG_ROOT/core/40-keybinds.zsh"

# Plugins (oh-my-zsh se existir; sintaxe/auto-suggest via /usr/share)
if [[ -n "${ZSH:-}" && -r "$ZSH/oh-my-zsh.sh" ]]; then
  ZSH_THEME=""   # sem tema de oh-my-zsh
  source "$ZSH/oh-my-zsh.sh"
fi

if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  unsetopt ksharrays
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  unsetopt ksharrays
  source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

if [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
elif [[ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#999'
fi

# Aliases / funções do usuário
[[ -r "$ZSH_CONFIG_ROOT/user/aliases.zsh" ]]  && source "$ZSH_CONFIG_ROOT/user/aliases.zsh"
[[ -r "$ZSH_CONFIG_ROOT/lib/functions.zsh" ]] && source "$ZSH_CONFIG_ROOT/lib/functions.zsh"

# mise (gerencia shims de node/npm, go, java, python, etc.)
if command -v mise >/dev/null 2>&1; then
  eval "$(mise activate zsh)"
fi

# Tema / prompt Bat-HUD (duas linhas, colchetes sem espaços internos)
autoload -Uz promptinit; promptinit
[[ -r "$ZSH_CONFIG_ROOT/themes/bat-hud.zsh" ]] && source "$ZSH_CONFIG_ROOT/themes/bat-hud.zsh"

# Pyenv opcional (use mise/uv por padrão; só ativa se pyenv existir)
export PYENV_ROOT="$HOME/.pyenv"
if command -v pyenv >/dev/null 2>&1; then
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# command-not-found (se existir)
[[ -f /etc/zsh_command_not_found ]] && source /etc/zsh_command_not_found


# BAT-HUD alias
hud(){ mise run -c ~/github/workstation/.mise.toml hud "$@"; }
