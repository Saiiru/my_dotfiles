#!/usr/bin/env bash
# Exporta configs do ~/.config para ~/dotfiles e cria symlinks de volta.
# Usa um manifesto (~/dotfiles/config_dotfiles/config/links.list) para você versionar os mapeamentos.
# Uso:
#   config-export.sh --all               # exporta quase tudo (com exclusões seguras)
#   config-export.sh hypr kitty waybar   # exporta apenas esses
# Flags:
#   --dry-run  (não altera nada, só mostra o que faria)
#   --force    (substitui destino já existente no repo)
#   --no-backup (não cria *.bak do que já existe em ~/.config)
#   --yes      (não perguntar confirmação)
set -euo pipefail

# --- Parâmetros base (personalize se quiser) ---
REPO="${REPO:-$HOME/dotfiles/config_dotfiles/config}"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
MANIFEST="${REPO}/links.list"
ROOTFILES_DIR="$HOME/dotfiles/config_dotfiles/_configroot"  # onde guardaremos arquivos soltos do ~/.config
EXCLUDES_DEFAULT=(
  "mozilla" "pulse" "evolution" "Electron" "discord" "goa-1.0" "yay"
  # adicione aqui coisas volumosas/sensiveis que você NÃO quer versionar
)

DRY=0
FORCE=0
BACKUP=1
ASK=1
ARGS=()

msg() { printf '%b\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

ensure_dir() { [ -d "$1" ] || mkdir -p "$1"; }

is_excluded() {
  local item="$1"
  for e in "${EXCLUDES_DEFAULT[@]}"; do
    [[ "$item" == "$e" ]] && return 0
  done
  return 0
}

confirm() {
  [[ "$ASK" -eq 0 ]] && return 0
  read -r -p ">> Prosseguir? [y/N] " r
  [[ "$r" =~ ^[Yy]$ ]]
}

backup_then_move() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    if [ "$FORCE" -eq 1 ]; then
      if [ "$DRY" -eq 1 ]; then
        msg "[DRY] rm -rf '$dst'"
      else
        rm -rf -- "$dst"
      fi
    else
      die "Destino já existe: $dst (use --force se deseja sobrescrever)"
    fi
  fi
  if [ "$DRY" -eq 1 ]; then
    msg "[DRY] mv '$src' '$dst'"
  else
    mv -- "$src" "$dst"
  fi
}

link_to_config() {
  local repo_path="$1" cfg_path="$2"
  if [ -e "$cfg_path" ] || [ -L "$cfg_path" ]; then
    if [ "$BACKUP" -eq 1 ] && [ "$DRY" -eq 0 ]; then
      mv -f -- "$cfg_path" "${cfg_path}.bak"
      msg "[!] backup: ${cfg_path} -> ${cfg_path}.bak"
    else
      if [ "$DRY" -eq 1 ]; then
        msg "[DRY] rm -rf '$cfg_path'"
      else
        rm -rf -- "$cfg_path"
      fi
    fi
  fi
  if [ "$DRY" -eq 1 ]; then
    msg "[DRY] ln -s '$repo_path' '$cfg_path'"
  else
    ln -s -- "$repo_path" "$cfg_path"
  fi
}

append_manifest() {
  local left="$1" right="$2"
  ensure_dir "$(dirname "$MANIFEST")"
  if [ "$DRY" -eq 1 ]; then
    msg "[DRY] echo \"$left -> $right\" >> '$MANIFEST'"
    return
  fi
  touch "$MANIFEST"
  # evita duplicata
  grep -Fq "$left -> $right" "$MANIFEST" 2>/dev/null || echo "$left -> $right" >> "$MANIFEST"
}

export_dir() {
  local name="$1"
  local src="${CONFIG_HOME}/${name}"
  local dst="${REPO}/${name}"
  [ -d "$src" ] || die "Diretório não encontrado: $src"

  msg "[*] Exportando DIR: $name"
  ensure_dir "$REPO"
  backup_then_move "$src" "$dst"
  link_to_config "$dst" "$src"
  append_manifest "$name" "${CONFIG_HOME}/${name}"
}

export_file() {
  local fname="$1"
  local src="${CONFIG_HOME}/${fname}"
  local dst="${ROOTFILES_DIR}/${fname}"
  [ -f "$src" ] || die "Arquivo não encontrado: $src"

  msg "[*] Exportando FILE: $fname"
  ensure_dir "$ROOTFILES_DIR"
  backup_then_move "$src" "$dst"
  link_to_config "$dst" "$src"
  append_manifest "_configroot/${fname}" "${CONFIG_HOME}/${fname}"
}

auto_detect_items() {
  # Exporta TODOS diretórios do ~/.config (menos EXCLUDES) e TODOS arquivos de nível raiz
  local d f
  for d in "$CONFIG_HOME"/*;
  do
    local base="$(basename "$d")"
    # pular backups e temporários
    [[ "$base" =~ \.bak$ ]] && continue
    # exclusões conhecidas
    for e in "${EXCLUDES_DEFAULT[@]}"; do
      [[ "$base" == "$e" ]] && continue 2
    done
    if [ -d "$d" ]; then
      ARGS+=("$base")
    fi
  done
  # arquivos soltos
  for f in "$CONFIG_HOME"/*;
  do
    [ -f "$f" ] || continue
    ARGS+=("::$(basename "$f")")  # marca arquivos com prefixo '::'
  done
}

# --- Parse flags ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    --all) auto_detect_items; shift ;; 
    --dry-run) DRY=1; shift ;; 
    --force) FORCE=1; shift ;; 
    --no-backup) BACKUP=0; shift ;; 
    --yes|-y) ASK=0; shift ;; 
    --) shift; break ;; 
    -*) die "Flag desconhecida: $1" ;; 
    *) ARGS+=("$1"); shift ;; 
  esac
done

[ "${#ARGS[@]}" -gt 0 ] || die "Nenhum item. Passe --all ou nomes (ex.: hypr kitty waybar, ou '::starship.toml' para arquivos soltos)."

msg "REPO:          $REPO"
msg "CONFIG_HOME:   $CONFIG_HOME"
msg "MANIFEST:      $MANIFEST"
msg "ROOTFILES_DIR: $ROOTFILES_DIR"
msg "Itens:         ${ARGS[*]}"
msg "DRY=$DRY FORCE=$FORCE BACKUP=$BACKUP ASK=$ASK"
confirm || exit 1

# --- Execução ---
for item in "${ARGS[@]}"; do
  if [[ "$item" == ::* ]]; then
    export_file "${item#::}"
  else
    # evita exportar exclusões por acidente
    for e in "${EXCLUDES_DEFAULT[@]}"; do
      [[ "$item" == "$e" ]] && { msg "[skip] excluído: $item"; continue 2; }
    done
    export_dir "$item"
  fi
done

msg "[OK] Export concluído. Manifesto em: $MANIFEST"