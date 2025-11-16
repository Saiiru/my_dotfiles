#!/usr/bin/env zsh
# -----------------------------------------------------------------------------
# Workstation Shell · History policies
# -----------------------------------------------------------------------------
# Defines where history lives, ensures persistence and exposes helper widgets
# (fzf-powered search, statistics, dedupe). Use this file to keep history
# hygiene decisions centralised.
# -----------------------------------------------------------------------------

# --- Storage -----------------------------------------------------------------

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=50000
SAVEHIST=50000

# Cria diretório se não existir
[[ -d "${HISTFILE:h}" ]] || mkdir -p "${HISTFILE:h}"

# --- FZF search widget (Ctrl+R) ---------------------------------------------

fzf-history-widget-enhanced() {
    local selected
    selected=$(fc -rl 1 |
        fzf --tac --no-sort \
            --query="$LBUFFER" \
            --prompt='History ❯ ' \
            --height=60% \
            --border=rounded \
            --preview='echo {}' \
            --preview-window=down:3:wrap \
            --color='fg:#00ff00,bg:#000000,hl:#ff073a' \
            --color='fg+:#00ffff,bg+:#1a1a1a,hl+:#ff073a' \
            --color='border:#ff073a,prompt:#00ff00' \
            --bind='ctrl-y:execute-silent(echo -n {3..} | wl-copy)+abort')
    
    if [[ -n "$selected" ]]; then
        LBUFFER="${selected#*[0-9]* }"
    fi
    zle reset-prompt
}

zle -N fzf-history-widget-enhanced

# Keybind: Ctrl+R
bindkey '^R' fzf-history-widget-enhanced

# --- Analysis helpers --------------------------------------------------------

# Mostra comandos mais usados
history-top() {
    local limit="${1:-20}"
    fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " CMD[a]/count*100 "% " a;}' |
        grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n "$limit"
}

# Busca no histórico por padrão
history-search() {
    fc -l 1 | grep -i "$1"
}

# Limpa duplicatas do histórico
history-dedupe() {
    cp "$HISTFILE" "$HISTFILE.bak"
    awk '!seen[$0]++' "$HISTFILE.bak" > "$HISTFILE"
    echo "✓ History deduplicated. Backup: $HISTFILE.bak"
}
