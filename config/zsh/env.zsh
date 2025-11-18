export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

export PATH="$XDG_BIN_HOME:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH="$HOME/go"
export PATH="$GOPATH/bin:$PATH"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"
export PATH="$PNPM_HOME:$PATH"

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

export XDG_SESSION_TYPE="wayland"
export XDG_CURRENT_DESKTOP="niri"
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland"
export SDL_VIDEODRIVER="wayland"
export CLUTTER_BACKEND="wayland"

export MANGOHUD=1
export MANGOHUD_CONFIG="$XDG_CONFIG_HOME/mangohud/MangoHud.conf"

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

export LESS="-R"
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

export DOTNET_CLI_TELEMETRY_OPTOUT=1
export NEXT_TELEMETRY_DISABLED=1
