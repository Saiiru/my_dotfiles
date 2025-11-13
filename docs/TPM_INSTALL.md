# TPM Installation Guide

Quick guide to install Tmux Plugin Manager.

## 📦 Installation

```bash
# Clone TPM to standard location
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

## 🚀 Usage

### Inside Tmux

1. Start tmux: `tmux`
2. Install plugins: `Ctrl-A I` (capital I)
3. Update plugins: `Ctrl-A U`
4. Remove plugins: `Ctrl-A alt+u`

### Commands

- `Ctrl-A I` - Install plugins
- `Ctrl-A U` - Update plugins  
- `Ctrl-A alt+u` - Remove/uninstall plugins not in config

## ✅ Verification

After installation, restart tmux:
```bash
tmux kill-server  # Kill all sessions
tmux              # Start fresh
```

Plugins should load automatically.

## 🔌 Installed Plugins

- `tmux-fzf-url` - Open URLs with fuzzy finder
- `tmux-nerd-font-window-name` - Nerd Font icons in window names
- `vim-tmux-navigator` - Seamless vim/tmux navigation
- `tmux-sessionx` - Enhanced session management
- `tmux-floax` - Floating windows

## 🐛 Troubleshooting

### Plugins not loading

1. Check TPM is installed:
   ```bash
   ls ~/.tmux/plugins/tpm
   ```

2. Check tmux config:
   ```bash
   tmux show-option -g @plugin
   ```

3. Reload config:
   ```bash
   tmux source ~/.config/tmux/tmux.conf
   ```

4. Install plugins:
   ```bash
   Ctrl-A I
   ```

### TPM command not working

Make sure you're pressing:
- `Ctrl-A` (prefix) then release
- `Shift-I` (capital I)

---

**Location**: `~/.tmux/plugins/tpm`  
**Config**: `~/.config/tmux/tmux.conf`
