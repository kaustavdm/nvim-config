# Neovim Config

Personal [LazyVim](https://lazyvim.github.io/) configuration with a custom procedural mountain landscape dashboard.

![Dashboard](assets/dashboard.png)

## Features

- **Custom dashboard** — procedurally generated ASCII mountain art with git branch, diff counts, and path breadcrumbs
- **Language support** — Go, Rust, Python, TypeScript, Svelte, Docker, Terraform, Prisma, SQL, and more
- **AI integration** — [Claude Code](https://github.com/anthropics/claude-code) via [claudecode.nvim](https://github.com/anthropics/claudecode.nvim)
- **Formatting & linting** — Prettier, ESLint, StyLua

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
