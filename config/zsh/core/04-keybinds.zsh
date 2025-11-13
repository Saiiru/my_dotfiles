#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Keybindings Configuration
# Sistema tático de atalhos de teclado
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# VI MODE (base)
#───────────────────────────────────────────────────────────────────────

bindkey -v
export KEYTIMEOUT=1

#───────────────────────────────────────────────────────────────────────
# LINE EDITING (Emacs-style, funciona em Vi mode)
#───────────────────────────────────────────────────────────────────────

# KEYBIND: Ctrl+A — Início da linha
bindkey '^A' beginning-of-line

# KEYBIND: Ctrl+E — Fim da linha
bindkey '^E' end-of-line

# KEYBIND: Ctrl+K — Deleta até o fim
bindkey '^K' kill-line

# KEYBIND: Ctrl+U — Deleta até o início
bindkey '^U' backward-kill-line

# KEYBIND: Ctrl+W — Deleta palavra anterior
bindkey '^W' backward-kill-word

# KEYBIND: Ctrl+Y — Cola (yank)
bindkey '^Y' yank

# KEYBIND: Alt+. — Insere último argumento
bindkey '\e.' insert-last-word

#───────────────────────────────────────────────────────────────────────
# HISTORY NAVIGATION
#───────────────────────────────────────────────────────────────────────

# KEYBIND: Ctrl+P — Histórico anterior
bindkey '^P' history-search-backward

# KEYBIND: Ctrl+N — Histórico próximo
bindkey '^N' history-search-forward

# KEYBIND: Ctrl+R — Busca no histórico (definido em history.zsh)
# (já configurado via fzf-history-widget-enhanced)

#───────────────────────────────────────────────────────────────────────
# WORD NAVIGATION
#───────────────────────────────────────────────────────────────────────

# KEYBIND: Ctrl+← — Palavra anterior
bindkey '^[[1;5D' backward-word

# KEYBIND: Ctrl+→ — Próxima palavra
bindkey '^[[1;5C' forward-word

# KEYBIND: Alt+B — Palavra anterior (alternativo)
bindkey '\eb' backward-word

# KEYBIND: Alt+F — Próxima palavra (alternativo)
bindkey '\ef' forward-word

#───────────────────────────────────────────────────────────────────────
# AUTOSUGGESTIONS (configurado via plugin)
#───────────────────────────────────────────────────────────────────────

# KEYBIND: Ctrl+Space — Aceita sugestão completa
bindkey '^ ' autosuggest-accept

# KEYBIND: Ctrl+F — Aceita sugestão completa (alternativo)
bindkey '^F' autosuggest-accept

# KEYBIND: Alt+F — Aceita próxima palavra da sugestão
bindkey '\ef' forward-word

#───────────────────────────────────────────────────────────────────────
# EDIT COMMAND IN EDITOR
#───────────────────────────────────────────────────────────────────────

autoload -z edit-command-line
zle -N edit-command-line

# KEYBIND: Ctrl+X Ctrl+E — Edita comando no $EDITOR
bindkey '^X^E' edit-command-line

#───────────────────────────────────────────────────────────────────────
# SUDO WIDGET
#───────────────────────────────────────────────────────────────────────

function sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line

# KEYBIND: Esc Esc — Adiciona/remove sudo
bindkey '\e\e' sudo-command-line

#───────────────────────────────────────────────────────────────────────
# RELOAD SHELL WIDGET
#───────────────────────────────────────────────────────────────────────

function reload-shell-widget() {
    exec zsh
}
zle -N reload-shell-widget

# KEYBIND: Ctrl+X R — Reload shell
bindkey '^Xr' reload-shell-widget

#───────────────────────────────────────────────────────────────────────
# CLEAR SCREEN
#───────────────────────────────────────────────────────────────────────

# KEYBIND: Ctrl+L — Limpa tela
bindkey '^L' clear-screen
