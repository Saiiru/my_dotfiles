<div align="center">

### 🦇 Red Hood Neovim Cheatsheet

</div>

#### Colors & Theme
- Colorscheme: **`red-hood`** (high-contrast crimson/cyan palette aligned with your Hyprland theme).
- Terminal support: true-color; recommended font **JetBrainsMono Nerd Font**.
- GUI toggles (Neovide/Nvim-qt):  
  - `<F11>` fullscreen  
  - `<F10>` toggle transparency

#### Startup
- `nvim` — opens last session directory.
- `ncheat` (from shell) — displays this cheatsheet.
- Lazy sync: `:Lazy sync`
- Mason tooling: `:Mason`

#### Core Keymaps (normal mode)
| Action | Mapping |
| ------ | ------- |
| File explorer (Neo-tree left) | `<leader>e` |
| Command palette | `<C-S-p>` |
| Projects picker | `<leader>sp` |
| Fuzzy find files | `<leader>ff` |
| Live grep | `<leader>fg` |
| Switch buffer | `<leader>fb` |
| Diagnostics (Telescope) | `<leader>fd` |
| Toggle terminal (ToggleTerm) | `<C-/>` |
| Window focus (IJ style) | `<C-h>`, `<C-l>`, `<C-j>`, `<C-k>` |
| Overseer task list | `<leader>ml` |
| Run mise task (Overseer) | `<leader>mm` or `:MiseTask` |

#### LSP / Java Extras
- Hover docs: `K`
- Code actions: `<leader>ca`
- Rename symbol: `<leader>cr`
- Format: `<leader>cf`
- Diagnostics list: `<leader>cd`
- **Java** (via `nvim-jdtls`):  
  - Organize imports: `<leader>oi`  
  - Run nearest test: `<leader>tm`  
  - Run class tests: `<leader>tc`

#### Git & Versioning
- Gitsigns hunk navigation: `]c` / `[c`
- Stage/reset hunk: `<leader>hs` / `<leader>hr`
- Toggle Git blame (virtual text): `<leader>gb`
- Diffview toggle: `<leader>gd`

#### Useful Commands
- `:MiseTask` — fzf prompt of all mise tasks (mirrors `misetask` shell helper).
- `:OverseerToggle` — task quick panel.
- `:Neotree filesystem reveal left` — jump file tree to current buffer.
- `:ToggleTerm direction=float` — spawn floating console.
- `:MasonInstall jdtls java-debug-adapter java-test` — ensure Java tooling.

#### Snippets
- LuaSnip loads from `snippets/snipmate/*` and `snippets/vscode/*`.
- Trigger/expand: `<Tab>` in insert when completion menu closed.
- Cycle choice nodes: `<C-l>` / `<C-h>` (LazyVim defaults).

#### Theme Tweaks
- Colors defined in `colors/red-hood.lua`.
- Transparency adjustments in `plugin/after/transparency.lua`.
- Statusline via `lualine` with Overseer indicator; bufferline uses slant separators.

Enjoy the ride. 🦇
