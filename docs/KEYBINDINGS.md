# Gotham System - Keybindings Reference

Complete reference of all keyboard shortcuts and keymaps.

## 📑 Table of Contents

- [ZSH Line Editor (ZLE)](#zsh-line-editor-zle)
- [Tmux](#tmux)
- [Kitty Terminal](#kitty-terminal)
- [FZF Fuzzy Finder](#fzf-fuzzy-finder)
- [Niri Compositor](#niri-compositor)

---

## ZSH Line Editor (ZLE)

### Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+A` | beginning-of-line | Move to start of line |
| `Ctrl+E` | end-of-line | Move to end of line |
| `Ctrl+B` / `←` | backward-char | Move back one character |
| `Ctrl+F` / `→` | forward-char | Move forward one character |
| `Alt+B` | backward-word | Move back one word |
| `Alt+F` | forward-word | Move forward one word |

### Editing
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+K` | kill-line | Delete from cursor to end of line |
| `Ctrl+U` | kill-whole-line | Delete entire line |
| `Ctrl+W` | backward-kill-word | Delete word before cursor |
| `Alt+D` | kill-word | Delete word after cursor |
| `Ctrl+Y` | yank | Paste last killed text |
| `Ctrl+_` | undo | Undo last change |

### History
| Key | Action | Description |
|-----|--------|-------------|
| `↑` | history-substring-search-up | Search history backwards (matching) |
| `↓` | history-substring-search-down | Search history forwards (matching) |
| `Ctrl+R` | history-incremental-search-backward | Fuzzy history search |
| `Ctrl+P` | up-line-or-history | Previous command |
| `Ctrl+N` | down-line-or-history | Next command |

### Completion
| Key | Action | Description |
|-----|--------|-------------|
| `Tab` | expand-or-complete | Trigger completion |
| `Shift+Tab` | reverse-menu-complete | Navigate completions backwards |
| `Ctrl+Space` | autosuggest-accept | Accept suggestion |
| `→` | forward-char / accept-suggestion | Accept suggestion at end of line |

### Special
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+L` | clear-screen | Clear terminal |
| `Ctrl+D` | delete-char-or-list / exit | Delete char or exit shell |
| `Ctrl+C` | send-break | Cancel current command |
| `Ctrl+Z` | suspend | Suspend current process |
| `!!` | last-command | Repeat last command |
| `!$` | last-argument | Last argument of previous command |

---

## Tmux

### Prefix Key
**Default:** `Ctrl+B`  
All tmux commands start with the prefix key.

### Session Management
| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + $` | rename-session | Rename current session |
| `Prefix + d` | detach | Detach from session |
| `Prefix + s` | choose-tree | Session selector |
| `Prefix + (` | switch-previous-session | Previous session |
| `Prefix + )` | switch-next-session | Next session |

### Window Management
| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + c` | new-window | Create new window |
| `Prefix + ,` | rename-window | Rename window |
| `Prefix + &` | kill-window | Close window |
| `Prefix + n` | next-window | Next window |
| `Prefix + p` | previous-window | Previous window |
| `Prefix + 0-9` | select-window | Select window by number |
| `Prefix + w` | choose-window | Window selector |

### Pane Management
| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + %` | split-window-horizontal | Split pane horizontally |
| `Prefix + "` | split-window-vertical | Split pane vertically |
| `Prefix + x` | kill-pane | Close pane |
| `Prefix + o` | select-pane-next | Next pane |
| `Prefix + ;` | select-pane-previous | Previous pane |
| `Prefix + ↑/↓/←/→` | select-pane | Navigate panes |
| `Prefix + {` | swap-pane-up | Move pane up |
| `Prefix + }` | swap-pane-down | Move pane down |
| `Prefix + z` | resize-pane-zoom | Toggle pane zoom |
| `Prefix + Space` | next-layout | Cycle layouts |

### Copy Mode
| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + [` | copy-mode | Enter copy mode |
| `Space` | begin-selection | Start selection |
| `Enter` | copy-selection | Copy selection |
| `q` | quit | Exit copy mode |
| `/` | search-forward | Search forward |
| `?` | search-backward | Search backward |

### Other
| Key | Action | Description |
|-----|--------|-------------|
| `Prefix + ?` | list-keys | Show all keybindings |
| `Prefix + :` | command-prompt | Enter command |
| `Prefix + t` | clock-mode | Show clock |
| `Prefix + r` | source-file | Reload config |

---

## Kitty Terminal

### Tabs
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift+T` | new_tab | New tab |
| `Ctrl+Shift+Q` | close_tab | Close tab |
| `Ctrl+Shift+→` | next_tab | Next tab |
| `Ctrl+Shift+←` | previous_tab | Previous tab |
| `Ctrl+Shift+.` | move_tab_forward | Move tab right |
| `Ctrl+Shift+,` | move_tab_backward | Move tab left |
| `Ctrl+Shift+Alt+T` | set_tab_title | Rename tab |

### Windows
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift+Enter` | new_window | New window |
| `Ctrl+Shift+W` | close_window | Close window |
| `Ctrl+Shift+]` | next_window | Next window |
| `Ctrl+Shift+[` | previous_window | Previous window |
| `Ctrl+Shift+F` | move_window_forward | Move window forward |
| `Ctrl+Shift+B` | move_window_backward | Move window backward |

### Layouts
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift+L` | next_layout | Cycle layouts |
| `Ctrl+Shift+R` | start_resizing_window | Resize mode |

### Scrolling
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift+↑` | scroll_line_up | Scroll up |
| `Ctrl+Shift+↓` | scroll_line_down | Scroll down |
| `Ctrl+Shift+Page Up` | scroll_page_up | Page up |
| `Ctrl+Shift+Page Down` | scroll_page_down | Page down |
| `Ctrl+Shift+Home` | scroll_home | Scroll to top |
| `Ctrl+Shift+End` | scroll_end | Scroll to bottom |

### Font Size
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift++` | increase_font_size | Increase font |
| `Ctrl+Shift+-` | decrease_font_size | Decrease font |
| `Ctrl+Shift+Backspace` | restore_font_size | Reset font size |

### Other
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+Shift+C` | copy_to_clipboard | Copy |
| `Ctrl+Shift+V` | paste_from_clipboard | Paste |
| `Ctrl+Shift+U` | input_unicode_character | Unicode input |
| `Ctrl+Shift+F11` | toggle_fullscreen | Toggle fullscreen |
| `Ctrl+Shift+F2` | edit_config_file | Edit config |

---

## FZF Fuzzy Finder

### Search Navigation
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+J` / `↓` | down | Move down |
| `Ctrl+K` / `↑` | up | Move up |
| `Ctrl+D` | half-page-down | Scroll down |
| `Ctrl+U` | half-page-up | Scroll up |
| `Page Down` | page-down | Page down |
| `Page Up` | page-up | Page up |

### Selection
| Key | Action | Description |
|-----|--------|-------------|
| `Enter` | accept | Select item |
| `Tab` | toggle | Toggle selection (multi) |
| `Shift+Tab` | toggle-up | Toggle and move up |
| `Alt+A` | select-all | Select all |
| `Alt+D` | deselect-all | Deselect all |

### Search Control
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+/` | toggle-preview | Show/hide preview |
| `Ctrl+R` | toggle-sort | Toggle sorting |
| `Ctrl+T` | toggle-all | Toggle all selections |
| `Alt+Enter` | print-query | Print query |

### Preview
| Key | Action | Description |
|-----|--------|-------------|
| `Shift+↑` | preview-up | Scroll preview up |
| `Shift+↓` | preview-down | Scroll preview down |
| `Ctrl+U` | preview-half-page-up | Preview page up |
| `Ctrl+D` | preview-half-page-down | Preview page down |

### Shell Integration
| Key | Action | Description |
|-----|--------|-------------|
| `Ctrl+T` | fzf-file-widget | File selector |
| `Ctrl+R` | fzf-history-widget | History search |
| `Alt+C` | fzf-cd-widget | Directory selector |

---

## Niri Compositor

### Window Management
| Key | Action | Description |
|-----|--------|-------------|
| `Super+Return` | spawn terminal | Open terminal |
| `Super+Q` | close-window | Close window |
| `Super+H` | focus-left | Focus window left |
| `Super+J` | focus-down | Focus window down |
| `Super+K` | focus-up | Focus window up |
| `Super+L` | focus-right | Focus window right |

### Workspaces
| Key | Action | Description |
|-----|--------|-------------|
| `Super+1-9` | workspace | Switch to workspace |
| `Super+Shift+1-9` | move-to-workspace | Move window to workspace |
| `Super+Tab` | workspace-next | Next workspace |
| `Super+Shift+Tab` | workspace-previous | Previous workspace |

### Layout
| Key | Action | Description |
|-----|--------|-------------|
| `Super+F` | fullscreen | Toggle fullscreen |
| `Super+Space` | floating | Toggle floating |
| `Super+M` | maximize | Maximize window |

### System
| Key | Action | Description |
|-----|--------|-------------|
| `Super+Shift+E` | exit | Exit compositor |
| `Super+Shift+R` | reload | Reload config |
| `Super+L` | lock | Lock screen |

---

## Custom Aliases & Functions

These are custom shortcuts defined in `config/zsh/aliases.zsh` and `config/zsh/functions.zsh`.

### Quick Commands
| Alias | Command | Description |
|-------|---------|-------------|
| `l` | eza -la | List all files |
| `ll` | eza -l | List files (long) |
| `lt` | eza --tree | Tree view |
| `c` | clear | Clear screen |
| `q` | exit | Exit shell |
| `..` | cd .. | Parent directory |
| `...` | cd ../.. | Two directories up |

### Git Shortcuts
| Alias | Command | Description |
|-------|---------|-------------|
| `g` | git | Git shorthand |
| `gs` | git status | Git status |
| `ga` | git add | Git add |
| `gc` | git commit -m | Git commit |
| `gp` | git push | Git push |
| `gl` | git log --oneline | Git log |

---

## Tips & Tricks

### Custom Keybinding Creation

Add to `config/zsh/core/04-keybinds.zsh`:
```zsh
bindkey '^X^E' edit-command-line  # Ctrl+X Ctrl+E to edit command in editor
```

### Tmux Custom Bindings

Add to `config/tmux/tmux.conf`:
```tmux
bind-key -n C-Left previous-window   # Ctrl+← for previous window
bind-key -n C-Right next-window      # Ctrl+→ for next window
```

### Kitty Custom Shortcuts

Add to `config/kitty/kitty.conf`:
```kitty
map ctrl+shift+z toggle_layout stack  # Toggle stack layout
```

---

## Quick Reference Card

```
ZSH:           Ctrl+R (search) | Ctrl+A/E (line start/end)
Tmux:          Prefix = Ctrl+B | Prefix+? (help)
Kitty:         Ctrl+Shift+T (new tab) | Ctrl+Shift+W (close)
FZF:           Ctrl+T (files) | Ctrl+R (history) | Alt+C (dirs)
```

---

**Last Updated:** 2024-11-13  
**Gotham Version:** 2.0
