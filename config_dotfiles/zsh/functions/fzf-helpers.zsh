# utilitários com FZF
emulate -L zsh
unsetopt extendedglob bareglobqual kshglob
setopt pipefail

ff() { local f; f=$(fd --type f --hidden --follow --exclude .git | fzf) || return; ${EDITOR:-nvim} -- "$f"; }
fcd(){ local d; d=$(fd --type d --hidden --follow --exclude .git | fzf) || return; cd -- "$d"; }
fkill(){ local pid; pid=$(ps -e -o pid,comm | awk 'NR>1' | fzf | awk '{print $1}') || return; kill -9 "$pid"; }
gcb(){ local b; b=$(git for-each-ref --format='%(refname:short)' refs/heads/ | fzf) || return; git checkout "$b"; }
mkcd(){ mkdir -p -- "$1" && cd -- "$1"; }
extract(){ local f="$1"; case "$f" in
  *.tar.bz2) tar xjf "$f";; *.tar.gz) tar xzf "$f";; *.bz2) bunzip2 "$f";; *.rar) unrar x "$f";;
  *.gz) gunzip "$f";; *.tar) tar xf "$f";; *.tbz2) tar xjf "$f";; *.tgz) tar xzf "$f";; *.zip) unzip "$f";;
  *.7z) 7z x "$f";; *) echo "formato não suportado";; esac }
