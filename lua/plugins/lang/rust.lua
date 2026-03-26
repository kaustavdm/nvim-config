return {
  -- Treesitter parsers
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "rust", "ron" } },
  },

  -- Rustaceanvim: comprehensive Rust support (replaces rust-analyzer lspconfig)
  {
    "mrcjkb/rustaceanvim",
    version = "^6",
    ft = { "rust" },
    opts = {
      server = {
        on_attach = function(_, bufnr)
          vim.keymap.set("n", "<leader>cR", function()
            vim.cmd.RustLsp("codeAction")
          end, { desc = "Code Action", buffer = bufnr })
          vim.keymap.set("n", "<leader>dr", function()
            vim.cmd.RustLsp("debuggables")
          end, { desc = "Rust Debuggables", buffer = bufnr })
        end,
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            checkOnSave = { command = "clippy" },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      },
    },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
  },

  -- Crates.nvim: Cargo.toml dependency management
  {
    "Saecki/crates.nvim",
    event = "BufRead Cargo.toml",
    opts = {
      completion = {
        crates = { enabled = true },
      },
    },
  },

  -- Mason tools
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "codelldb" } },
  },
}
