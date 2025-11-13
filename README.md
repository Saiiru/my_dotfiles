# Sairu's Development Environment

[![Tmux](https://img.shields.io/badge/tmux-3.4-1BB91F?style=flat&logo=tmux&logoColor=white)](https://github.com/tmux/tmux)
[![Neovim](https://img.shields.io/badge/neovim-0.10+-57A143?style=flat&logo=neovim&logoColor=white)](https://neovim.io/)
[![Zsh](https://img.shields.io/badge/zsh-5.9-4E9A06?style=flat&logo=gnu-bash&logoColor=white)](https://www.zsh.org/)
[![Kitty](https://img.shields.io/badge/kitty-0.35+-3B5998?style=flat&logo=iterm2&logoColor=white)](https://sw.kovidgoyal.net/kitty/)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

> Professional terminal-based development environment with modern tools and workflows

## ✨ Features

- **🔧 Modern Shell**: Zsh with Starship prompt and intelligent completions
- **📝 Powerful Editor**: Neovim with LSP, Treesitter, and custom colorscheme
- **🖥️ Terminal Multiplexer**: Tmux with Sesh session management
- **🎨 Consistent Theming**: Gruvbox Material across all tools
- **⚡ Performance**: Optimized for speed with lazy loading
- **📦 Version Management**: Mise for multi-language development
- **🚀 Task Runner**: Just for common workflows

## 📋 Requirements

### Core
- Git
- Zsh
- Curl/Wget

### Tools
- Neovim (≥0.10)
- Tmux (≥3.4)
- Kitty terminal
- Starship prompt
- Mise (toolchain manager)
- Just (task runner)

### Optional
- FZF, Eza, Bat, Fd, Ripgrep
- Lazygit
- Sesh (session manager)

## 🚀 Installation

```bash
# Clone repository
git clone https://github.com/Sairu/my_dotfiles.git ~/gotham
cd ~/gotham

# Run installation
./install.sh

# Reload shell
exec zsh
```

## 📁 Structure

```
gotham/
├── config/              # All configuration files
│   ├── kitty/          # Terminal emulator
│   ├── tmux/           # Terminal multiplexer
│   ├── zsh/            # Shell configuration
│   ├── nvim/           # Editor configuration
│   ├── mise/           # Toolchain manager
│   ├── waybar/         # Status bar (Wayland)
│   ├── niri/           # Compositor (Wayland)
│   └── wlogout/        # Logout menu
├── bin/                # Executable scripts
│   └── system/         # System utilities
├── themes/             # Theme files
│   ├── starship.toml  # Prompt theme
│   └── kitty/         # Terminal themes
├── wallpapers/        # Background images
├── docs/              # Documentation
├── install.sh         # Installation script
└── symlink.sh         # Symlink manager
```

## �� Customization

### Colorscheme

The environment uses a custom cyberpunk-inspired colorscheme with transparency support:

```vim
:GothamTheme              " Activate theme
:GothamTransparent toggle " Toggle transparency
:GothamBoost 1           " Adjust accent intensity (0-2)
```

### Tmux

Configuration: `config/tmux/tmux.conf`

- **Prefix**: `Ctrl-A`
- **Session Manager**: Sesh with fuzzy finding
- See `docs/TMUX_CHEATSHEET.md` for keybindings

### Zsh

Configuration: `config/zsh/`

- Modular structure with organized modules
- Znap for plugin management
- Starship for prompt

## 📚 Documentation

- [Keybindings Reference](docs/KEYBINDINGS.md) - All keyboard shortcuts
- [Tmux Guide](docs/TMUX.md) - Complete tmux documentation
- [Tmux Cheatsheet](docs/TMUX_CHEATSHEET.md) - Quick reference
- [Development Guide](docs/DEVELOPMENT.md) - Dev environment setup
- [Path Migration](docs/PATH_MIGRATION.md) - Structure changes

## 🛠️ Development

### Mise Tools

```bash
just install-dev-tools   # Install all tools
just list-tools         # List available tools
just update-dev-tools   # Update tools
```

### Just Commands

```bash
just --list             # List all commands
just install           # Install system
just test              # Run tests
just clean             # Clean caches
```

## 🔑 Key Features

### Session Management

Tmux + Sesh integration for fast project switching:
- `Ctrl-A K` - Fuzzy find sessions
- `Ctrl-A Z` - Quick switcher
- `Ctrl-A L` - Last session toggle

### Development Environment

Multi-language support via Mise:
- Python, Node.js, Go, Rust, Java
- DevOps tools: kubectl, terraform, docker-compose
- Automatic version management per project

### Workflow Automation

Just task runner with 70+ commands:
- Development tasks (build, test, lint)
- Docker operations
- Kubernetes management
- Git shortcuts

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## 📄 License

MIT License - See [LICENSE](LICENSE) file for details.

## 👤 Author

**Sairu**

- GitHub: [@Sairu](https://github.com/Sairu)
- Repository: [my_dotfiles](https://github.com/Sairu/my_dotfiles)

---

**⭐ If you find this helpful, consider giving it a star!**
