# Minimal .zprofile for Arch (no Homebrew)
export LANG=en_US.UTF-8
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Paths
export PATH="$HOME/scripts:$HOME/.local/share/nvim/mason/bin:$PATH"
# Tmux conf
export TMUX_CONF="$HOME/.config/tmux/tmux.conf"
# Starship
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
# Tealdeer
export TEALDEER_CONFIG_DIR="$HOME/.config/tealdeer/"
# Oh-my-zsh base dir (apenas se instalado)
export ZSH="$HOME/.oh-my-zsh"
# FZF defaults
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git "
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"
