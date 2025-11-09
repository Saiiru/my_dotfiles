#!/usr/bin/env bash
/**
 * @file install.sh
 * @brief Orquestra todo o processo de bootstrap do ambiente de desenvolvimento e usuário.
 *
 * Este script é o ponto de entrada principal para configurar o ambiente. Ele executa
 * uma série de outros scripts em uma ordem específica para garantir que todos os
 * pacotes, Flatpaks, fontes, serviços do sistema e symlinks de configuração
 * sejam instalados e configurados corretamente.
 *
 * As etapas incluem:
 * 1. Instalação de pacotes do sistema.
 * 2. Instalação de aplicativos Flatpak.
 * 3. Instalação de fontes personalizadas.
 * 4. Habilitação de serviços systemd.
 * 5. Criação de symlinks para diretórios de configuração.
 * 6. Criação de symlinks para arquivos de configuração individuais.
 */

# Configurações de segurança e robustez do script.
# -e: Sai imediatamente se um comando retornar um status de saída diferente de zero.
# -u: Trata variáveis não definidas como erro.
# -o pipefail: O status de saída de um pipeline é o status do último comando a falhar,
#              ou zero se todos os comandos forem bem-sucedidos.
set -euo pipefail

# Definição de cores para mensagens de feedback no terminal.
cyan='\033[0;36m'; green='\033[0;32m'; yellow='\033[0;33m'; red='\033[0;31m'; reset='\033[0m'

# Funções auxiliares para exibir mensagens coloridas no terminal.
info(){ printf "%s[INFO]%s %s\n" "$cyan" "$reset" "$*"; }
success(){ printf "%s[SUCCESS]%s %s\n" "$green" "$reset" "$*"; }
warn(){ printf "%s[WARN]%s %s\n" "$yellow" "$reset" "$*"; }
fail(){ printf "%s[ERROR]%s %s\n" "$red" "$reset" "$*"; exit 1; }

# Calcula o diretório raiz do repositório dotfiles.
# Isso garante que o script possa ser executado de qualquer subdiretório
# e ainda referenciar corretamente os outros scripts e arquivos.
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DIR="$(dirname "$SCRIPT_DIR")"
cd "$DIR"

# Executa os scripts de instalação em sequência.
info "Executando package_install.sh"
./install_scripts/package_install.sh
info "Executando flatpak_install.sh"
./install_scripts/flatpak_install.sh
info "Executando install_fonts.sh"
./install_scripts/install_fonts.sh
info "Executando enable_services.sh"
./install_scripts/enable_services.sh
info "Executando symlink_configs.sh"
./install_scripts/symlink_configs.sh
info "Executando symlink_files.sh"
./install_scripts/symlink_files.sh

success "Bootstrap concluído!"
