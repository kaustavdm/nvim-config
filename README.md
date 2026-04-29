# Neovim Config

A fast, functional code/text editor configuration for Neovim, built on [lazy.nvim](https://github.com/folke/lazy.nvim) — focused on editing, not IDE features. Custom mountain landscape dashboard.

<table>
  <tr>
    <td align="center" colspan="2">
      <img src="assets/dashboard.png" alt="Dashboard"/><br/>
      <sub>Dashboard — banner art (mountains), git status &amp; cwd, quick list of actions</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="assets/find-file.png" alt="Find file picker"/><br/>
      <sub>Find file picker</sub>
    </td>
    <td align="center" width="50%">
      <img src="assets/file-explorer.png" alt="File explorer"/><br/>
      <sub>File explorer (Snacks)</sub>
    </td>
  </tr>
  <tr>
    <td align="center" width="50%">
      <img src="assets/git-change-marker-on-line.png" alt="Git change markers"/><br/>
      <sub>Git change markers in gutter</sub>
    </td>
    <td align="center" width="50%">
      <img src="assets/visual-mode-activated.png" alt="Visual mode"/><br/>
      <sub>Visual mode selection (pressed `V`)</sub>
    </td>
  </tr>
</table>

## Features

- **Fast startup** — targets <42ms, only 3 plugins load eagerly (colorscheme, snacks, treesitter)
- **Custom dashboard** — procedurally generated ASCII mountain art with git status
- **14 languages** — Go, Rust, Python, TypeScript, Svelte, Tailwind, Docker, Terraform, SQL, Prisma, JSON, YAML, TOML, Markdown
- **Native completion** — Neovim 0.11+ built-in LSP completion with autotrigger
- **Custom statusline** — single-letter mode, git branch, diff, file breadcrumbs, pending keys
- **Hidden command line** — `cmdheight=0` for a minimal UI; commands appear transiently

## Prerequisites

macOS with [Homebrew](https://brew.sh/). Use iTerm2 or similar as terminal.

```sh
# Core
brew install neovim fd ripgrep

# Nerd Font (required for icons)
brew install --cask font-0xproto-nerd-font

# Optional: tree-sitter CLI (only needed for building custom parsers)
brew install tree-sitter-cli
```

- **neovim** >= 0.11.0 (required for native LSP completion)
- **fd** — file finder used by the picker
- **ripgrep** — content search used by live grep
- **Nerd Font** — required for icons; any patched font works

> **Important:** Font, font-sizing, and font-spacing must be set in the terminal settings.
> e.g., set `0xProto Nerd Font` as the font in your iTerm2 profile.

### iTerm2: Option key as Meta

By default, macOS forwards `Option+<key>` as a composed character (e.g. `Option+j` → `∆`), which prevents `<A-*>` keymaps from firing in Neovim — including the move-line mappings (`<A-j>` / `<A-k>`) and various plugin defaults. Configure iTerm2 to forward Option as Meta:

**Settings → Profiles → Keys → Key Mappings tab → set _Left Option key_ to `Esc+`**.

Leaving the **Right Option key** as `Normal` preserves macOS diacritic composition (`Option+e e` → `é`) while making left-Option behave as Alt for Neovim mappings.

## Setup

```sh
git clone https://github.com/kaustavdm/nvim-config.git ~/.config/nvim
nvim
```

lazy.nvim will install plugins on first launch. Mason will auto-install LSP servers and tools.

## Quick Usage Guide

### Opening Neovim

- `nvim` — opens dashboard with mountain art and quick actions
- `nvim file.lua` — opens file directly (no dashboard)
- `nvim .` — opens file explorer

### Essential Workflow

1. **Find files**: `<Space>ff` or `<Space>/` for grep
2. **Navigate**: `s` for flash jump, `<C-h/j/k/l>` between windows
3. **Edit**: `gc` to comment, `gsa` to add surroundings
4. **Code**: see [Working with code](#working-with-code) below
5. **Format**: auto on save, or `<Space>cf` manually
6. **Git**: gutter signs show changes, `]h`/`[h` navigate hunks

### Working with code

| Action                              | Keys                                          |
| ----------------------------------- | --------------------------------------------- |
| Goto definition / hover / code action | `gd` / `K` / `<Space>ca`                    |
| Search a symbol (current buffer)    | `<Space>ss`                                   |
| Search a symbol (workspace)         | `<Space>sS`                                   |
| Move current line up / down         | `<A-k>` / `<A-j>` (normal mode)               |
| Move selected lines up / down       | `<A-k>` / `<A-j>` (visual mode)               |
| Toggle fold under cursor            | `za`                                          |
| Close / open fold under cursor      | `zc` / `zo`                                   |
| Close / open all folds in buffer    | `zM` / `zR`                                   |

Folds use treesitter, so `zc` collapses the function/block your cursor is inside without you having to mark anything. Files open fully expanded (`foldlevelstart = 99`).

### Working with Tabs, Buffers, and Windows

| Concept    | What it is                                  | When to use it                                          |
| ---------- | ------------------------------------------- | ------------------------------------------------------- |
| **Buffer** | An in-memory file (the editable content)    | Default: every file you open is a buffer; cheap to keep dozens around |
| **Window** | A viewport showing a buffer                 | Split when you need to see two buffers at once (diff, ref + impl, test + code) |
| **Tab**    | A named layout of windows                   | Group an unrelated workspace (e.g. one tab per task / feature / area of the codebase) |

Rule of thumb: open everything as buffers, split into windows when you need *side-by-side* visibility, reach for tabs only when you want a separate window layout you can switch back to wholesale.

**Splitting to open multiple files side-by-side**
- `<Space>wv` — vertical split (left/right)
- `<Space>ws` — horizontal split (top/bottom)
- Then `<Space>ff` (or any open command) inside the new window
- `<C-h/j/k/l>` to jump between windows; `<C-Up/Down/Left/Right>` to resize
- `<Space>wd` close window, `<Space>wo` keep only this one

**Tabs**
- `<Space><Tab><Tab>` — create new tab
- `<Space><Tab>]` / `<Space><Tab>[` — switch to next / previous tab
- `<Space><Tab>L` — fuzzy-find an open tab (like the buffer list)
- `<Space><Tab>d` close tab, `<Space><Tab>o` close all other tabs

**Buffers**
- `<S-h>` / `<S-l>` — previous / next buffer (fastest cycling)
- `<Space>B` (or `<Space>bl`) — fuzzy-find open buffers
- `<Space>bd` close current buffer (keeps the window open)

## Keymaps

Leader key is `<Space>`.

### File & Search

| Key         | Action         |
| ----------- | -------------- |
| `<Space>ff` | Find files     |
| `<Space>fF` | Find files (incl. gitignored) |
| `<Space>/`  | Live grep      |
| `<Space>fr` | Recent files   |
| `<Space>fg` | Git files      |
| `<Space>fc` | Config files   |
| `<Space>e`  | Explorer (git root) |
| `<Space>E`  | Explorer (cwd)      |
| `<Space>P`  | Command palette     |
| `<Space>K`  | Keymaps (search)    |
| `<Space>?`  | Buffer keymaps (which-key) |

### File Explorer

Default state shows dotfiles; gitignored paths are hidden. Toggle either with the keys below. When focused on the search box (after pressing `/`), use `<a-h>` / `<a-i>` instead.

| Key         | Action                              |
| ----------- | ----------------------------------- |
| `l` / `<CR>`| Open file / expand directory        |
| `h`         | Close directory                     |
| `<BS>`      | Go to parent directory              |
| `.`         | Set focused directory as root       |
| `Z`         | Collapse all directories            |
| `a`         | Add file or directory               |
| `d`         | Delete                              |
| `r`         | Rename                              |
| `c` / `m`   | Copy / move                         |
| `y` / `p`   | Yank / paste                        |
| `o`         | Open with system application        |
| `H`         | Toggle hidden (dotfiles)            |
| `I`         | Toggle ignored (gitignored paths)   |
| `P`         | Toggle preview                      |
| `/`         | Focus search input                  |
| `<C-c>`     | `:tcd` to focused directory         |
| `]g` / `[g` | Next / prev git change              |
| `]d` / `[d` | Next / prev diagnostic              |

### Code & LSP

| Key         | Action               |
| ----------- | -------------------- |
| `gd`        | Goto definition      |
| `gr`        | References           |
| `gI`        | Goto implementation  |
| `gy`        | Goto type definition |
| `gD`        | Goto declaration     |
| `K`         | Hover documentation  |
| `gK`        | Signature help       |
| `<Space>ca` | Code action          |
| `<Space>cr` | Rename symbol        |
| `<Space>cR` | Rename file          |
| `<Space>cf` | Format               |
| `<Space>cF` | Format injected langs |
| `<Space>cd` | Line diagnostics     |
| `<Space>cl` | LSP info             |

### Navigation

| Key               | Action                  |
| ----------------- | ----------------------- |
| `s` / `S`         | Flash jump / treesitter |
| `<C-h/j/k/l>`     | Navigate windows        |
| `<S-h>` / `<S-l>` | Previous / next buffer  |
| `[b` / `]b`       | Previous / next buffer  |
| `]f` / `[f`       | Next / prev function    |
| `]c` / `[c`       | Next / prev class       |
| `]h` / `[h`       | Next / prev git hunk    |
| `]d` / `[d`       | Next / prev diagnostic  |

### Buffer & Window

| Key                      | Action               |
| ------------------------ | -------------------- |
| `<Space>bl` / `<Space>B` | List buffers         |
| `<Space>bd`              | Delete buffer        |
| `<Space>bD`              | Delete other buffers |
| `<Space>wv`              | Split vertical       |
| `<Space>ws`              | Split horizontal     |
| `<Space>wd`              | Close window         |
| `<Space>ww`              | Other window         |
| `<Space>wo`              | Close other windows  |
| `<Space>wL`              | List windows         |
| `<C-Up/Down/Left/Right>` | Resize windows       |

### Tabs

| Key                  | Action            |
| -------------------- | ----------------- |
| `<Space><Tab><Tab>`  | New tab           |
| `<Space><Tab>]`      | Next tab          |
| `<Space><Tab>[`      | Previous tab      |
| `<Space><Tab>f`      | First tab         |
| `<Space><Tab>l`      | Last tab          |
| `<Space><Tab>d`      | Close tab         |
| `<Space><Tab>o`      | Close other tabs  |
| `<Space><Tab>L`      | List tabs         |

### Git (gitsigns)

| Key          | Action                    |
| ------------ | ------------------------- |
| `]h` / `[h`  | Next / prev hunk          |
| `<Space>ghs` | Stage hunk                |
| `<Space>ghr` | Reset hunk                |
| `<Space>ghS` | Stage buffer              |
| `<Space>ghu` | Undo stage hunk           |
| `<Space>ghp` | Preview hunk inline       |
| `<Space>ghb` | Blame line                |
| `<Space>ghd` | Diff this                 |
| `ih`         | Select hunk (text object) |

### Search

| Key         | Action                 |
| ----------- | ---------------------- |
| `<Space>sg` | Grep                   |
| `<Space>sw` | Grep word under cursor |
| `<Space>sb` | Grep open buffers      |
| `<Space>sh` | Help pages             |
| `<Space>sm` | Marks                  |
| `<Space>sr` | Resume last search     |
| `<Space>sd` | Diagnostics            |
| `<Space>sD` | Buffer diagnostics     |
| `<Space>ss` | LSP symbols (buffer)   |
| `<Space>sS` | LSP workspace symbols  |

### Toggles

| Key         | Action                  |
| ----------- | ----------------------- |
| `<Space>uf` | Toggle autoformat       |
| `<Space>ud` | Toggle diagnostics      |
| `<Space>ul` | Toggle line numbers     |
| `<Space>uL` | Toggle relative numbers |
| `<Space>uw` | Toggle word wrap        |
| `<Space>us` | Toggle spelling         |
| `<Space>ut` | Toggle statusline time  |
| `<Space>ur` | Clear hlsearch / redraw |


### Session & Quit

| Key         | Action                 |
| ----------- | ---------------------- |
| `<Space>qs` | Restore session        |
| `<Space>qS` | Select session         |
| `<Space>ql` | Restore last session   |
| `<Space>qd` | Don't save session     |
| `<Space>qq` | Quit all               |
| `<Space>l`  | Lazy (plugin manager)  |
| `<Space>cm` | Mason (tool installer) |
| `<Space>;`  | Dashboard              |

### Coding

| Key                | Action                       |
| ------------------ | ---------------------------- |
| `gc` / `gcc`       | Toggle comment (line/motion) |
| `gsa`              | Add surrounding              |
| `gsd`              | Delete surrounding           |
| `gsr`              | Replace surrounding          |
| `af` / `if`        | Around / inside function     |
| `ac` / `ic`        | Around / inside class        |
| `<A-j>` / `<A-k>`  | Move line down / up          |
| `<` / `>` (visual) | Indent and reselect          |

### Language-specific

Active only in matching filetype.

| Key         | Filetype | Action                |
| ----------- | -------- | --------------------- |
| `<Space>cp` | markdown | Markdown preview toggle |
| `<Space>D`  | sql      | Toggle DB UI          |
| `<Space>dr` | rust     | Rust debuggables      |

## Common Patterns

### Adding a New Language

Create `lua/plugins/lang/langname.lua`:

```lua
return {
  { "nvim-treesitter/nvim-treesitter", opts = { ensure_installed = { "lang" } } },
  { "neovim/nvim-lspconfig", opts = { servers = { server_name = {} } } },
  { "mason-org/mason.nvim", opts = { ensure_installed = { "tool" } } },
  { "stevearc/conform.nvim", opts = { formatters_by_ft = { lang = { "fmt" } } } },
  { "mfussenegger/nvim-lint", opts = { linters_by_ft = { lang = { "linter" } } } },
}
```

### Adding a New Plugin

Create a new file in `lua/plugins/` or add to an existing one:

```lua
return {
  {
    "author/plugin-name",
    event = "VeryLazy",  -- or: cmd, ft, keys
    opts = { ... },
  },
}
```

### Changing Colorscheme

Edit `lua/plugins/colorscheme.lua`:

```lua
return {
  {
    "author/theme.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("theme")
    end,
  },
}
```

## Statusline

The statusline (lualine) shows:

```
[N] main  +3 -1  ● 2  src › db › factory.ts     lua  d42:13  14:30
 │    │     │      │           │                   │    │  │     │
 │    │     │      │           │                   │    │  │     └─ Time (<Space>ut)
 │    │     │      │           │                   │    │  └─ Line:Col
 │    │     │      │           │                   │    └─ Pending keys
 │    │     │      │           │                   └─ Filetype
 │    │     │      │           └─ File path (breadcrumbs, auto-truncates)
 │    │     │      └─ Diagnostics
 │    │     └─ Git diff (additions green, deletions red)
 │    └─ Git branch
 └─ Mode: N=Normal, I=Insert, V=Visual, C=Command, R=Replace, T=Terminal
```

## Debugging

- `:checkhealth` — verify LSP, treesitter, mason
- `:Lazy` — plugin manager (update, clean, profile)
- `:Lazy profile` — startup performance
- `:Mason` — LSP/tool installer
- `nvim --startuptime /tmp/startup.log` — measure startup time

## License

[Apache 2.0](LICENSE)
