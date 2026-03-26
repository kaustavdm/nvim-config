return {
  -- Treesitter parser
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "yaml" } },
  },

  -- SchemaStore for YAML schemas
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false,
  },

  -- LSP: yamlls with SchemaStore
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          on_new_config = function(new_config)
            new_config.settings.yaml.schemas = vim.tbl_deep_extend(
              "force",
              new_config.settings.yaml.schemas or {},
              require("schemastore").yaml.schemas()
            )
          end,
          capabilities = {
            textDocument = {
              foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
              },
            },
          },
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              keyOrdering = false,
              format = { enable = true },
              validate = true,
              schemaStore = {
                enable = false, -- we use SchemaStore.nvim instead
                url = "",
              },
            },
          },
        },
      },
    },
  },
}
