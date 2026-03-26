return {
  -- Treesitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },

  -- LSP: dockerls + docker compose
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },

  -- Linter: hadolint
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },

  -- Mason tools
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "hadolint" } },
  },
}
