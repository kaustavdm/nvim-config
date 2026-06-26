# Neovim Config — Claude Code Guide

Fast, functional code/text editor — not an IDE. Built on **bare lazy.nvim** (NOT LazyVim); all plugins configured individually.

## Architecture

- `init.lua` loads `config/options.lua` first (sets leader key), then `config/lazy.lua` (bootstraps plugins), then keymaps/autocmds on VeryLazy event
- `defaults = { lazy = true }` — most plugins lazy by default for <42ms startup
- Eager load (`lazy = false`): catppuccin, snacks.nvim, nvim-treesitter — treesitter query files MUST be on rtp before any buffer opens (do not set `lazy = true`)
- Language configs live in `lua/plugins/lang/` — one file per language, auto-discovered via `{ import = "plugins.lang" }`
- File explorer is `Snacks.explorer()` (replaces neo-tree/edgy)
- LSP in `lua/plugins/lsp.lua`: `LspAttach` autocmd + `vim.lsp.config()` + native completion via `vim.lsp.completion.enable()` — no nvim-cmp/blink. Also wires `vim.lsp.document_color`/`linked_editing_range` (capability-gated)
- Requires Neovim **0.12+**: uses `pumborder`/`pummaxwidth`, `vim.lsp.document_color`/`linked_editing_range`, native treesitter incremental selection (`an`/`in`/`]n`/`[n`) — these error on 0.11

## Key Conventions

- Plugin specs with the same name are deep-merged by lazy.nvim
- Read installed plugin source at `~/.local/share/nvim/lazy/<plugin>/lua/` for defaults, key tables, and undocumented options
- Verify a Lua file parses: `nvim --headless -c "luafile <path>" -c "qa"` (`luac` is not installed)
- Test VeryLazy-loaded keymaps/autocmds or check runtime option/API values headlessly: `nvim --headless -c "doautocmd User VeryLazy" -c "<lua check>" -c "qa"` (VeryLazy doesn't fire in a plain instant-quit headless run)
- Keymap namespaces: toggles → `<leader>u*`, code/LSP → `<leader>c*`. Lang files register `<leader>c*` via ft-gated `keys=` (e.g. markdown `<leader>cp`) — check collisions before adding a global `<leader>c` map
- 0.12 bundled opt-in plugins (Undotree, DiffTool, tohtml) live in `$VIMRUNTIME/pack/dist/opt` — `:packadd nvim.<name>` before use
- `opts_extend = { "ensure_installed" }` on treesitter/mason allows lang files to extend lists
- Snacks per-source config goes in `opts.picker.sources.<name>` (e.g. `sources.explorer = { hidden = true }`); merged onto built-in defaults in `snacks.nvim/lua/snacks/picker/config/sources.lua`
- which-key `filter` in `lua/plugins/ui.lua` drops `desc == "Dashboard action"` entries (Snacks hard-codes that string in `snacks/dashboard.lua` for every dashboard key). Re-check this string when editing dashboard `preset.keys` in `lua/plugins/snacks.lua` or after Snacks upgrades.
- `vim.g.autoformat` controls format-on-save (toggle: `<leader>uf`)
- `vim.g.show_time` controls statusline time display (toggle: `<leader>ut`)
- Diagnostics off by default (`vim.diagnostic.enable(false)` in VeryLazy callback)
- `cmdheight = 0` — cmdline hidden when idle, appears transiently
- Treesitter uses main-branch API: `require("nvim-treesitter").install()` (not `ensure_installed` in setup); highlighting via native `vim.treesitter.start()` in a `FileType` autocmd. Main branch provides **highlighting only, NO `indentexpr`** — indent-on-Return comes from `autoindent` (Neovim default) + bundled filetype indent scripts
- Do NOT re-enable `smartindent` — its C-style heuristics misfire on filetypes without an indent script (markdown/toml/svelte) and land Return in the wrong column (the bug it caused)
- `performance.rtp.paths` includes `stdpath("data")/site` so out-of-plugin-dir parsers are found
- PNG screenshots in `assets/`: compress with `oxipng --opt 4 --strip all` (not `sips`)

## Plugin Loading Events

- Use `FileType` (NOT `BufReadPost`/`BufNewFile`) for plugins that operate on typed buffers (lspconfig, gitsigns, autotag, lint) — lazy.nvim's `BufReadPost` interception breaks filetype detection on the first buffer
- Use `VeryLazy` for UI plugins (lualine, which-key) and plugins that don't need buffer context
- Use `cmd`, `keys`, or `ft` for plugins triggered by specific actions

## Adding a Language

Create `lua/plugins/lang/<name>.lua` extending these opts: `nvim-treesitter` (parsers), `nvim-lspconfig` (servers), `mason.nvim` (ensure_installed), `conform.nvim` (formatters_by_ft), `nvim-lint` (linters_by_ft). Mason auto-installs; LspAttach auto-configures keymaps + completion.

## Do NOT

- Reference `LazyVim.*` globals or use `:LazyExtras` — no LazyVim framework here
- Add a completion plugin (blink.cmp, nvim-cmp) — using native completion by design
- Add these (deliberately excluded): noice.nvim, bufferline.nvim, neo-tree, edgy.nvim, trouble.nvim, todo-comments, treesitter-context, mini.ai, mini.snippets, grug-far
- Add IDE-style features (debugger, test runner, task runner) — this is an editor, not an IDE
- Add a file/directory tree to `README.md` — drifts stale on refactors; architecture/load-order belongs in this file
- Migrate to `vim.pack` (0.12 built-in manager) — it lacks lazy-loading (`ft`/`cmd`/`keys`/`event`), `opts`/`opts_extend` deep-merge, `dependencies`, and `build` hooks that this config relies on (esp. the `lang/` deep-merge into shared specs). Evaluated and rejected; keep lazy.nvim
