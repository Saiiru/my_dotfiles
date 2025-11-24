# Aliases DRAGON-OPS

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons'
  alias ll='eza -lah --icons'
  alias la='eza -a --icons'
else
  alias ls='ls --color=auto'
  alias ll='ls -alF'
  alias la='ls -A'
fi

if command -v bat >/dev/null 2>&1; then
  alias cat='bat'
fi

alias gs='git status -sb'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gl='git log --oneline --graph --decorate'
alias gfp='git fetch --prune'

alias d='docker'
alias dc='docker compose'
alias k='kubectl'
alias kctx='kubectl config use-context'
alias kns='kubectl config set-context --current --namespace'

# Dev helpers
alias bdev='bat_dev'

alias mvncf='mvn clean package -DskipTests=false'
alias mvncp='mvn clean package -DskipTests'
alias mvnt='mvn test'
alias sb-run='mvn spring-boot:run'

alias nr='npm run'
alias ni='npm install'
alias nx='npx'
alias nrdev='npm run dev'
alias nrb='npm run build'

alias gob='go build ./...'
alias got='go test ./...'

alias cbuild='cargo build'
alias ctest='cargo test'

alias py='python'
alias pytest='pytest -q'

alias htget='http --verbose'
alias curlj='curl -H "Content-Type: application/json"'

alias ..='cd ..'
alias ...='cd ../..'
alias cproj='cd "$WORKSTATION_DIR"'
alias cls='clear'
