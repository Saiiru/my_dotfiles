# Keybindings úteis para dev (estilo emacs com extras)

bindkey -e

# Histórico no espaço
bindkey ' ' magic-space

# Navegação por palavra (Ctrl+← / Ctrl+→)
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# Kill word (Ctrl+Delete)
bindkey '^[[3;5~' kill-word

# Início/fim do buffer (PageUp / PageDown)
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

# Busca incremental (Ctrl+R / Ctrl+S)
bindkey '^R' history-incremental-search-backward
bindkey '^S' history-incremental-search-forward

# fzf no Ctrl+T (se fzf disponível)
if command -v fzf >/dev/null 2>&1; then
  fzf-history-widget() {
    BUFFER=$(fc -l 1 | fzf --height 40% --reverse --tac | sed 's/ *[0-9]* *//')
    CURSOR=${#BUFFER}
    zle redisplay
  }
  zle -N fzf-history-widget
  bindkey '^T' fzf-history-widget
fi
