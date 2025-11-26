# Ambiente base e PATH (Batman Core)

export LANG=pt_BR.UTF-8
export LC_ALL=pt_BR.UTF-8

export EDITOR="nvim"
export VISUAL="nvim"

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

path=(
  $HOME/.local/bin
  $HOME/workstation/bin
  $HOME/workstation/bin/core
  $HOME/workstation/bin/qa
  $HOME/workstation/bin/dev
  $HOME/workstation/bin/sys
  $HOME/workstation/bin/hud
  $HOME/.cargo/bin
  $HOME/go/bin
  $path
)
export PATH

HISTSIZE=20000
SAVEHIST=20000
HISTFILE="$XDG_DATA_HOME/zsh/history"

export WORKSTATION_DIR="${WORKSTATION_DIR:-$HOME/workstation}"
export BATCAVE_STATE_DIR="${XDG_STATE_HOME}/batcave"
mkdir -p "$BATCAVE_STATE_DIR"

# Java default (prefira o JDK mais recente instalado)
if [[ -z "${JAVA_HOME:-}" ]]; then
  if [[ -d /usr/lib/jvm/java-25-openjdk ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-25-openjdk
  elif [[ -d /usr/lib/jvm/java-17-openjdk ]]; then
    export JAVA_HOME=/usr/lib/jvm/java-17-openjdk
  fi
fi

if [[ -n "${JAVA_HOME:-}" ]]; then
  path=($JAVA_HOME/bin $path)
fi
