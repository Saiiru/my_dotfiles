# NeoVim Config (LazyVim base)

- Base: LazyVim with full extras (see `lazyvim.json`).
- Theme: cyberdream (transparent).
- Java: `mfussenegger/nvim-jdtls` via `lua/jdtls/jdtls_setup.lua` (auto on FileType java). Needs `jdtls`, `java-debug-adapter`, `java-test` via :Mason.
- Inlay hints: `inlay-hints.nvim` included; attach automatically on LSP.
- Mise: tasks picker `<leader>tm` and prompt `<leader>tr` (ToggleTerm if available), parsing `[tasks]` from `.mise.toml`.

Quick start:
1. `:Lazy sync`
2. `:Mason` → install jdtls, java-debug-adapter, java-test
3. Open a Java file; check `:LspInfo`.
4. Mise tasks: `<leader>tm`.

Notes:
- Extras include astro/svelte/vue/etc.; npm deps may be needed to silence missing node module warnings.
- Theme is set via `lua/plugins/colorscheme/cyberdream.lua`.
