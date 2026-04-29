# Neovim Config — Claude Code Guide

A fast, functional code/text editor — not an IDE. Built on **bare lazy.nvim** (NOT LazyVim). There is no LazyVim framework — all plugins are configured individually.

## Architecture

- `init.lua` loads `config/options.lua` first (sets leader key), then `config/lazy.lua` (bootstraps plugins), then keymaps/autocmds on VeryLazy event
- `defaults = { lazy = true }` — most plugins lazy by default for <42ms startup
- Eager load (`lazy = false`): tokyonight, snacks.nvim, nvim-treesitter (treesitter query files must be on rtp before any buffer opens)
- Language configs live in `lua/plugins/lang/` — one file per language, auto-discovered via `{ import = "plugins.lang" }`
- File explorer is `Snacks.explorer()` (replaces neo-tree/edgy)
- LSP in `lua/plugins/lsp.lua`: `LspAttach` autocmd + `vim.lsp.config()` + native 0.11 completion via `vim.lsp.completion.enable()` — no nvim-cmp/blink

## Key Conventions

- Plugin specs with the same name are deep-merged by lazy.nvim
- Read installed plugin source at `~/.local/share/nvim/lazy/<plugin>/lua/` for defaults, key tables, and undocumented options
- Verify a Lua file parses: `nvim --headless -c "luafile <path>" -c "qa"` (`luac` is not installed)
- `opts_extend = { "ensure_installed" }` on treesitter/mason allows lang files to extend lists
- Snacks per-source config goes in `opts.picker.sources.<name>` (e.g. `sources.explorer = { hidden = true }`); merged onto built-in defaults in `snacks.nvim/lua/snacks/picker/config/sources.lua`
- `vim.g.autoformat` controls format-on-save (toggle: `<leader>uf`)
- `vim.g.show_time` controls statusline time display (toggle: `<leader>ut`)
- Diagnostics off by default (`vim.diagnostic.enable(false)` in VeryLazy callback)
- `cmdheight = 0` — cmdline hidden when idle, appears transiently
- Treesitter uses main-branch API: `require("nvim-treesitter").install()` (not `ensure_installed` in setup); highlighting via native `vim.treesitter.start()` in a `FileType` autocmd
- `performance.rtp.paths` includes `stdpath("data")/site` so out-of-plugin-dir parsers are found
- PNG screenshots in `assets/`: compress with `oxipng --opt 4 --strip all` (not `sips`)

## Plugin Loading Events

- Use `FileType` (not `BufReadPost`) for plugins that operate on typed buffers (lspconfig, gitsigns, autotag, lint). Lazy.nvim's interception of `BufReadPost` can break Neovim's filetype detection on the first buffer opened.
- Use `VeryLazy` for UI plugins (lualine, which-key) and plugins that don't need buffer context
- Use `cmd`, `keys`, or `ft` for plugins triggered by specific actions

## Adding a Language

Create `lua/plugins/lang/<name>.lua` extending these opts: `nvim-treesitter` (parsers), `nvim-lspconfig` (servers), `mason.nvim` (ensure_installed), `conform.nvim` (formatters_by_ft), `nvim-lint` (linters_by_ft). Mason auto-installs; LspAttach auto-configures keymaps + completion.

## Do NOT

- Reference any `LazyVim.*` globals — they don't exist
- Use `:LazyExtras` — not available without LazyVim
- Add a completion plugin (blink.cmp, nvim-cmp) — using native completion by design
- Add noice.nvim, bufferline.nvim, neo-tree, edgy.nvim — deliberately excluded (explorer is Snacks-based)
- Add trouble.nvim, todo-comments, treesitter-context, mini.ai, mini.snippets, grug-far — deliberately dropped from the LazyVim baseline
- Add IDE-style features (debugger, test runner, task runner) — this is an editor, not an IDE
- Use `BufReadPost`/`BufNewFile` as lazy-loading events — breaks filetype detection (use `FileType` instead)
- Change nvim-treesitter to `lazy = true` — query files must be on rtp before any buffer opens for highlighting to work
