#!/usr/bin/env bash
set -euo pipefail

dir="$HOME/workstation/install"

"$dir/install_core.sh"
"$dir/install_dev_python.sh"
"$dir/install_dev_java.sh"
"$dir/install_dev_go.sh"

echo "\n[ALL] Instalação completa. Reabra o shell ou recarregue o zshrc."
