# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# ~/dotfiles/zsh/aliases/aliases.zsh
# RED HOOD CYBERPUNK ALIASES - Complete Collection
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

# ═══════════════════════════════════════════════════════════════════
# MODERN REPLACEMENTS
# ═══════════════════════════════════════════════════════════════════
alias ls='eza --group-directories-first --icons=always --color=always'
alias ll='eza -lah --git --group-directories-first --icons=always --color=always'
alias la='eza -la --group-directories-first --git --icons=always --color=always'
alias lt='eza --tree --level=2 --icons=always --color=always'
alias l='eza -1 --icons=always --color=always'

alias cat='bat --paging=never --style=plain'
alias catt='bat --paging=never'
alias less='bat --paging=always'

alias top='btop'
alias htop='btop'

alias grep='rg'
alias find='fd'
alias du='dust'
alias df='duf'
alias ps='procs'

# ═══════════════════════════════════════════════════════════════════
# CLIPBOARD (Wayland)
# ═══════════════════════════════════════════════════════════════════
alias copy='wl-copy'
alias paste='wl-paste'
alias clip='wl-copy'

# ═══════════════════════════════════════════════════════════════════
# NAVIGATION
# ═══════════════════════════════════════════════════════════════════
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias -- -='cd -'

alias home='cd ~'
alias root='cd /'
alias dt='cd ~/Desktop'
alias dl='cd ~/Downloads'
alias docs='cd ~/Documents'
alias proj='cd ~/Projects'
alias dots='cd ~/dotfiles'
alias conf='cd ~/.config'

# ═══════════════════════════════════════════════════════════════════
# SAFETY
# ═══════════════════════════════════════════════════════════════════
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

# ═══════════════════════════════════════════════════════════════════
# SYSTEM
# ═══════════════════════════════════════════════════════════════════
alias update='paru -Syu'
alias upgrade='paru -Syu'
alias install='paru -S'
alias remove='paru -Rns'
alias search='paru -Ss'
alias cleanup='paru -Sc && paru -Rns $(paru -Qtdq) 2>/dev/null'
alias orphans='paru -Qtdq'
alias paclog='bat /var/log/pacman.log'

alias sysinfo='neofetch'
alias neo='neofetch'
alias fetch='neofetch'

alias ports='ss -tulpn'
alias listening='ss -tlnp'
alias myip='curl -s ifconfig.me'
alias localip='ip -4 addr | grep inet | grep -v 127.0.0.1'

# ═══════════════════════════════════════════════════════════════════
# QUICK EDITS
# ═══════════════════════════════════════════════════════════════════
alias zshrc='$EDITOR ~/.zshrc'
alias zshenv='$EDITOR ~/dotfiles/zsh/env.zsh'
alias aliases='$EDITOR ~/dotfiles/zsh/aliases/aliases.zsh'
alias hyprconf='$EDITOR ~/.config/hypr/hyprland.conf'
alias kittyconf='$EDITOR ~/.config/kitty/kitty.conf'
alias tmuxconf='$EDITOR ~/.config/tmux/tmux.conf'
alias nvimconf='cd ~/.config/nvim && $EDITOR'

# ═══════════════════════════════════════════════════════════════════
# QUICK ACTIONS
# ═══════════════════════════════════════════════════════════════════
alias reload='source ~/.zshrc'
alias c='clear'
alias cls='clear'
alias h='history'
alias j='jobs'
alias path='echo $PATH | tr ":" "\n"'

# ═══════════════════════════════════════════════════════════════════
# MISE SHORTCUTS
# ═══════════════════════════════════════════════════════════════════
alias mi='mise install'
alias mr='mise run'
alias mt='mise trust'
alias ml='mise list'
alias mu='mise use'
alias md='mise doctor'

# ═══════════════════════════════════════════════════════════════════
# TMUX
# ═══════════════════════════════════════════════════════════════════
alias ta='tmux attach'
alias tad='tmux attach -d'
alias ts='tmux new-session -s'
alias tl='tmux list-sessions'
alias tksv='tmux kill-server'
alias tkss='tmux kill-session -t'

# ═══════════════════════════════════════════════════════════════════
# RED HOOD CYBERPUNK SPECIFIC
# ═══════════════════════════════════════════════════════════════════

# Hyprland controls
alias hypreload='hyprctl reload && notify-send "⚡ Hyprland" "Reloaded"'
alias hyprinfo='hyprctl info'
alias hyprlog='bat ~/.local/share/hyprland/hyprland.log'

