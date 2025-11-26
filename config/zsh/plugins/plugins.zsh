# Plugins leves (autosuggestions, syntax highlighting, completions)

_zsh_plugins_dir="$XDG_DATA_HOME/zsh/plugins"
mkdir -p "$_zsh_plugins_dir"

_zsh_clone_plugin() {
  local name="$1" url="$2"
  local dir="$_zsh_plugins_dir/$name"
  if [[ ! -d "$dir" ]]; then
    git clone --depth=1 "$url" "$dir" >/dev/null 2>&1 || return 0
  fi
}

_zsh_clone_plugin "zsh-autosuggestions" "https://github.com/zsh-users/zsh-autosuggestions.git"
_zsh_clone_plugin "zsh-syntax-highlighting" "https://github.com/zsh-users/zsh-syntax-highlighting.git"
_zsh_clone_plugin "zsh-completions" "https://github.com/zsh-users/zsh-completions.git"
_zsh_clone_plugin "zsh-history-substring-search" "https://github.com/zsh-users/zsh-history-substring-search.git"

if [[ -f "$_zsh_plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh" ]]; then
  source "$_zsh_plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#555555'
fi

if [[ -f "$_zsh_plugins_dir/zsh-history-substring-search/zsh-history-substring-search.zsh" ]]; then
  source "$_zsh_plugins_dir/zsh-history-substring-search/zsh-history-substring-search.zsh"
fi

if [[ -f "$_zsh_plugins_dir/zsh-completions/zsh-completions.plugin.zsh" ]]; then
  source "$_zsh_plugins_dir/zsh-completions/zsh-completions.plugin.zsh"
fi

if [[ -f "$_zsh_plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]]; then
  source "$_zsh_plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Zoxide (cd inteligente) se disponível
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi
