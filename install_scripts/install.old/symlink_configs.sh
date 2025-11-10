#!/usr/bin/env bash
# @file symlink_configs.sh
# @brief Cria symlinks para diretórios de configuração do repositório dotfiles para ~/.config/.
#
# Este script lê uma lista de nomes de diretórios de configuração de `config_dirs.txt`.
# Para cada diretório, ele verifica se a fonte existe no repositório dotfiles.
# Se existir, ele remove qualquer symlink ou move qualquer diretório existente no destino
# (`~/.config/`) para um diretório de backup e, em seguida, cria um novo symlink.
#
# O objetivo é manter as configurações organizadas no repositório e facilmente implantáveis.

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

# Define o diretório base onde os diretórios de configuração estão localizados no repositório dotfiles.
dir_dotfiles="$HOME/dotfiles/config_dotfiles/config"
# Define o diretório de destino padrão para os symlinks de configuração.
dir_config="$HOME/.config"
# Define o diretório de backup para configurações existentes.
dir_backup="$HOME/.config.backup/$(date +"%Y%m%d_%H-%M-%S")"

# Configuração padrão para o Waybar, caso seja necessário um caminho específico.
default_dotfile_waybar="$dir_dotfiles/waybar"

_info "Garantindo que os diretórios de destino existam..."
# Cria os diretórios de configuração e backup se não existirem.
mkdir -p "$dir_config"
mkdir -p "$dir_backup"
_success "Diretórios de destino garantidos."

_info "Processando diretórios de configuração..."
# Lê cada linha do arquivo config_dirs.txt.
while IFS= read -r directory; do
  # Remove caracteres de retorno de carro para compatibilidade entre sistemas.
  directory=$(echo "$directory" | tr -d '\r')

  # Ignora linhas vazias e comentários.
  if [ -z "$directory" ] || [[ "$directory" == \#* ]]; then
    continue
  fi

  # Constrói o caminho completo para o destino do symlink.
  path_config="$dir_config/$directory"
  path_dotfile=""

  # Lógica para casos especiais de caminhos de origem, como o Waybar.
  case "$directory" in
    waybar)
      if [[ -d "$default_dotfile_waybar" ]]; then
        path_dotfile="$default_dotfile_waybar"
      else
        _warn "⚠️  Caminho padrão do Waybar não encontrado em $default_dotfile_waybar, usando $dir_dotfiles/$directory"
        path_dotfile="$dir_dotfiles/$directory"
      fi
      ;;
    *)
      path_dotfile="$dir_dotfiles/$directory"
      ;;
  esac

  _info "▶ Processando $directory..."

  # Verifica se o diretório de configuração de origem existe.
  if [[ ! -d "$path_dotfile" ]]; then
    _warn "⚠️  Pulando: Fonte de configuração não encontrada em $path_dotfile"
    continue
  fi

  # Se o destino já for um symlink, remove-o para recriar.
  if [[ -L "$path_config" ]]; then
    _info "🔗 Removendo symlink existente: $path_config"
    rm "$path_config"

  # Se o destino for um diretório real (não um symlink), faz backup.
  elif [[ -d "$path_config" ]] && [[ ! -L "$path_config" ]]; then
    _info "📦 Fazendo backup do diretório real para: $dir_backup/$directory"
    mv "$path_config" "$dir_backup/$directory"

  # Se não houver configuração existente, não há necessidade de backup.
  else
    _info "ℹ️  Nenhuma configuração existente em $path_config — não é necessário fazer backup"
  fi

  # Cria o symlink do diretório de configuração.
  _info "🔗 Linkando $path_dotfile → $path_config"
  ln -sfn "$path_dotfile" "$path_config"
  _success "✅ Concluído: $directory"
  echo # Adiciona uma nova linha para melhor legibilidade entre as entradas.
done < "$dir_of_this_script/config_lists/config_dirs.txt"
_success "Todos os diretórios de configuração processados."
