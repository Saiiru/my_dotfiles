#!/usr/bin/env zsh
#═══════════════════════════════════════════════════════════════════════
# GOTHAM SYSTEM — Project Management Functions
# Workflows táticos para gerenciamento de projetos
#═══════════════════════════════════════════════════════════════════════

#───────────────────────────────────────────────────────────────────────
# PROJECT — Navega para projeto com FZF
#───────────────────────────────────────────────────────────────────────

function project() {
    local project_dirs=("$WORKSPACE_DIR" "$PROJECTS_DIR" "$HOME/workspace" "$HOME/projects")
    local projects=""
    
    for dir in "${project_dirs[@]}"; do
        [[ -d "$dir" ]] && projects+=$(fd --type d --max-depth 2 . "$dir" 2>/dev/null)$'\n'
    done
    
    local selected
    selected=$(echo "$projects" | fzf \
        --height=60% \
        --border=rounded \
        --prompt='Project ❯ ' \
        --preview='eza --tree --level=2 --icons --color=always {} 2>/dev/null' \
        --preview-window='right:50%:wrap' \
        --color='fg:#00ff00,bg:#000000,border:#ff073a')
    
    [[ -n "$selected" ]] && cd "$selected"
}

#───────────────────────────────────────────────────────────────────────
# NEWPROJECT — Cria novo projeto com estrutura
#───────────────────────────────────────────────────────────────────────

function newproject() {
    local name="${1}"
    local type="${2:-generic}"
    
    [[ -z "$name" ]] && echo "Usage: newproject <name> [type]" && return 1
    
    local project_dir="${PROJECTS_DIR:-$HOME/projects}/${name}"
    
    if [[ -d "$project_dir" ]]; then
        echo "Error: Project already exists"
        return 1
    fi
    
    mkdir -p "$project_dir"
    cd "$project_dir"
    
    case "$type" in
        node|js|ts)
            pnpm init
            mkdir -p src tests
            echo "node_modules\ndist\n.env" > .gitignore
            cat > .mise.toml <<EOF
[tools]
node = "lts"

[tasks.dev]
run = "pnpm dev"

[tasks.build]
run = "pnpm build"

[tasks.test]
run = "pnpm test"
EOF
            ;;
        python|py)
            python -m venv .venv
            mkdir -p src tests
            echo ".venv\n__pycache__\n*.pyc\n.env" > .gitignore
            cat > .mise.toml <<EOF
[tools]
"python@3" = "3.12"

[tasks.test]
run = "pytest"

[tasks.lint]
run = "ruff check ."
EOF
            ;;
        go)
            go mod init "github.com/${USER}/${name}"
            mkdir -p cmd pkg internal
            cat > .mise.toml <<EOF
[tools]
go = "latest"

[tasks.build]
run = "go build -o bin/ ./..."

[tasks.test]
run = "go test ./..."
EOF
            ;;
        rust)
            cargo init
            cat > .mise.toml <<EOF
[tools]
rust = "stable"

[tasks.build]
run = "cargo build"

[tasks.test]
run = "cargo test"
EOF
            ;;
        *)
            mkdir -p src docs
            ;;
    esac
    
    git init
    echo "✓ Project created: $project_dir"
    mise install
}

#───────────────────────────────────────────────────────────────────────
# PROJECTINFO — Info do projeto atual
#───────────────────────────────────────────────────────────────────────

function projectinfo() {
    echo "╔════════════════════════════════════════╗"
    echo "║  PROJECT INFO                          ║"
    echo "╚════════════════════════════════════════╝"
    echo
    echo "Directory: $PWD"
    echo
    
    # Git info
    if git rev-parse --git-dir > /dev/null 2>&1; then
        echo "[Git]"
        echo "Branch: $(git rev-parse --abbrev-ref HEAD)"
        echo "Remote: $(git remote get-url origin 2>/dev/null || echo 'none')"
        echo "Last commit: $(git log -1 --pretty=format:'%h - %s (%ar)')"
        echo
    fi
    
    # Language detection
    if [[ -f "package.json" ]]; then
        echo "[Node.js]"
        echo "Version: $(node --version 2>/dev/null || echo 'not available')"
        echo "Package manager: $(command -v pnpm &>/dev/null && echo 'pnpm' || echo 'npm')"
        [[ -f "package.json" ]] && echo "Dependencies: $(jq -r '.dependencies | keys | length' package.json 2>/dev/null || echo '0')"
        echo
    fi
    
    if [[ -f "requirements.txt" || -f "pyproject.toml" ]]; then
        echo "[Python]"
        echo "Version: $(python --version 2>&1)"
        [[ -d ".venv" ]] && echo "Virtualenv: active" || echo "Virtualenv: none"
        echo
    fi
    
    if [[ -f "go.mod" ]]; then
        echo "[Go]"
        echo "Version: $(go version 2>&1 | awk '{print $3}')"
        echo "Module: $(grep '^module' go.mod | awk '{print $2}')"
        echo
    fi
    
    if [[ -f "Cargo.toml" ]]; then
        echo "[Rust]"
        echo "Version: $(rustc --version 2>&1)"
        echo "Package: $(grep '^name' Cargo.toml | head -1 | cut -d'"' -f2)"
        echo
    fi
    
    # Mise info
    if [[ -f ".mise.toml" ]]; then
        echo "[Mise]"
        mise list
        echo
    fi
}

#───────────────────────────────────────────────────────────────────────
# SESSION — Abre projeto em tmux session
#───────────────────────────────────────────────────────────────────────

function session() {
    local project_name="${1:-$(basename "$PWD")}"
    local session_name="dev:${project_name}"
    
    if tmux has-session -t "$session_name" 2>/dev/null; then
        tmux attach -t "$session_name"
        return 0
    fi
    
    # Create new session
    tmux new-session -d -s "$session_name" -c "$PWD"
    
    # Window 1: Editor
    tmux rename-window -t "$session_name":1 "editor"
    tmux send-keys -t "$session_name":1 'nvim .' C-m
    
    # Window 2: Shell
    tmux new-window -t "$session_name":2 -c "$PWD" -n "shell"
    
    # Window 3: Server (se aplicável)
    if [[ -f "package.json" ]] || [[ -f ".mise.toml" ]]; then
        tmux new-window -t "$session_name":3 -c "$PWD" -n "server"
    fi
    
    tmux select-window -t "$session_name":1
    tmux attach -t "$session_name"
}
