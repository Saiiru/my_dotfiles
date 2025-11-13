# Tmux Cheatsheet - Gotham System

Quick reference for all tmux keybindings.

## 📌 Prefix Key
**ALL commands start with:** `Ctrl-A`

---

## 🎯 Quick Reference Card

```
┌─────────────────────────────────────────────────────────────────┐
│                    GOTHAM TMUX CHEATSHEET                       │
├─────────────────────────────────────────────────────────────────┤
│ PREFIX: Ctrl-A                                                  │
├─────────────────────────────────────────────────────────────────┤
│ SESSIONS                                                        │
│   K     │ Fuzzy find all sessions (Sesh)                       │
│   Z     │ Quick session switcher                               │
│   R     │ Root project sessions                                │
│   L     │ Last session toggle                                  │
│   9     │ Create/switch to pwd session                         │
│   Q     │ Kill current session                                 │
├─────────────────────────────────────────────────────────────────┤
│ WINDOWS                                                         │
│   c     │ New window (in current dir)                          │
│   &     │ Kill window                                           │
│   n     │ Next window                                           │
│   p     │ Previous window                                       │
│   0-9   │ Select window by number                              │
│   ,     │ Rename window                                         │
├─────────────────────────────────────────────────────────────────┤
│ PANES                                                           │
│   %     │ Split horizontal                                      │
│   "     │ Split vertical                                        │
│   x     │ Kill pane (no confirm)                               │
│   h     │ Move to left pane                                    │
│   j     │ Move to bottom pane                                  │
│   k     │ Move to top pane                                     │
│   l     │ Move to right pane                                   │
│   z     │ Toggle pane zoom                                     │
│   B     │ Break pane to new window                             │
│   J     │ Join pane to window 1                                │
├─────────────────────────────────────────────────────────────────┤
│ QUICK ACTIONS                                                   │
│   g     │ Open Lazygit                                          │
│   E     │ Open Nvim with file picker                           │
│   e     │ Edit pane content in Nvim                            │
├─────────────────────────────────────────────────────────────────┤
│ COPY MODE                                                       │
│   [     │ Enter copy mode                                       │
│   v     │ Begin selection (in copy mode)                       │
│   y     │ Copy selection                                        │
│   q     │ Exit copy mode                                        │
│   C-u   │ Scroll half page up                                  │
│   C-d   │ Scroll half page down                                │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔑 Detailed Keybindings

### Sessions (Sesh Integration)

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A K` | Global sessions | Fuzzy find all sessions with preview |
| `Ctrl-A Z` | Quick switch | Fast session switcher with fzf |
| `Ctrl-A R` | Root sessions | Show only root project sessions |
| `Ctrl-A L` | Last session | Toggle between last two sessions |
| `Ctrl-A 9` | Current dir | Create/switch to session in pwd |
| `Ctrl-A Q` | Kill session | Close current session |

**In Sesh finder:**
- `Ctrl-T` - Filter tmux sessions only
- `Ctrl-G` - Filter config sessions
- `Ctrl-X` - Filter zoxide directories
- `Ctrl-F` - Search filesystem
- `Enter` - Switch/create session
- `Esc` - Cancel

### Windows

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A c` | new-window | Create new window in current directory |
| `Ctrl-A &` | kill-window | Close current window (with confirm) |
| `Ctrl-A ,` | rename-window | Rename current window |
| `Ctrl-A n` | next-window | Move to next window |
| `Ctrl-A p` | previous-window | Move to previous window |
| `Ctrl-A 0-9` | select-window | Jump to window by number |
| `Ctrl-A w` | list-windows | Show window list |
| `Ctrl-A f` | find-window | Search windows by name |

### Panes

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A %` | split-horizontal | Split pane horizontally |
| `Ctrl-A "` | split-vertical | Split pane vertically |
| `Ctrl-A x` | kill-pane | Close pane (no confirmation) |
| `Ctrl-A h` | select-pane-left | Move to left pane |
| `Ctrl-A j` | select-pane-down | Move to bottom pane |
| `Ctrl-A k` | select-pane-up | Move to top pane |
| `Ctrl-A l` | select-pane-right | Move to right pane |
| `Ctrl-A z` | resize-pane-zoom | Toggle pane fullscreen |
| `Ctrl-A o` | select-next-pane | Cycle through panes |
| `Ctrl-A {` | swap-pane-up | Swap with previous pane |
| `Ctrl-A }` | swap-pane-down | Swap with next pane |
| `Ctrl-A B` | break-pane | Move pane to new window |
| `Ctrl-A J` | join-pane | Join pane to window 1 |
| `Ctrl-A !` | break-pane | Move pane to new window (alt) |
| `Ctrl-A Space` | next-layout | Cycle through layouts |

