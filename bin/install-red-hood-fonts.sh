#!/usr/bin/env bash
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
# RED HOOD CYBERPUNK - FONT INSTALLER
# Install curated nerd fonts for terminals and IDEs
# ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

set -euo pipefail

FONT_DIR="${HOME}/.local/share/fonts"
TEMP_DIR="$(mktemp -d /tmp/red-hood-fonts.XXXXXX)"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

mkdir -p "${FONT_DIR}"
cd "${TEMP_DIR}"

info()  { printf '\033[0;36m%s\033[0m\n' "$*"; }
okay()  { printf '\033[0;32m%s\033[0m\n' "$*"; }

echo "🔥 RED HOOD FONT INSTALLER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

download_font() {
    local name="$1"
    local url="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${name}.zip"
    info "📦 Installing ${name} Nerd Font..."
    wget -q --show-progress "${url}"
    unzip -q "${name}.zip" -d "${FONT_DIR}/${name}"
    rm -f "${name}.zip"
    okay "✓ ${name} installed"
}

download_font GeistMono
download_font CascadiaCode
download_font FiraCode
download_font JetBrainsMono
download_font VictorMono
download_font Iosevka
download_font Mononoki
download_font Hack
download_font NerdFontsSymbolsOnly

install_local_font() {
    local name="$1"
    local src="$2"
    if [[ -f "$src" ]]; then
        info "📦 Installing bundled ${name}..."
        mkdir -p "${FONT_DIR}/${name}"
        cp "$src" "${FONT_DIR}/${name}/"
        okay "✓ ${name} installed"
    else
        info "⚠ Skipping ${name} (source not found at ${src})"
    fi
}

install_local_font "InterVariable" "${REPO_DIR}/config/quickshell/assets/fonts/inter/InterVariable.ttf"
install_local_font "MaterialSymbolsRounded" "${REPO_DIR}/config/quickshell/assets/fonts/material-design-icons/variablefont/MaterialSymbolsRounded[FILL,GRAD,opsz,wght].ttf"
install_local_font "MaterialSymbolsOutlined" "${REPO_DIR}/config/quickshell/assets/fonts/material-design-icons/variablefont/MaterialSymbolsOutlined[FILL,GRAD,opsz,wght].ttf"

info "🔄 Rebuilding font cache..."
fc-cache -fv >/dev/null 2>&1
okay "✓ Font cache rebuilt"

rm -rf "${TEMP_DIR}"

cat <<'EOF'
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
✅ ALL FONTS INSTALLED!

🎨 Available fonts:
  1. GeistMono Nerd Font (default UI)
  2. CascadiaCode Nerd Font
  3. FiraCode Nerd Font
  4. JetBrainsMono Nerd Font
  5. VictorMono Nerd Font
  6. Iosevka Nerd Font
  7. Mononoki Nerd Font
  8. Hack Nerd Font
  9. Symbols Nerd Font (icons fallback)
 10. Inter Variable (bundled)
 11. Material Symbols Rounded (bundled)
 12. Material Symbols Outlined (bundled)

📝 Usage hints:
  • Kitty : font_family GeistMono Nerd Font
  • Ghostty: font-family = \"GeistMono Nerd Font\"
  • Tmux  : already themed!

🔄 Restart your terminals to pick up changes.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
EOF
