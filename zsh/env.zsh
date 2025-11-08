# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# env.zsh — KORA NEON Environment
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# Editors
export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less -R"
export MANPAGER='nvim +Man!'
export MANWIDTH=999
export COLORTERM="truecolor"

# Locale
export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

# Wayland
export XDG_SESSION_TYPE=wayland
export MOZ_ENABLE_WAYLAND=1
export ELECTRON_OZONE_PLATFORM_HINT=auto

# Paths (only add if exists)
typeset -U path
[[ -d "$HOME/.cargo/bin" ]] && path+="$HOME/.cargo/bin"
[[ -d "$HOME/.local/share/go/bin" ]] && path+="$HOME/.local/share/go/bin"
[[ -d "$HOME/.local/share/pnpm" ]] && path+="$HOME/.local/share/pnpm"
[[ -d "$HOME/.local/share/bun/bin" ]] && path+="$HOME/.local/share/bun/bin"
[[ -d "$HOME/.local/bin" ]] && path+="$HOME/.local/bin"
[[ -d "$HOME/dotfiles/bin" ]] && path+="$HOME/dotfiles/bin"
[[ -d "$HOME/bin" ]] && path+="$HOME/bin"
export PATH

# Go
export GOPATH="$HOME/.local/share/go"

# Mise
export MISE_SHELL=zsh

# FZF KORA Neon colors
export FZF_DEFAULT_OPTS=$'--ansi --height=80% --layout=reverse --border=rounded \
  --color=fg:#E6EDF3,bg:#0A0B0D,hl:#FACC15,fg+:#E6EDF3,bg+:#1F232A,hl+:#FACC15 \
  --color=info:#22D3EE,prompt:#7C3AED,spinner:#22D3EE,pointer:#22E3B3,marker:#22E3B3,header:#7C3AED \
  --pointer="▸" --marker="✓" --prompt="❯ "'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Bat theme
export BAT_THEME="Coldark-Dark"

# Less colors
export LESS_TERMCAP_mb=$'\e[1;35m'
export LESS_TERMCAP_md=$'\e[1;36m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;44;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;32m'

# Cheatsheet + helper aliases
typeset -g __REDHOOD_ZSH_DIR=${${(%):-%N}:h}
[[ -f "${__REDHOOD_ZSH_DIR}/cheatsheet.zsh" ]] && source "${__REDHOOD_ZSH_DIR}/cheatsheet.zsh"
[[ -f "${__REDHOOD_ZSH_DIR}/functions.zsh" ]] && source "${__REDHOOD_ZSH_DIR}/functions.zsh"
