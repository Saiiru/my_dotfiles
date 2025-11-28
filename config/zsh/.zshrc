# export PATH=$HOME/bin:/usr/local/bin:$PATH
# echo source ~/.bash_profile

# load env vars from .zprofile into the shells
[[ -f ~/.zprofile ]] && source ~/.zprofile

# Homebrew (somente se existir; útil em macOS)
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
fi

# gdircolors (GNU coreutils via brew); se não existir, ignore
if command -v gdircolors >/dev/null 2>&1; then
  eval "$(gdircolors)"
fi

# oh-my-zsh (só se estiver instalado)
if [[ -n "${ZSH:-}" && -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
fi

# unbind ctrl g in terminal
bindkey -r "^G"

# Starship 
bindkey -v
if [[ "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select" || \
      "${widgets[zle-keymap-select]#user:}" == "starship_zle-keymap-select-wrapped" ]]; then
    zle -N zle-keymap-select "";
fi
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

# Zoxide
command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"

# FZF
command -v fzf >/dev/null 2>&1 && eval "$(fzf --zsh)"

# FZF with Git right in the shell by Junegunn : check out his github below
# Keymaps for this is available at https://github.com/junegunn/fzf-git.sh
if [[ -r "$HOME/workstation/config/scripts/scripts/fzf-git.sh" ]]; then
  source "$HOME/workstation/config/scripts/scripts/fzf-git.sh"
elif [[ -r "$HOME/scripts/fzf-git.sh" ]]; then
  source "$HOME/scripts/fzf-git.sh"
fi

# Atuin Configs
export ATUIN_NOBIND="true"
if command -v atuin >/dev/null 2>&1; then
  eval "$(atuin init zsh)"
  bindkey '^r' atuin-up-search-viins
fi
#User configuration
# export MANPATH="/usr/local/man:$MANPATH"

#----- Vim Editing modes & keymaps ------ 
set -o vi

export EDITOR=nvim
export VISUAL=nvim

bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^P' up-line-or-history
bindkey -M viins '^N' down-line-or-history
#----------------------------------------

# zsh plugins
plugins=(
    git 
    ## with oh-my-zsh and not homebrew
    # zsh-autosuggestions ( git clone <find link in the repo> and uncomment  )
    # zsh-syntax-highlighting ( git clone <find link in the repo> and uncomment )
    web-search
)

# -------------------ALIAS----------------------
# These alias need to have the same exact space as written here
# HACK: For Running Go Server using Air
alias air='$(go env GOPATH)/bin/air'

# other Aliases shortcuts
alias c="clear"
alias e="exit"
alias vim="nvim"

# Tmux 
alias tmux="tmux -f $TMUX_CONF"
alias a="attach"
# calls the tmux new session script
alias tns="$HOME/workstation/config/scripts/scripts/tmux-sessionizer"

# fzf 
# called from ~/scripts/
alias nlof="$HOME/workstation/config/scripts/scripts/fzf_listoldfiles.sh"
# opens documentation through fzf (eg: git,zsh etc.)
alias fman="compgen -c | fzf | xargs man"

# zoxide (called from ~/scripts/)
alias nzo="$HOME/workstation/config/scripts/scripts/zoxide_openfiles_nvim.sh"

# Next level of an ls 
# options :  --no-filesize --no-time --no-permissions 
alias ls="eza --no-filesize --long --color=always --icons=always --no-user" 

# tree
alias tree="tree -L 3 -a -I '.git' --charset X "
alias dtree="tree -L 3 -a -d -I '.git' --charset X "

# lstr
alias lstr="lstr --icons"

# git aliases
alias gt="git"
alias ga="git add ."
alias gs="git status -s"
alias gc='git commit -m'
alias glog='git log --oneline --graph --all'
alias gh-create='gh repo create --private --source=. --remote=origin && git push -u --all && gh browse'

alias nvim-scratch="NVIM_APPNAME=nvim-scratch nvim"

# lazygit
alias lg="lazygit"

# mpd start alias
alias mpds="mpd ~/.config/mpd/mpd.conf"

# obsidian icloud path
alias sethvault="cd ~/Library/Mobile\ Documents/iCloud~md~obsidian/Documents/sethVault/"
# ---------------------------------------

# brew installations activation (new mac systems brew path: opt/homebrew , not usr/local )
# source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
if command -v brew >/dev/null 2>&1 && [[ -r "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
elif [[ -r /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Deno (desabilitado; ative se usar)
# . \"$HOME/.deno/env\"
