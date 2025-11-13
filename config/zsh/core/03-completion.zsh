#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Completion System
# Sistema avançado de auto-completion
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# Cache Configuration
#───────────────────────────────────────────────────────────────────────

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"

[[ -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ]] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"

#───────────────────────────────────────────────────────────────────────
# Behavior
#───────────────────────────────────────────────────────────────────────

zstyle ':completion:*' menu select=2
zstyle ':completion:*' matcher-list \
    'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' \
    'l:|=* r:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' rehash true
zstyle ':completion:*' insert-tab false
zstyle ':completion:*' list-packed yes
zstyle ':completion:*' squeeze-slashes true

#───────────────────────────────────────────────────────────────────────
# Neon Vigilante Formatting
#───────────────────────────────────────────────────────────────────────

zstyle ':completion:*:descriptions' format '%F{#00ff00}━━ %d ━━%f'
zstyle ':completion:*:warnings' format '%F{#ff073a}━━ no matches ━━%f'
zstyle ':completion:*:messages' format '%F{#00ffff}━━ %d ━━%f'
zstyle ':completion:*:corrections' format '%F{#ffff00}━━ %d (errors: %e) ━━%f'
zstyle ':completion:*' format '%F{#ff00ff}━━ %d ━━%f'

# Menu selection colors
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' select-prompt '%F{#000000}%K{#ff073a} %p %k%f'
zstyle ':completion:*' list-prompt '%F{#00ff00}%SAt %p: Hit TAB for more%s%f'

#───────────────────────────────────────────────────────────────────────
# Specific Completions
#───────────────────────────────────────────────────────────────────────

# Kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;91'
zstyle ':completion:*:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# Man pages
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true

# SSH/SCP
zstyle ':completion:*:(ssh|scp|rsync):*' tag-order 'hosts:-host:host hosts:-domain:domain *'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host' ignored-patterns '*(.|:)*' loopback localhost

# Directories
zstyle ':completion:*:*:cd:*' tag-order local-directories directory-stack path-directories
zstyle ':completion:*:*:cd:*:directory-stack' menu yes select
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'

# Git
zstyle ':completion:*:*:git:*' user-commands ${${(M)${(k)commands}:#git-*}/git-/}

#───────────────────────────────────────────────────────────────────────
# Init (otimizado com cache de 24h)
#───────────────────────────────────────────────────────────────────────

autoload -Uz compinit
typeset -g ZCOMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"

if [[ -n $ZCOMPDUMP(#qNmh-24) ]]; then
    compinit -C -d "$ZCOMPDUMP"
else
    compinit -d "$ZCOMPDUMP"
    { zcompile "$ZCOMPDUMP" } &!
fi

# Custom completions
compdef _gnu_generic fd rg bat eza
