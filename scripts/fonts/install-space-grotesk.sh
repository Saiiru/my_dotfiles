#!/usr/bin/env bash
# Instala Space Grotesk no diretório de fontes do usuário
set -euo pipefail

FONT_NAME="Space Grotesk"
FONT_SLUG="space-grotesk"
TMP_DIR="$(mktemp -d)"
FONT_DIR="${HOME}/.local/share/fonts/${FONT_SLUG}"

echo "[fonts] Instalando ${FONT_NAME} em ${FONT_DIR}"
mkdir -p "${FONT_DIR}"

curl -L "https://fonts.google.com/download?family=Space%20Grotesk" -o "${TMP_DIR}/${FONT_SLUG}.zip"

if command -v bsdtar >/dev/null 2>&1; then
  bsdtar -xf "${TMP_DIR}/${FONT_SLUG}.zip" -C "${FONT_DIR}"
else
  unzip -o "${TMP_DIR}/${FONT_SLUG}.zip" -d "${FONT_DIR}"
fi

fc-cache -f "${FONT_DIR}"
echo "[fonts] ${FONT_NAME} instalada."
