#!/usr/bin/env bash
# BAT-HUD v3.0: Interactive Tactical Interface
# Local: ~/.local/bin/bat-hud (symlink) -> ~/workstation/bin/hud/bat_hud.sh
set -euo pipefail

BAT_HOME="${BAT_HOME:-$HOME/workstation}"
[[ -d "$BAT_HOME" ]] || { echo "FATAL: BAT_HOME not found: $BAT_HOME" >&2; exit 1; }

BAT_STACK=""
BAT_APP_SLUG=""
BAT_APP_TITLE=""

# Colors
declare -A C=(
    [R]="$(tput setaf 196 2>/dev/null || echo '')"
    [G]="$(tput setaf 46 2>/dev/null || echo '')"
    [C]="$(tput setaf 51 2>/dev/null || echo '')"
    [Y]="$(tput setaf 226 2>/dev/null || echo '')"
    [B]="$(tput setaf 33 2>/dev/null || echo '')"
    [M]="$(tput setaf 201 2>/dev/null || echo '')"
    [O]="$(tput setaf 208 2>/dev/null || echo '')"
    [P]="$(tput setaf 99 2>/dev/null || echo '')"
    [W]="$(tput setaf 15 2>/dev/null || echo '')"
    [GRAY]="$(tput setaf 240 2>/dev/null || echo '')"
    [BOLD]="$(tput bold 2>/dev/null || echo '')"
    [DIM]="$(tput dim 2>/dev/null || echo '')"
    [X]="$(tput sgr0 2>/dev/null || echo '')"
)

c(){ echo -n "${C[$1]:-}"; }
r(){ c X; }
has(){ command -v "$1" >/dev/null 2>&1; }

# ── RENDERING ────────────────────────────────────────────────────────────
render_logo() {
    if [[ -f "$(dirname "$0")/logo.sh" ]]; then
        # shellcheck disable=SC1091
        source "$(dirname "$0")/logo.sh" && render_batman_logo && return
    fi
    cat <<EOF
$(c R)                                  ▄▄
                            ▄▄▄█████████▄▄▄
                       ▄▄████████████████████▄▄
                    ▄███████████████████████████▄
                  ▄████████████████████████████████▄
                ▄████████████████▀▀▀▀▀████████████████▄
              ▄████████████▀▀            ▀▀████████████▄
            ▄███████████▀                    ▀███████████▄
           ████████████                        ████████████
          ███████████▀                          ▀███████████
         ███████████                              ███████████
        ███████████                                ███████████
       ███████████        $(c Y)▄▄▄▄▄▄▄▄▄▄▄▄$(c R)        ███████████
       ██████████      $(c Y)▄███████████████▄$(c R)      ██████████
       █████████      $(c Y)███████████████████$(c R)      █████████
       █████████     $(c Y)█████████████████████$(c R)     █████████
       █████████     $(c Y)█████████████████████$(c R)     █████████
       █████████      $(c Y)███████████████████$(c R)      █████████
        ████████       $(c Y)▀███████████████▀$(c R)       ████████
         ███████          $(c Y)▀▀▀▀▀▀▀▀▀▀▀$(c R)          ███████
          ██████                                ██████
           ████                                  ████$(r)
EOF
}

load_batproj(){
    [[ -f ".batproj" ]] || return
    # shellcheck disable=SC1091
    source ./.batproj 2>/dev/null || true
    BAT_STACK="${STACK:-$BAT_STACK}"
    BAT_APP_SLUG="${APP_SLUG:-$BAT_APP_SLUG}"
    BAT_APP_TITLE="${APP_TITLE:-$BAT_APP_TITLE}"
}

detect_stack(){
    [[ -n "$BAT_STACK" ]] && { echo "$BAT_STACK"; return; }
    [[ -f pom.xml || -f build.gradle || -f build.gradle.kts ]] && { echo "java"; return; }
    [[ -f pyproject.toml ]] && { echo "python"; return; }
    [[ -f go.mod ]] && { echo "go"; return; }
    echo "unknown"
}

project_name(){
    [[ -n "${BAT_APP_TITLE:-}" ]] && { echo "$BAT_APP_TITLE"; return; }
    [[ -n "${BAT_APP_SLUG:-}" ]] && { echo "$BAT_APP_SLUG"; return; }
    basename "$PWD"
}

