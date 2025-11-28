# Minimal Bat HUD Prompt (2 linhas, cores consistentes)
# Depende de CP_*; cai em defaults se o tema não carregou.

autoload -Uz colors vcs_info
colors
setopt prompt_subst

# fallback palette
BAT_FG="${CP_FG:-white}"
BAT_CYAN="${CP_NEON_CYAN:-cyan}"
BAT_MAG="${CP_ACC_M:-magenta}"
BAT_YEL="${CP_ACC_Y:-yellow}"
BAT_GRN="${CP_NEON_GREEN:-green}"
BAT_SOFT="${CP_FG_SOFT:-grey}"

BAT_ICON_USER="󰭟"
BAT_ICON_HOST="󰒋"
BAT_ICON_GIT=""
BAT_ICON_LAMBDA="λ"

# vcs_info (git)
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' enable            true
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr         "%F{$BAT_GRN}+%f"
zstyle ':vcs_info:git:*' unstagedstr       "%F{$BAT_YEL}!%f"
zstyle ':vcs_info:git:*' formats           '%b%u%c'
zstyle ':vcs_info:git:*' actionformats     '%b|%a%u%c'

bat_git_segment() {
  [[ -z ${vcs_info_msg_0_} ]] && return
  local untracked=""
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    if [[ $(git status --porcelain --untracked-files | grep -c '^??') -gt 0 ]]; then
      untracked="%F{$BAT_MAG}?%f"
    fi
  fi
  print -n "%F{$BAT_CYAN}-[%F{$BAT_CYAN}${BAT_ICON_GIT}%f %F{$BAT_FG}${vcs_info_msg_0_}${untracked}%F{$BAT_CYAN}]%f"
}

# Stack detection (cwd only, lightweight)
bat_stack_segment() {
  local stack=""
  local ccver
  if [[ -f pom.xml || -f build.gradle || -f build.gradle.kts ]]; then
    stack=" Java $(java -version 2>&1 | head -n1 | awk '{print $3}')"
  elif [[ -f package.json ]]; then
    stack="󰎙 Node $(node -v 2>/dev/null | sed 's/^v//')"
  elif [[ -f go.mod ]]; then
    stack="󰟓 Go $(go version 2>/dev/null | awk '{print $3}')"
  elif [[ -f Cargo.toml ]]; then
    stack=" Rust $(rustc --version 2>/dev/null | awk '{print $2}')"
  elif [[ -f pyproject.toml || -f requirements.txt || -d .venv ]]; then
    stack=" Python $(python -c 'import platform;print(platform.python_version())' 2>/dev/null)"
  elif [[ -f docker-compose.yml || -f compose.yaml || -f Dockerfile ]]; then
    stack=" Docker"
  elif [[ -f CMakeLists.txt || -f meson.build || -f Makefile ]]; then
    ccver=$(cc --version 2>/dev/null | head -n1 | awk '{print $3}')
    stack=" C/C++${ccver:+ $ccver}"
  else
    setopt localoptions null_glob
    for f in *.sql(N.); do
      stack=" SQL"
      break
    done
    unsetopt null_glob
  fi
  [[ -z "$stack" ]] && return
  print -n "%F{$BAT_CYAN}-[%F{$BAT_CYAN}${stack}%F{$BAT_CYAN}]%f"
}

precmd() { vcs_info }

PROMPT=$'%F{'$BAT_CYAN'}┌──(%F{'$BAT_FG'}%n%F{'$BAT_MAG'}'$BAT_ICON_USER'%F{'$BAT_FG'}%m%F{'$BAT_CYAN'})-[%F{'$BAT_FG'}%~%F{'$BAT_CYAN'}]%f'\
'$(bat_git_segment)'\
'$(bat_stack_segment)'$'\n'\
$'%F{'$BAT_CYAN'}└─%F{'$BAT_GRN'}'$BAT_ICON_LAMBDA'%f '

RPROMPT='%F{'$BAT_SOFT'}%*%f'
