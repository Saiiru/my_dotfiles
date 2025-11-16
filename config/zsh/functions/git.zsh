#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# WORKSTATION OPS — Git Functions
# Workflows táticos para Git
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# GCB — Checkout de branch com FZF
#───────────────────────────────────────────────────────────────────────

function gcb() {
    local branch
    branch=$(git branch --all | grep -v HEAD | 
             sed 's/.* //' | sed 's#remotes/[^/]*/##' | 
             sort -u | 
             fzf --height=60% \
                 --border=rounded \
                 --prompt='Branch ❯ ' \
                 --preview='git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" {} | head -200' \
                 --preview-window='right:60%:wrap' \
                 --color='fg:#00ff00,bg:#000000,hl:#ff073a' \
                 --color='border:#ff073a,prompt:#00ff00')
    
    [[ -n "$branch" ]] && git checkout "$branch"
}

# Widget para Ctrl+G B
function fzf-git-branch-widget() {
    gcb
    zle reset-prompt
}
zle -N fzf-git-branch-widget

# KEYBIND: Ctrl+G B — Checkout branch interativo
bindkey '^Gb' fzf-git-branch-widget

#───────────────────────────────────────────────────────────────────────
# GCH — Checkout de commit com FZF
#───────────────────────────────────────────────────────────────────────

function gch() {
    local commit
    commit=$(git log --oneline --decorate --all --color=always | 
             fzf --height=60% \
                 --ansi \
                 --border=rounded \
                 --prompt='Commit ❯ ' \
                 --preview='git show --color=always {1}' \
                 --preview-window='right:60%:wrap' \
                 --color='border:#ff073a,prompt:#00ff00')
    
    [[ -n "$commit" ]] && git checkout "$(echo $commit | awk '{print $1}')"
}

# Widget para Ctrl+G H
function fzf-git-commit-widget() {
    gch
    zle reset-prompt
}
zle -N fzf-git-commit-widget

# KEYBIND: Ctrl+G H — Checkout commit interativo
bindkey '^Gh' fzf-git-commit-widget

#───────────────────────────────────────────────────────────────────────
# GAF — Add arquivos interativamente
#───────────────────────────────────────────────────────────────────────

function gaf() {
    local files
    files=$(git status --short | 
            fzf -m \
                --height=60% \
                --border=rounded \
                --prompt='Add files ❯ ' \
                --preview='git diff --color=always {2}' \
                --preview-window='right:60%:wrap' \
                --color='fg:#00ff00,bg:#000000' \
                --color='border:#ff073a,prompt:#00ff00' | 
            awk '{print $2}')
    
    [[ -n "$files" ]] && echo "$files" | xargs git add && git status --short
}

# Widget para Ctrl+G A
function fzf-git-add-widget() {
    gaf
    zle reset-prompt
}
zle -N fzf-git-add-widget

# KEYBIND: Ctrl+G A — Add arquivos interativo
bindkey '^Ga' fzf-git-add-widget

#───────────────────────────────────────────────────────────────────────
# GCL — Clone e CD
#───────────────────────────────────────────────────────────────────────

function gcl() {
    [[ -z "$1" ]] && echo "Usage: gcl <repo_url>" && return 1
    git clone "$1" && cd "$(basename "$1" .git)"
}

#───────────────────────────────────────────────────────────────────────
# GCLEAN — Limpa branches merged
#───────────────────────────────────────────────────────────────────────

function gclean() {
    git branch --merged | grep -v '\*\|main\|master\|develop' | xargs -r git branch -d
    echo "✓ Cleaned merged branches"
}

#───────────────────────────────────────────────────────────────────────
# GSYNC — Sync com upstream
#───────────────────────────────────────────────────────────────────────

function gsync() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    git fetch upstream && git merge "upstream/$branch"
}

#───────────────────────────────────────────────────────────────────────
# GSTATS — Estatísticas do repositório
#───────────────────────────────────────────────────────────────────────

function gstats() {
    echo "╔════════════════════════════════════════╗"
    echo "║  Git Repository Statistics             ║"
    echo "╚════════════════════════════════════════╝"
    echo
    echo "Commits: $(git rev-list --count HEAD)"
    echo "Contributors: $(git shortlog -sn | wc -l)"
    echo "Branches: $(git branch -a | wc -l)"
    echo "Tags: $(git tag | wc -l)"
    echo
    echo "Top contributors:"
    git shortlog -sn | head -5
}

#───────────────────────────────────────────────────────────────────────
# GLOG — Log avançado com gráfico
#───────────────────────────────────────────────────────────────────────

function glog() {
    git log --graph \
            --pretty=format:'%C(yellow)%h%C(reset) %C(blue)%ad%C(reset) %C(green)%an%C(reset) %s %C(red)%d%C(reset)' \
            --date=short \
            --all \
            "${@}"
}

#───────────────────────────────────────────────────────────────────────
# GDIFF — Diff com Delta (se disponível)
#───────────────────────────────────────────────────────────────────────

function gdiff() {
    if command -v delta >/dev/null 2>&1; then
        git diff "$@" | delta
    else
        git diff --color=always "$@"
    fi
}
