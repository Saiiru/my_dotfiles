Red Hood + Dank Material Shell Palettes
======================================

* `colors.json`: default Red Hood cyberpunk palette applied on login.
* `colors-kora-neon.json`: alternative cyan→purple “Kora Neon” palette.

Use the helpers:

```bash
qs ipc call colorpalette load "$HOME/dotfiles/config/quickshell/dms/colors.json"
qs ipc call colorpalette apply
```

or swap to Kora Neon:

```bash
qs ipc call colorpalette load "$HOME/dotfiles/config/quickshell/dms/colors-kora-neon.json"
qs ipc call colorpalette apply
```

Wallpaper workflow (`dotfiles/bin/dms-wall-apply`) extracts colors with matugen first; keep these JSON palettes as fallbacks for manual overrides or offline sessions.
