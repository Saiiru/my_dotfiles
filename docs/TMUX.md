# Tmux Configuration Guide

Complete guide for Gotham's tmux setup.

## 🎯 Overview

Terminal multiplexer with Gruvbox Material theme, vim-style navigation, and sesh integration.

## ⚙️ Features

- **Prefix**: `Ctrl-A` (more ergonomic than Ctrl-B)
- **Theme**: Gruvbox Material with Nerd Font icons
- **Session Manager**: Sesh integration with fuzzy finding
- **Vim Navigation**: hjkl pane navigation
- **Mouse Support**: Full mouse support enabled
- **Smart Defaults**: 1M history, instant escape time, current path for new windows

## 🔑 Key Bindings

### Prefix Key
`Ctrl-A` - All tmux commands start with this

### Sessions (with Sesh)
| Key | Action | Description |
|-----|--------|-------------|
| `K` | Global sessions | Fuzzy find all sessions with preview |
| `Z` | Quick switch | Fast session switcher |
| `R` | Root sessions | Switch to root project sessions |
| `L` | Last session | Toggle between last two sessions |
| `9` | Current dir session | Create/switch to session in pwd |
| `Q` | Kill session | Kill current session |

### Windows
| Key | Action | Description |
|-----|--------|-------------|
| `c` | New window | Create window in current dir |
| `&` | Kill window | Close current window |
| `n` | Next window | Move to next window |
| `p` | Previous window | Move to previous window |
| `0-9` | Select window | Jump to window by number |
| `,` | Rename window | Set window name |

### Panes
| Key | Action | Description |
|-----|--------|-------------|
| `"` | Split vertical | Split pane vertically (in current dir) |
| `%` | Split horizontal | Split pane horizontally (in current dir) |
| `x` | Kill pane | Close pane (no confirmation) |
| `h/j/k/l` | Navigate | Vim-style pane navigation |
| `B` | Break pane | Move pane to new window |
| `J` | Join pane | Join pane to window 1 |
| `z` | Zoom pane | Toggle pane fullscreen |

### Quick Actions
| Key | Action | Description |
|-----|--------|-------------|
| `g` | Lazygit | Open lazygit in new window |
| `E` | Editor | Open nvim with file picker |
| `e` | Edit pane | Open pane content in nvim |

### Copy Mode
| Key | Action | Description |
|-----|--------|-------------|
| `[` | Enter copy mode | Start scrolling/copying |
| `v` | Begin selection | Start selecting text (vim-style) |
| `y` | Copy selection | Copy to clipboard |
| `q` | Exit | Leave copy mode |
| `C-h/j/k/l` | Navigate | Vim navigation in copy mode |

## 🎨 Theme

### Colors (Gruvbox Material)
- Background: `#32302F`
- Foreground: `#d4be98`
- Accent colors: Red, Green, Yellow, Blue, Magenta, Cyan

### Status Bar
- **Position**: Top (change in config if needed)
- **Left**: Session name with rounded borders
- **Center**: Window list
- **Right**: Hostname with rounded borders

### Window List
- **Active**: Highlighted with colored borders
- **Inactive**: Muted colors
- **Separator**: Window number:name format

## 🔌 Plugins

### TPM (Tmux Plugin Manager)
**Installation**:
```bash
git clone https://github.com/tmux-plugins/tpm ~/gotham/config/tmux/plugins/tpm
```

**Install plugins**: `Prefix + I`
**Update plugins**: `Prefix + U`
**Remove plugins**: `Prefix + alt + u`

### Active Plugins

1. **vim-tmux-navigator** - Seamless vim/tmux navigation
2. **tmux-sessionx** - Enhanced session management
3. **tmux-floax** - Floating windows support

## 📦 Dependencies

### Required
- `tmux` - Terminal multiplexer
- `sesh` - Session manager
- `fzf` - Fuzzy finder
- `fd` - File finder

### Optional
- `lazygit` - Git TUI
- `nvim` - Text editor
- Nerd Font - For icons

### Install Dependencies
```bash
# Arch Linux
sudo pacman -S tmux fzf fd

# Sesh (via mise or cargo)
mise install sesh
# OR
cargo install sesh
```

## 🚀 Usage

### Starting Tmux
```bash
tmux                    # Start new session
tmux new -s name        # Named session
tmux attach             # Attach to existing
tmux a -t name          # Attach to named session
```

