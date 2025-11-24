# Keybindings úteis para dev

bindkey ' ' magic-space
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

# Busca incremental no histórico
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# Histórico via fzf (se instalado)
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() {
    BUFFER=$(fc -l 1 | fzf --height 40% --reverse --tac | sed 's/ *[0-9]* *//')
    CURSOR=${#BUFFER}
    zle redisplay
  }
  zle -N fzf-history-widget
  bindkey '^T' fzf-history-widget
fi
