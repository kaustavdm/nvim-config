return {
  {
    "catppuccin/nvim",
    name = "catppuccin", -- dir/require name (repo is catppuccin/nvim)
    lazy = false,
    priority = 1000,
    opts = {
      flavour = "mocha", -- latte | frappe | macchiato | mocha
      integrations = {
        gitsigns = true,
        treesitter = true,
        native_lsp = { enabled = true },
        mason = true,
        which_key = true,
        flash = true,
        snacks = { enabled = true },
        mini = { enabled = true },
        markdown = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },
}
