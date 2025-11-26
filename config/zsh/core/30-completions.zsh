# Completion com cache em XDG

autoload -Uz compinit
_zcomp_dir="$XDG_CACHE_HOME/zsh"
mkdir -p "$_zcomp_dir"

if [[ ! -f "$_zcomp_dir/zcompdump" ]]; then
  compinit -C -d "$_zcomp_dir/zcompdump"
else
  compinit -d "$_zcomp_dir/zcompdump"
fi

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' squeeze-slashes true

# Se LS_COLORS estiver definido, aplica às listas de completion
if [[ -n "$LS_COLORS" ]]; then
  zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
fi
