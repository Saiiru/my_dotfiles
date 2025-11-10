export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export ZDOTDIR="~/dotfiles/config_dotfiles/zsh"

export PATH="$HOME/.local/bin:$PATH"

export HISTFILE="$HOME/.zsh_history"
if [[ -o interactive ]]; then
      source "$ZDOTDIR/.zshrc"
    fi
export EDITOR="nvim"
export VISUAL="nvim"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"
