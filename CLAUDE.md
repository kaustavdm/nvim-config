# Neovim Config — Claude Code Guide

This is a custom Neovim configuration built on **bare lazy.nvim** (NOT LazyVim). There is no LazyVim framework — all plugins are configured individually.

## Architecture

- `init.lua` loads `config/options.lua` first (sets leader key), then `config/lazy.lua` (bootstraps plugins), then keymaps/autocmds on VeryLazy event
- `defaults = { lazy = true }` — most plugins lazy by default for <50ms startup
- Three plugins load eagerly (`lazy = false`): tokyonight (colorscheme), snacks.nvim (dashboard+picker), nvim-treesitter (query files must be on rtp before any buffer opens)
- Language configs live in `lua/plugins/lang/` — one file per language, auto-discovered via `{ import = "plugins.lang" }`
- LSP glue is in `lua/plugins/lsp.lua` — uses `LspAttach` autocmd, `vim.lsp.config()`, `vim.lsp.completion.enable()` (native 0.11+ completion)
- No completion plugin — uses Neovim's built-in LSP completion

## Key Conventions

- Plugin specs with the same name are deep-merged by lazy.nvim
- `opts_extend = { "ensure_installed" }` on treesitter/mason allows lang files to extend lists
- `vim.g.autoformat` controls format-on-save (toggle: `<leader>uf`)
- `vim.g.show_time` controls statusline time display (toggle: `<leader>ut`)
- Diagnostics are disabled by default (`vim.diagnostic.enable(false)`)
- `cmdheight = 0` — command line hidden when idle, appears transiently when typing commands
- Treesitter uses main branch API: `require("nvim-treesitter").install()` not `ensure_installed` in setup
- Treesitter highlighting uses Neovim 0.11 native `vim.treesitter.start()` via a `FileType` autocmd in treesitter's `init` function
- `performance.rtp.paths` includes `stdpath("data")/site` — needed for treesitter parsers installed outside the plugin directory

## Plugin Loading Events

- Use `FileType` (not `BufReadPost`) for plugins that operate on typed buffers (lspconfig, gitsigns, autotag, lint). Lazy.nvim's interception of `BufReadPost` can break Neovim's filetype detection on the first buffer opened.
- Use `VeryLazy` for UI plugins (lualine, which-key, edgy) and plugins that don't need buffer context
- Use `cmd`, `keys`, or `ft` for plugins triggered by specific actions

## Adding a Language

Create `lua/plugins/lang/langname.lua` following the pattern in existing lang files:
1. Treesitter parsers via `nvim-treesitter` opts
2. LSP server via `nvim-lspconfig` opts.servers
3. Mason tools via `mason.nvim` opts.ensure_installed
4. Formatters via `conform.nvim` opts.formatters_by_ft
5. Linters via `nvim-lint` opts.linters_by_ft

No other wiring needed — mason auto-installs, LspAttach auto-configures keymaps + completion.

## Do NOT

- Reference any `LazyVim.*` globals — they don't exist
- Use `:LazyExtras` — not available without LazyVim
- Add a completion plugin (blink.cmp, nvim-cmp) — using native completion by design
- Add noice.nvim, bufferline.nvim — deliberately excluded
- Use `BufReadPost`/`BufNewFile` as lazy-loading events — breaks filetype detection (use `FileType` instead)
- Change nvim-treesitter to `lazy = true` — query files must be on rtp before any buffer opens for highlighting to work
