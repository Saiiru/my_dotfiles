# =====================================================================
# .zshrc — KORA NEON CYBERPUNK EDITION
# =====================================================================

[[ -o interactive ]] || return

# ZDOTDIR config
export ZDOTDIR="$HOME/dotfiles/zsh"

# XDG Base Directory
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# History
export HISTFILE="${XDG_STATE_HOME}/zsh/history"
export HISTSIZE=100000
export SAVEHIST=100000
mkdir -p "$(dirname "$HISTFILE")"

setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE
setopt PROMPT_SUBST NO_BEEP AUTO_CD AUTO_PUSHD PUSHD_IGNORE_DUPS
setopt INTERACTIVE_COMMENTS

# Keybinds (emacs mode enhanced)
bindkey -e
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char

# Completion with cache
autoload -Uz compinit
_compdump="${XDG_CACHE_HOME}/zsh/.zcompdump-${HOST}-${ZSH_VERSION}"
mkdir -p "${XDG_CACHE_HOME}/zsh"
if [[ -s "$_compdump" && "$_compdump" -nt "$HOME/.zshrc" ]]; then
  compinit -C -d "$_compdump"
else
  compinit -d "$_compdump"
fi
unset _compdump

# Load modular configs
[[ -f "$ZDOTDIR/env.zsh" ]] && source "$ZDOTDIR/env.zsh"
[[ -f "$ZDOTDIR/plugins.zsh" ]] && source "$ZDOTDIR/plugins.zsh"
[[ -f "$ZDOTDIR/completion.zsh" ]] && source "$ZDOTDIR/completion.zsh"
[[ -f "$ZDOTDIR/fzf.zsh" ]] && source "$ZDOTDIR/fzf.zsh"

# Load all aliases
for f in "$ZDOTDIR/aliases/"*.zsh(N); do
  source "$f"
done

# Oh-My-Posh KORA Neon theme
[[ -f "$ZDOTDIR/prompt/posh-init.zsh" ]] && source "$ZDOTDIR/prompt/posh-init.zsh"

# Integrations
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"
command -v mise >/dev/null && eval "$(mise activate zsh)"

# pnpm (if exists)
export PNPM_HOME="$HOME/.local/share/pnpm"
[[ ":$PATH:" != *":$PNPM_HOME:"* ]] && export PATH="$PNPM_HOME:$PATH"