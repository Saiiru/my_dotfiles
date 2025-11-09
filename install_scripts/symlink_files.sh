#!/usr/bin/env bash
/**
 * @file symlink_files.sh
 * @brief Cria symlinks para arquivos de configuração individuais do repositório dotfiles para o diretório HOME.
 *
 * Este script lê uma lista de caminhos de arquivos de configuração de `config_files.txt`.
 * Para cada arquivo, ele determina o caminho de origem no repositório dotfiles e o caminho de destino
 * no diretório HOME do usuário. Ele lida com a renomeação de arquivos para adicionar um ponto inicial
 * (tornando-os ocultos) e um caso especial para `.gitconfig`.
 *
 * Se um arquivo ou symlink existente for encontrado no destino, ele é removido ou movido para backup
 * antes que um novo symlink seja criado.
 */

# Configurações de segurança e robustez do script.
# -e: Sai imediatamente se um comando retornar um status de saída diferente de zero.
# -u: Trata variáveis não definidas como erro.
# -o pipefail: O status de saída de um pipeline é o status do último comando a falhar,
#              ou zero se todos os comandos forem bem-sucedidos.
set -euo pipefail

# Definição de cores para mensagens de feedback no terminal.
_cyan='\033[0;36m'; _green='\033[0;32m'; _yellow='\033[0;33m'; _red='\033[0;31m'; _reset='\033[0m'

# Funções auxiliares para exibir mensagens coloridas no terminal.
_info(){ printf "%s[INFO]%s %s\n" "$_cyan" "$_reset" "$*"; }
_success(){ printf "%s[SUCCESS]%s %s\n" "$_green" "$_reset" "$*"; }
_warn(){ printf "%s[WARN]%s %s\n" "$_yellow" "$_reset" "$*"; }
_fail(){ printf "%s[ERROR]%s %s\n" "$_red" "$_reset" "$*"; exit 1; }

# Determina o diretório do script para referenciar arquivos relativos.
dir_of_this_script="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Define o diretório raiz do repositório dotfiles, que serve como base para todos os arquivos de configuração.
dotfiles_repo_root="$HOME/dotfiles"
# Define o diretório de backup para configurações existentes.
dir_backup="$HOME/.config.backup/$(date +"%Y%m%d_%H-%M-%S")"

_info "Garantindo que o diretório de backup exista..."
# Cria o diretório de backup se não existir.
mkdir -p "$dir_backup"
_success "Diretório de backup garantido."

_info "Processando arquivos de configuração..."
# Lê cada linha do arquivo config_files.txt.
while IFS= read -r file; do
  # Remove caracteres de retorno de carro para compatibilidade entre sistemas.
  file=$(echo "$file" | tr -d '\r')

  # Ignora linhas vazias e comentários.
  if [ -z "${file}" ]; then
    continue
  fi
  if [[ -n "$file" && "$file" == \#* ]]; then
    continue
  fi

  # Determina o nome do arquivo de destino no diretório HOME.
  # O basename é usado para obter apenas o nome do arquivo, ignorando subdiretórios na entrada 'file'.
  local_filename=$(basename "$file")
  dst_filename=""

  # Lógica para adicionar um ponto inicial a arquivos que devem ser ocultos no HOME.
  case "$local_filename" in
    "tmux.conf" | "zshrc" | "zshenv" | "config")
      dst_filename=".${local_filename}"
      ;;
    *)
      dst_filename="$local_filename"
      ;;
  esac
  
  # Caso especial para o arquivo de configuração do Git, que deve ser symlinkado como .gitconfig.
  if [[ "$file" == "config_dotfiles/config/git/config" ]]; then
    dst_filename=".gitconfig"
  fi

  # Constrói o caminho completo para o destino do symlink no diretório HOME.
  path_config="$HOME/$dst_filename"
  # Constrói o caminho completo para o arquivo de configuração de origem no repositório dotfiles.
  path_dotfile="$dotfiles_repo_root/$file"

  _info "▶ Processando $file (origem: $path_dotfile, destino: $path_config)..."

  # Verifica se o arquivo de configuração de origem existe.
  if [[ ! -f "$path_dotfile" ]]; then
    _warn "⚠️  Pulando: Fonte de configuração não encontrada em $path_dotfile"
    continue
  fi

  # Se o destino já for um symlink, remove-o para recriar.
  if [[ -L "$path_config" ]]; then
    _info "🔗 Removendo symlink existente: $path_config"
    rm "$path_config"

  # Se o destino for um arquivo real (não um symlink), faz backup.
  elif [[ -f "$path_config" ]] && [[ ! -L "$path_config" ]]; then
    _info "📦 Fazendo backup do arquivo real para: $dir_backup/$dst_filename"
    mv "$path_config" "$dir_backup/$dst_filename"

  # Se não houver configuração existente, não há necessidade de backup.
  else
    _info "ℹ️  Nenhuma configuração existente em $path_config — não é necessário fazer backup"
  fi

  # Cria o symlink do arquivo de configuração.
  _info "🔗 Linkando $path_dotfile → $path_config"
  ln -sfn "$path_dotfile" "$path_config"
  _success "✅ Concluído: $file"
  echo # Adiciona uma nova linha para melhor legibilidade entre as entradas.
done < "$dir_of_this_script/config_lists/config_files.txt"
_success "Todos os arquivos de configuração processados."
