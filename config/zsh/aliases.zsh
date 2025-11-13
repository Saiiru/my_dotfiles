#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Aliases
# Atalhos de comando centralizados
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# MODERN TOOL REPLACEMENTS
#───────────────────────────────────────────────────────────────────────

alias ls='eza --icons --group-directories-first'
alias l='eza -l --icons --git --group-directories-first'
alias la='eza -la --icons --git --group-directories-first --header'
alias ll='eza -l --icons --git --group-directories-first --header'
alias lt='eza --tree --level=2 --icons'
alias lta='eza --tree --level=3 --icons --all'
alias ltr='eza --tree --icons'

alias cat='bat --style=plain'
alias catp='bat --style=full'
alias catt='bat --style=plain --paging=never'

alias vim='nvim'
alias vi='nvim'
alias v='nvim'

alias find='fd'
alias grep='rg'

#───────────────────────────────────────────────────────────────────────
# NAVIGATION
#───────────────────────────────────────────────────────────────────────

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ~='cd ~'
alias -- -='cd -'

alias work='cd ~/workspace'
alias proj='cd ~/projects'
alias dots='cd ~/gotham'
alias conf='cd ~/.config'

#───────────────────────────────────────────────────────────────────────
# GIT
#───────────────────────────────────────────────────────────────────────

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gap='git add --patch'
alias gb='git branch'
alias gba='git branch --all'
alias gbd='git branch --delete'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gca='git commit --amend'
alias gcan='git commit --amend --no-edit'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gr='git restore'
alias grs='git restore --staged'
alias gs='git status --short'
alias gst='git status'
alias gsw='git switch'
alias gsc='git switch -c'
alias glog='git log --oneline --decorate --graph --all'
alias gwip='git add -A && git commit -m "WIP"'
alias gundo='git reset --soft HEAD~1'

#───────────────────────────────────────────────────────────────────────
# DOCKER
#───────────────────────────────────────────────────────────────────────

alias d='docker'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dcr='docker compose restart'
alias dps='docker ps --format "table {{.ID}}\t{{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dpa='docker ps -a'
alias di='docker images'
alias dclean='docker system prune -af --volumes'

#───────────────────────────────────────────────────────────────────────
# SYSTEM
#───────────────────────────────────────────────────────────────────────

alias sudo='sudo '
alias update='paru -Syu'
alias install='paru -S'
alias remove='paru -Rns'
alias search='paru -Ss'
alias clean='paru -Sc'

alias sysinfo='fastfetch'
alias ports='netstat -tulanp'
alias meminfo='free -h -l -t'

#───────────────────────────────────────────────────────────────────────
# MISE
#───────────────────────────────────────────────────────────────────────

alias mr='mise run'
alias mt='mise tasks'
alias ml='mise list'
alias mu='mise upgrade'
alias mc='mise run check'
alias md='mise run doctor'

#───────────────────────────────────────────────────────────────────────
# TMUX
#───────────────────────────────────────────────────────────────────────

alias ta='tmux attach -t'
alias tl='tmux list-sessions'
alias tn='tmux new-session -s'
alias tk='tmux kill-session -t'
