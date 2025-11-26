# Paleta Penumbra Cyberpunk · Batman Night Ops

if ! typeset -f colors >/dev/null 2>&1; then
  autoload -Uz colors
  colors
fi

export CP_BG="#050814"
export CP_BG_ALT="#090f1a"
export CP_PANEL="#0b101f"
export CP_PANEL_ALT="#101528"

export CP_FG="#e6f1ff"
export CP_FG_SOFT="#a7b9d6"

export CP_NEON_GREEN="#5ff5b0"
export CP_NEON_CYAN="#5ad1ff"
export CP_NEON_MAGENTA="#ff66cc"
export CP_NEON_YELLOW="#ffd75f"

export CP_RED="#ff4d73"
export CP_ORANGE="#ff8b48"
export CP_BLUE="#3f8cff"

export CP_ACCENT_WARN="#ffb347"
export CP_ACCENT_OK="#4af29c"
export CP_ACCENT_INFO="#3fb5ff"

export CP_BORDER="#1c2435"
export CP_BORDER_SOFT="#161c2a"

export CP_BLACK_SOFT="#02040a"
export CP_GRAY_DARK="#1c2230"
export CP_GRAY="#262d3c"
export CP_GRAY_LIGHT="#505b73"

export BATCAVE_MODE="${BATCAVE_MODE:-DEV}"