### With Sesh
```bash
# Inside tmux, press Ctrl-A then K
# Fuzzy find and switch sessions
# Use Ctrl-T/G/X/F to filter by type
```

### Session Workflow
1. Press `Ctrl-A K` to open session finder
2. Type to fuzzy search projects/sessions
3. Use `Ctrl-T` for tmux sessions only
4. Use `Ctrl-X` for zoxide directories
5. Press Enter to switch/create session

### Common Workflows

#### 1. Development Session
```bash
tmux new -s dev         # Create dev session
Ctrl-A c                # New window
Ctrl-A g                # Open lazygit
Ctrl-A E                # Open editor
Ctrl-A %                # Split pane
```

#### 2. Multiple Projects
```bash
# Inside tmux
Ctrl-A K                # Open session finder
# Type project name
# Enter to create/switch
Ctrl-A L                # Toggle between last 2
```

#### 3. Copy Mode
```bash
Ctrl-A [                # Enter copy mode
C-u / C-d               # Scroll half page
v                       # Start selection
y                       # Copy
q                       # Exit
```

## 🛠️ Configuration

### Location
`~/.config/tmux/tmux.conf` → `~/gotham/config/tmux/tmux.conf`

### Customize Theme
Edit color variables in `tmux.conf`:
```bash
RED="#ea6962"
GREEN="#a9b665"
# ... etc
```

### Change Status Position
Uncomment in config:
```bash
set-option -g status-position bottom
```

### Add Custom Bindings
```bash
bind-key "KEY" COMMAND
```

## 🔧 Integration with Gotham

### Mise Integration
Tmux automatically uses tools from mise:
- Language servers in panes
- Project-specific tools
- Version-managed runtimes

### Zsh Integration
- Shares history with zsh
- Same aliases available
- Starship prompt works

### Nvim Integration
- Seamless navigation (vim-tmux-navigator)
- Copy/paste integration
- Terminal within tmux works perfectly

## 📊 Status Bar Elements

### Left Section
- Session name with icon
- Git status (if in git repo)

### Center Section
- Window list with numbers
- Active window highlighted
- Window names

### Right Section
- Hostname
- Time (optional)

## 🎓 Tips & Tricks

### 1. Quick Session Management
- Keep related projects in separate sessions
- Use sesh to quickly jump between them
- Name sessions meaningfully

### 2. Window Organization
- One window per major task
- Use panes for related sub-tasks
- Rename windows for clarity

### 3. Pane Layouts
```bash
# Two panes (editor + terminal)
Ctrl-A %                # Split horizontal

# Three panes (editor + 2 terminals)
Ctrl-A %                # Split horizontal
Ctrl-A "                # Split right pane vertical

# Four panes (quad layout)
Ctrl-A %                # Split horizontal
Ctrl-A "                # Split right vertical
Ctrl-A h                # Go left
Ctrl-A "                # Split left vertical
```

### 4. Copy to System Clipboard
```bash
# In copy mode
v                       # Select
y                       # Copy (automatic with set-clipboard on)
```

### 5. Synchronized Panes
```bash
# Type in all panes at once
Ctrl-A :setw synchronize-panes
# Toggle off
Ctrl-A :setw synchronize-panes off
```

## 🐛 Troubleshooting

### Colors Not Working
```bash
# Check terminal
echo $TERM              # Should be xterm-256color

# Set in shell
export TERM=xterm-256color
```

### Mouse Not Working
```bash
# Check tmux version
tmux -V                 # Should be 2.1+

# Reload config
Ctrl-A :source-file ~/.config/tmux/tmux.conf
```

### Plugins Not Loading
```bash
# Install TPM
git clone https://github.com/tmux-plugins/tpm ~/gotham/config/tmux/plugins/tpm

# Inside tmux
Ctrl-A I                # Install plugins
```

### Sesh Not Found
```bash
# Install via mise
mise install sesh

# Or cargo
cargo install sesh

# Check if in PATH
which sesh
```

## 📚 Resources

- [Tmux Manual](https://man.openbsd.org/tmux.1)
- [Sesh Documentation](https://github.com/joshmedeski/sesh)
- [TPM GitHub](https://github.com/tmux-plugins/tpm)
- [Gruvbox Material](https://github.com/sainnhe/gruvbox-material)

---

**Last Updated**: 2024-11-13  
**Gotham Version**: 2.0
