# ── sane defaults ───────────────────────────────────────────────────────────────
emulate -L zsh
unsetopt extendedglob bareglobqual kshglob
setopt no_beep interactivecomments no_nomatch
setopt autocd
# História
HISTSIZE=200000
SAVEHIST=200000
setopt hist_ignore_dups hist_ignore_space hist_verify
setopt append_history inc_append_history
unsetopt share_history

# Term
export TERM="xterm-256color"
export GROFF_NO_SGR=1
KEYTIMEOUT=1
bindkey -v
autoload -Uz edit-command-line; zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey  "^[[H"   beginning-of-line
bindkey  "^[[F"   end-of-line
bindkey  "^[[3~"  delete-char

# ── Funções AUR Helper (DEFINIDAS ANTES DOS ALIASES) ──────────────────────────
AURHELPER=${AURHELPER:-paru}
un(){ "$AURHELPER" -Rns "$@"; }
up(){ "$AURHELPER" -Syu "$@"; }
pl(){ "$AURHELPER" -Qs "$@"; }
pa(){ "$AURHELPER" -Ss "$@"; }
pc(){ "$AURHELPER" -Sc "$@"; }
po(){ set -o pipefail; "$AURHELPER" -Qtdq | "$AURHELPER" -Rns -; }

# ── Aliases essenciais ─────────────────────────────────────────────────────────
[ -r "$HOME/.alias" ] && source "$HOME/.alias"
alias c='clear'
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias vc='code'
alias fastfetch='fastfetch --logo-type kitty'
alias ..='cd ..'; alias ...='cd ../..'; alias .3='cd ../../..'; alias .4='cd ../../../..'; alias .5='cd ../../../../..'
alias mkdir='mkdir -p'

# FZF defaults
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border --info=inline'

# ── completion (compdump no HOME) ──────────────────────────────────────────
typeset -g ZCOMPDUMP="$HOME/.zcompdump-${HOST}-${ZSH_VERSION}"
zmodload zsh/complist
fpath=("$ZDOTDIR/completions" $fpath)
autoload -Uz compinit
compinit -d "$ZCOMPDUMP" -i

# Estilos de completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*:descriptions' format '%F{blue}-- %d --%f'
zstyle ':completion:*:messages'     format '%F{yellow}%d%f'
zstyle ':completion:*:warnings'     format '%F{red}no matches%f'
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*:approximate:*' max-errors 2 numeric

# ── functions locais ───────────────────────────────────────────────────────
for f in "$ZDOTDIR/functions/"*.zsh;    do [ -r "$f" ] && source "$f"; done

# ── plugins via znap (fzf-tab, autosuggestions, highlighting, etc.) ────────
[ -r "$ZDOTDIR/plugin.zsh" ] && source "$ZDOTDIR/plugin.zsh"

# atalhos FZF
bindkey '^R'   fzf-history-widget
bindkey '^T'   fzf-file-widget
bindkey '^[c'  fzf-cd-widget   # Alt-c

# ── zoxide/mise ────────────────────────────────────────────────────────────
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v mise   >/dev/null 2>&1 && eval "$(mise activate zsh)"

# ── Oh My Posh (PROMPT) ────────────────────────────────────────────────────
typeset -g OMP_CFG="${XDG_CONFIG_HOME:-$HOME/.config}/oh-my-posh/kora-cyberpunk.omp.json"
if command -v oh-my-posh >/dev/null 2>&1 && [[ -r "$OMP_CFG" ]]; then
  eval "$(oh-my-posh init zsh --config "$OMP_CFG")"
else
  PROMPT='%n @%m %1~ %# '
fi

# ── Gemini env opcional ────────────────────────────────────────────────────
[ -r "$XDG_CONFIG_HOME/ai/env/gemini.env" ] && set -o allexport && source "$XDG_CONFIG_HOME/ai/env/gemini.env" && set +o allexport