### Copy Mode (Vim-style)

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A [` | copy-mode | Enter copy/scroll mode |
| `v` | begin-selection | Start selecting text |
| `V` | select-line | Select entire line |
| `y` | copy-selection | Copy to clipboard |
| `q` | exit | Leave copy mode |
| `Esc` | cancel | Cancel selection |
| `h/j/k/l` | move | Vim navigation |
| `w` | next-word | Jump to next word |
| `b` | prev-word | Jump to previous word |
| `0` | start-of-line | Go to line start |
| `$` | end-of-line | Go to line end |
| `g` | top-of-buffer | Go to top |
| `G` | bottom-of-buffer | Go to bottom |
| `/` | search-forward | Search forward |
| `?` | search-backward | Search backward |
| `n` | next-match | Next search result |
| `N` | prev-match | Previous search result |
| `Ctrl-u` | half-page-up | Scroll up |
| `Ctrl-d` | half-page-down | Scroll down |
| `Ctrl-b` | page-up | Scroll page up |
| `Ctrl-f` | page-down | Scroll page down |

### Quick Actions (Custom)

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A g` | lazygit | Open Lazygit in new window |
| `Ctrl-A E` | nvim-picker | Open Nvim with file picker |
| `Ctrl-A e` | edit-pane | Open pane content in Nvim |

### Meta Commands

| Keys | Command | Description |
|------|---------|-------------|
| `Ctrl-A :` | command-prompt | Enter tmux command |
| `Ctrl-A ?` | list-keys | Show all keybindings |
| `Ctrl-A r` | source-file | Reload configuration |
| `Ctrl-A d` | detach | Detach from session |
| `Ctrl-A t` | clock-mode | Show clock |
| `Ctrl-A ~` | show-messages | Show tmux messages |

---

## 🎨 Visual Guide

### Pane Layouts

```
┌─────────────────────────────────────────────────────┐
│  Two Panes (Horizontal)                             │
│  Ctrl-A %                                           │
├──────────────────────┬──────────────────────────────┤
│                      │                              │
│      Editor          │       Terminal               │
│                      │                              │
└──────────────────────┴──────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│  Two Panes (Vertical)                               │
│  Ctrl-A "                                           │
├─────────────────────────────────────────────────────┤
│                   Editor                            │
├─────────────────────────────────────────────────────┤
│                   Terminal                          │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│  Four Panes (Quad)                                  │
│  Ctrl-A % then Ctrl-A " (both sides)                │
├──────────────────────┬──────────────────────────────┤
│                      │                              │
│      Editor          │       Terminal 1             │
│                      │                              │
├──────────────────────┼──────────────────────────────┤
│                      │                              │
│      Git             │       Terminal 2             │
│                      │                              │
└──────────────────────┴──────────────────────────────┘
```

---

## 🚀 Common Workflows

### 1. Start New Project Session
```bash
tmux new -s myproject
Ctrl-A c              # New window for editor
Ctrl-A c              # New window for server
Ctrl-A g              # Open lazygit
Ctrl-A 0              # Back to first window
```

### 2. Split Screen Development
```bash
Ctrl-A %              # Split horizontal
nvim .                # Open editor in left
Ctrl-A l              # Move to right pane
npm run dev           # Start dev server
```

### 3. Quick Session Switching
```bash
Ctrl-A K              # Open session finder
# Type project name
# Press Enter
Ctrl-A L              # Toggle between last 2 sessions
```

### 4. Copy from Terminal
```bash
Ctrl-A [              # Enter copy mode
# Navigate with hjkl
v                     # Start selection
# Navigate to select
y                     # Copy
q                     # Exit
# Paste with Ctrl-Shift-V
```

---

## 💡 Pro Tips

1. **Session Per Project**: Keep each project in its own session
2. **Named Windows**: Rename windows for clarity (`Ctrl-A ,`)
3. **Zoom Panes**: Use `Ctrl-A z` to focus on one pane temporarily
4. **Sesh for Speed**: Use `Ctrl-A K` to jump between projects instantly
5. **Copy Mode**: Master vim navigation in copy mode for productivity

---

## 🔧 Config Location

- **Main config**: `~/gotham/config/tmux/tmux.conf`
- **Symlink**: `~/.config/tmux → ~/gotham/config/tmux`
- **Plugins**: `~/gotham/config/tmux/plugins/`

---

## 📚 See Also

- Full Documentation: `docs/TMUX.md`
- Keybindings Reference: `docs/KEYBINDINGS.md`
- Gotham README: `README.md`

---

**Quick Access**: Save this cheatsheet and open with `bat docs/TMUX_CHEATSHEET.md`

**Author**: Sairu  
**Last Updated**: 2024-11-13  
**Gotham Version**: 2.0
