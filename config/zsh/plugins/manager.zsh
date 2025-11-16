#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Plugin Manager (Znap)
# Sistema de carregamento de plugins otimizado
#═══════════════════════════════════════════════════════════════════════

typeset -g ZNAP_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/znap"

#───────────────────────────────────────────────────────────────────────
# Install Znap if not present
#───────────────────────────────────────────────────────────────────────

if [[ ! -d "$ZNAP_DIR" ]]; then
    print -P "%F{#00ff00}==> Installing Znap...%f"
    git clone --depth=1 https://github.com/marlonrichert/zsh-snap.git "$ZNAP_DIR"
fi

source "$ZNAP_DIR/znap.zsh" || return 0

#───────────────────────────────────────────────────────────────────────
# CORE PLUGINS
#───────────────────────────────────────────────────────────────────────

# zsh-autosuggestions (preferir sistema)
if [[ -r /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh
else
    znap source zsh-users/zsh-autosuggestions
fi

# zsh-completions
znap source zsh-users/zsh-completions

# fzf-tab (completion visual)
znap source Aloxaf/fzf-tab

# history-substring-search (preferir sistema)
if [[ -r /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
    source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
else
    znap source zsh-users/zsh-history-substring-search
fi

#───────────────────────────────────────────────────────────────────────
# PRODUCTIVITY PLUGINS
#───────────────────────────────────────────────────────────────────────

# zsh-autopair (fecha parênteses/aspas)
znap source hlissner/zsh-autopair

# zsh-you-should-use (sugere aliases)
znap source MichaelAquilina/zsh-you-should-use

# git-open (abre repo no browser)
znap source paulirish/git-open

# zsh-better-npm-completion
znap source lukechilds/zsh-better-npm-completion

#───────────────────────────────────────────────────────────────────────
# PLUGIN CONFIGURATIONS
#───────────────────────────────────────────────────────────────────────

# Autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555555,italic'
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_USE_ASYNC=1
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# You-Should-Use
export YSU_MESSAGE_POSITION="after"
export YSU_MODE=ALL
export YSU_HARDCORE=1

#───────────────────────────────────────────────────────────────────────
# FZF-TAB CONFIGURATION (ZERO REDRAWS)
#───────────────────────────────────────────────────────────────────────

# Desabilita continuous trigger
zstyle ':fzf-tab:*' continuous-trigger ''
zstyle ':fzf-tab:*' fzf-min-height 15

# Flags otimizadas
zstyle ':fzf-tab:*' fzf-flags \
    --height=40% \
    --layout=reverse \
    --border=rounded \
    --info=inline \
    --prompt='❯ ' \
    --pointer='▶' \
    --marker='✓' \
    --color='fg:#00ff00,bg:#000000,hl:#ff073a' \
    --color='fg+:#00ffff,bg+:#1a1a1a,hl+:#ff073a' \
    --color='info:#00ffff,prompt:#00ff00,pointer:#ff073a' \
    --color='marker:#00ff00,spinner:#00ffff,header:#ff00ff' \
    --color='border:#ff073a' \
    --no-mouse

zstyle ':fzf-tab:*' fzf-pad 4
zstyle ':fzf-tab:*' switch-group '<' '>'

# Previews seletivos
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza --tree --level=1 --icons --color=always $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:(bat|cat|nvim|vim):*' fzf-preview 'bat --color=always --style=numbers $realpath 2>/dev/null'
zstyle ':fzf-tab:complete:git-add:*' fzf-preview 'git diff --color=always $word 2>/dev/null'

# Desabilita previews em comandos comuns (performance)
zstyle ':fzf-tab:complete:(ls|mv|cp|rm):*' fzf-preview ''

#───────────────────────────────────────────────────────────────────────
# HISTORY SUBSTRING SEARCH KEYBINDS
#───────────────────────────────────────────────────────────────────────

# KEYBIND: ↑ — Busca no histórico com substring
bindkey '^[[A' history-substring-search-up

# KEYBIND: ↓ — Busca no histórico com substring
bindkey '^[[B' history-substring-search-down
