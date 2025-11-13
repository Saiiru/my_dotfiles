# Gotham Directory Structure

## Root Level
```
gotham/
├── config/          # All configuration files
├── bin/             # Executable scripts
├── themes/          # Theme and color configurations
├── wallpapers/      # Wallpaper collection
├── install.sh       # Main installation script
├── symlink.sh       # Symlink management
├── Justfile         # Command runner recipes
└── README.md        # Main documentation
```

## Config Directory
```
config/
├── kitty/          # Kitty terminal config
├── tmux/           # Tmux configuration
├── zsh/            # Zsh shell config
├── waybar/         # Waybar status bar
├── wlogout/        # Logout menu
├── niri/           # Niri compositor
├── mise/           # Mise tool versions
└── noctalia/       # Noctalia specific configs
```

## Bin Directory
```
bin/
├── battery/        # Battery management scripts
├── system/         # System utilities
├── theme/          # Theme management
└── notifications/  # Notification helpers
```

## Migration Plan
1. Consolidate config_dotfiles/* into config/
2. Move scattered scripts into bin/
3. Organize themes and starship configs into themes/
4. Clean up duplicates and backup files
5. Update symlink paths
6. Commit all tracked files
