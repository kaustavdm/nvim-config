# Neovim Config

Personal [LazyVim](https://lazyvim.org/) configuration with a custom procedural mountain landscape dashboard.

![Dashboard](assets/dashboard.png)

## Features

- **Custom dashboard** — procedurally generated ASCII mountain art with git branch, diff counts, and path breadcrumbs
- **Language support** — Go, Rust, Python, TypeScript, Svelte, Docker, Terraform, Prisma, SQL, and more
- **AI integration** — [Claude Code](https://github.com/anthropics/claude-code) via [claudecode.nvim](https://github.com/anthropics/claudecode.nvim)
- **Formatting & linting** — Prettier, ESLint, StyLua

## Prerequisites

macOS with [Homebrew](https://brew.sh/). `git` and `curl` are pre-installed on macOS.

Use iTerm2 or similar as terminal.

```sh
# Core (required by LazyVim)
brew install neovim fd ripgrep lazygit

# Nerd Font (required for icons)
brew install --cask font-symbols-only-nerd-font font-0xproto-nerd-font

# Optional: tree-sitter CLI (only needed for building custom parsers)
brew install tree-sitter
```

- **neovim** >= 0.9.0
- **fd** — file finder used by the file picker
- **ripgrep** — content search used by live grep
- **lazygit** — git TUI integration
- **Nerd Font** — required for icons; any patched font works (`brew search nerd-font`)

> !IMPORTANT
> **Font and font-sizing and font-spacing must be set in the terminal settings.**
> e.g., set the `0xproto nerd font` as the font for the iTerm2 profile.

## Setup

Requires [Neovim](https://neovim.io/) >= 0.9.0.

```sh
git clone https://github.com/kaustavdm/nvim-config.git ~/.config/nvim
nvim
```

LazyVim will install plugins on first launch.

## Structure

```
lua/
├── config/       # Options, keymaps, autocmds (LazyVim defaults)
├── lib/          # Dashboard art and git status modules
└── plugins/      # Plugin specs
```

## License

[Apache 2.0](LICENSE)