get_sys_info(){
    local os kernel uptime mem disk
    if [[ -f /etc/os-release ]]; then source /etc/os-release; os="$NAME $VERSION_ID"; else os=$(uname -s); fi
    kernel=$(uname -r)
    uptime=$(uptime -p 2>/dev/null | sed 's/up //' || echo "unknown")
    mem=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3 "/" $2}')
    disk=$(df -h "$PWD" 2>/dev/null | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')
    echo "$os|$kernel|$uptime|$mem|$disk"
}

get_git_info(){
    git rev-parse --git-dir >/dev/null 2>&1 || { echo "not-repo||||"; return; }
    local branch files ahead behind
    branch=$(git branch --show-current 2>/dev/null || echo "detached")
    files=$(git status --short 2>/dev/null | wc -l)
    ahead=$(git rev-list --count @{u}..HEAD 2>/dev/null || echo 0)
    behind=$(git rev-list --count HEAD..@{u} 2>/dev/null || echo 0)
    echo "$branch|$files|$ahead|$behind"
}

get_mise_tasks(){
    local stack="$1" prefix
    has mise || return
    case "$stack" in
        java) prefix="java:" ;;
        python) prefix="py:" ;;
        go) prefix="go:" ;;
        *) prefix="" ;;
    esac
    mise tasks 2>/dev/null | grep "^${prefix}" || true
}

render_header(){
    local stack="$1"
    clear
    render_logo
    echo
    echo "$(c C)$(c BOLD)BATCOMPUTER · TACTICAL INTERFACE v3.0$(r)"
    echo "$(c GRAY)Gotham Development Nexus · Interactive Command Center$(r)"
    if [[ "$stack" != "unknown" ]]; then
        local icon title
        case "$stack" in
            java) icon="☕"; title="BATMAN · Core API Domain" ;;
            python) icon="🐍"; title="NIGHTWING · Automation" ;;
            go) icon="🐹"; title="RED HOOD · Services" ;;
        esac
        echo "$(c Y)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(r)"
        echo "$(c C)$(c BOLD)$icon $title$(r)"
        echo "$(c Y)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(r)"
    fi
}

render_system_panel(){
    IFS='|' read -r os kernel uptime mem disk <<< "$(get_sys_info)"
    echo
    echo "$(c BOLD)SYSTEM$(r)"
    printf "  $(c B)▸$(r) OS      %s\n" "$(c G)$os$(r)"
    printf "  $(c B)▸$(r) Kernel  %s\n" "$(c G)$kernel$(r)"
    printf "  $(c B)▸$(r) Uptime  %s\n" "$(c G)$uptime$(r)"
    printf "  $(c B)▸$(r) Memory  %s\n" "$(c G)$mem$(r)"
    printf "  $(c B)▸$(r) Disk    %s\n" "$(c G)$disk$(r)"
}

render_project_panel(){
    local name branch files ahead behind
    name=$(project_name)
    IFS='|' read -r branch files ahead behind <<< "$(get_git_info)"
    echo
    echo "$(c BOLD)PROJECT$(r)"
    printf "  $(c B)▸$(r) Name   %s\n" "$(c Y)$name$(r)"
    printf "  $(c B)▸$(r) Path   %s\n" "$(c M)$PWD$(r)"
    [[ -n "$BAT_STACK" ]] && printf "  $(c B)▸$(r) Stack  %s\n" "$(c C)$BAT_STACK$(r)"
    printf "  $(c B)▸$(r) Git    "
    if [[ "$branch" == "not-repo" ]]; then
        echo "$(c GRAY)Not a repo$(r)"
    else
        [[ "$files" -gt 0 ]] && echo -n "$(c R)●$(r) " || echo -n "$(c G)✓$(r) "
        echo -n "$(c C)$branch$(r)"
        [[ "$files" -gt 0 ]] && echo -n " $(c Y)($files changes)$(r)"
        [[ "$ahead" -gt 0 ]] && echo -n " $(c C)↑$ahead$(r)"
        [[ "$behind" -gt 0 ]] && echo -n " $(c O)↓$behind$(r)"
        echo
    fi
}

