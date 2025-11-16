#!/usr/bin/env bash
set -euo pipefail
REPO_DIR="${1:-$(cd -- "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
source "$REPO_DIR/install/modules/symlinks.sh"
create_symlinks "$REPO_DIR"
