#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "$0")" && pwd)"
MODULE_DIR="$SCRIPT_DIR/modules"
REPO_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"

source "$MODULE_DIR/symlinks.sh"

create_symlinks "$REPO_DIR"