render_tasks_panel(){
    local stack="$1" tasks
    tasks=$(get_mise_tasks "$stack")
    echo
    echo "$(c BOLD)TASKS (mise run …)$(r)"
    if [[ -z "$tasks" ]]; then
        echo "  $(c GRAY)No tasks found. Run: mise trust$(r)"
        return
    fi
    echo "$tasks" | nl -w2 -s') ' | sed 's/^/  /'
}

# ── Ações interativas ───────────────────────────────────────────────────
action_execute_task(){
    local stack="$1" tasks task task_name
    tasks=$(get_mise_tasks "$stack")
    [[ -z "$tasks" ]] && { echo "$(c R)No tasks available$(r)"; sleep 1; return; }
    if has gum; then
        task=$(echo "$tasks" | gum choose --header "Select task (mise run …)")
    else
        echo "$tasks" | nl -w2 -s') '
        read -rp "Choice: " n
        task=$(echo "$tasks" | sed -n "${n}p")
    fi
    [[ -z "$task" ]] && return
    task_name=$(echo "$task" | awk '{print $1}')
    echo "$(c C)Running: mise run $task_name$(r)"
    mise run "$task_name"
    read -rp "ENTER to continue..."
}

action_git_ops(){
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        echo "$(c R)Not a git repo$(r)"; sleep 1; return;
    fi
    local choice
    if has gum; then
        choice=$(gum choose --header "Git operations" "Status" "Log" "Commit" "Push" "Pull" "Cancel")
    else
        echo "1) Status 2) Log 3) Commit 4) Push 5) Pull 6) Cancel"
        read -rp "> " n
        case "$n" in
            1) choice="Status";; 2) choice="Log";; 3) choice="Commit";; 4) choice="Push";; 5) choice="Pull";; *) choice="Cancel";;
        esac
    fi
    case "$choice" in
        Status) git status; read -rp "ENTER..." ;;
        Log) git log --oneline --graph -20; read -rp "ENTER..." ;;
        Commit) git add -A; read -rp "Message: " msg; git commit -m "$msg" || true ;;
        Push) git push ;;
        Pull) git pull --rebase ;;
    esac
}

action_project_switch(){
    if ! has zoxide || ! has fzf; then
        echo "$(c R)Requires zoxide + fzf$(r)"; sleep 1; return;
    fi
    local dest
    dest=$(zoxide query -l | fzf --height=100% --reverse --prompt="🦇 PROJECT > " --preview="ls -lah {} 2>/dev/null | head -20" --color="border:#dc143c,prompt:#ff073a,pointer:#22e3b3")
    [[ -z "$dest" ]] && return
    cd "$dest" || return
    exec "$0"
}

action_new_project(){ bat-new-project; read -rp "ENTER..." ; }
action_tmux_layout(){ bat-tmux-layout; read -rp "ENTER..." ; }

show_menu(){
    echo
    echo "$(c Y)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(r)"
    echo "$(c C)ACTIONS$(r)"
    echo "  $(c G)T$(r) Task   $(c G)G$(r) Git   $(c G)P$(r) Project   $(c G)N$(r) New   $(c G)L$(r) Layout   $(c G)R$(r) Refresh   $(c G)Q$(r) Quit"
    echo "$(c Y)━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━$(r)"
}

interactive_loop(){
    local stack="$1" action
    while true; do
        render_header "$stack"
        render_system_panel
        render_project_panel
        render_tasks_panel "$stack"
        show_menu
        read -rn1 -p "Choose: " action; echo
        case "${action,,}" in
            t) action_execute_task "$stack" ;;
            g) action_git_ops ;;
            p) action_project_switch ;;
            n) action_new_project ;;
            l) action_tmux_layout ;;
            r) continue ;;
            q) break ;;
        esac
    done
}

main(){
    load_batproj
    local stack
    stack=$(detect_stack)
    if [[ "$stack" == "unknown" ]]; then
        render_header "$stack"
        render_system_panel
        echo
        echo "$(c Y)No project detected. Use bat-new-project ou cd ~/github/<proj>$(r)"
        read -rp "ENTER to exit..."
        return 1
    fi
    interactive_loop "$stack"
}

main "$@"