# Wallpaper
alias wp='${DOTFILES_DIR:-$HOME/dotfiles}/bin/dms-wall-apply'
alias wpnext='~/.config/hypr/scripts/wallpaper-glitch.sh next'
alias wpprev='~/.config/hypr/scripts/wallpaper-glitch.sh prev'
alias wprand='~/.config/hypr/scripts/wallpaper-glitch.sh random'

# Border effects
alias border-cycle='~/.config/hypr/scripts/glitch-border.sh cycle'
alias border-pulse='~/.config/hypr/scripts/neon-pulse.sh toggle'
alias border-glitch='~/.config/hypr/scripts/glitch-border.sh glitch'

# Quick apps
alias matrix='cmatrix -C magenta'
alias pipes='pipes.sh -t 2 -c 1,2,3'

# Ollama AI
alias ask='~/.config/qs/scripts/ollama-ask.sh'
alias ai='~/.config/qs/scripts/ollama-ask.sh'

# ═══════════════════════════════════════════════════════════════════
# DEVELOPMENT
# ═══════════════════════════════════════════════════════════════════

# Node/NPM/PNPM
alias ni='pnpm install'
alias nu='pnpm update'
alias nr='pnpm run'
alias nd='pnpm run dev'
alias nb='pnpm run build'
alias nt='pnpm run test'
alias nw='pnpm run watch'

# Python
alias py='python'
alias python='python3'
alias pip='pip3'
alias venv='python -m venv .venv'
alias activate='source .venv/bin/activate'

# Cheatsheet helpers / Mise runners
alias cheat='redhood_cheatsheet'
alias zcheat='redhood_cheatsheet'
alias mcheat='mise_cheatsheet'
alias ncheat='nvim_cheatsheet'
alias mt='misetask'
alias pomo='$HOME/dotfiles/config/tmux/scripts/pomodoro.sh'
alias 'pomo?'='$HOME/dotfiles/config/tmux/scripts/pomodoro.sh status'

alias pyvenv='mise run python:venv'
alias pysetup='mise run py:install'
alias pydev='mise run py:dev-install'
alias pytestall='mise run py:test'
alias pycov='mise run py:coverage'
alias pyfmt='mise run py:fmt'
alias pycheck='mise run py:lint'
alias nodeinstall='mise run node:install'
alias nodebuild='mise run node:build'
alias nodedev='mise run node:dev'
alias nodetest='mise run node:test'
alias gofmtproj='mise run go:fmt'
alias gotest='mise run go:test'
alias javadev='mise run session:java'
alias miselogs='mise run docker:logs'
alias taskhub='$HOME/dotfiles/bin/watchdogs-tasks'

# Git (more in aliases_git.zsh)
alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'

# Docker (more in aliases_docker.zsh)
alias d='docker'
alias dc='docker compose'
alias dps='docker ps'

# Kubernetes (more in aliases_kubernetes.zsh)
alias k='kubectl'

# Functions moved to zsh/functions.zsh
# ═══════════════════════════════════════════════════════════════════
# SUFFIX ALIASES - Open files with default apps
# ═══════════════════════════════════════════════════════════════════
alias -s {md,txt,json,yaml,yml,toml,conf}=$EDITOR
alias -s {jpg,jpeg,png,gif,webp}=feh
alias -s {mp4,mkv,avi,mov}=mpv
alias -s {pdf}=zathura

# helper alias for cheat.sh function
alias cht='cheatsh'

# ═══════════════════════════════════════════════════════════════════
# GLOBAL ALIASES
# ═══════════════════════════════════════════════════════════════════
alias -g G='| grep'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g W='| wc -l'
alias -g S='| sort'
alias -g U='| uniq'
alias -g C='| wc -l'
alias -g X='| xargs'
alias -g N='2>/dev/null'
alias -g J='| jq'
alias -g Y='| yq'

# ═══════════════════════════════════════════════════════════════════
# COLORED OUTPUT
# ═══════════════════════════════════════════════════════════════════
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if ! command -v eza >/dev/null 2>&1; then
        alias ls='ls --color=auto'
        alias ll='ls -lah --color=auto'
    fi
    if ! command -v rg >/dev/null 2>&1; then
        alias grep='grep --color=auto'
    fi
    if ! command -v diff >/dev/null 2>&1; then
        alias diff='diff --color=auto'
    fi
    alias ip='ip --color=auto'
fi
