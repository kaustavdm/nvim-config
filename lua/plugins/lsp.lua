return {
  -- Mason: tool installer
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    build = ":MasonUpdate",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end)
    end,
  },

  -- Mason-lspconfig: bridge mason ↔ lspconfig
  {
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
  },

  -- LSP config
  {
    "neovim/nvim-lspconfig",
    event = "FileType",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = { checkThirdParty = false },
              completion = { callSnippet = "Replace" },
              hint = { enable = true },
              doc = { privateName = { "^_" } },
            },
          },
        },
      },
    },
    config = function(_, opts)
      -- LspAttach autocmd: keymaps + native completion
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("lsp_attach", { clear = true }),
        callback = function(event)
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          local buf = event.buf
          if not client then
            return
          end

          -- Disable ruff hover in favor of pyright
          if client.name == "ruff" then
            client.server_capabilities.hoverProvider = false
          end

          -- Enable native completion with autotrigger
          vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })

          -- Buffer-local keymaps
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = buf, desc = desc, silent = true })
          end

          -- Use Snacks picker for LSP navigation if available
          if package.loaded["snacks"] then
            map("n", "gd", function() Snacks.picker.lsp_definitions() end, "Goto Definition")
            map("n", "gr", function() Snacks.picker.lsp_references() end, "References")
            map("n", "gI", function() Snacks.picker.lsp_implementations() end, "Goto Implementation")
            map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, "Goto Type Definition")
            map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, "LSP Symbols")
            map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")
          else
            map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
            map("n", "gr", vim.lsp.buf.references, "References")
            map("n", "gI", vim.lsp.buf.implementation, "Goto Implementation")
            map("n", "gy", vim.lsp.buf.type_definition, "Goto Type Definition")
          end

          map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
          map("n", "K", vim.lsp.buf.hover, "Hover")
          map("n", "gK", vim.lsp.buf.signature_help, "Signature Help")
          map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature Help")
          map({ "n", "x" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Rename")
          map("n", "<leader>cl", "<cmd>checkhealth vim.lsp<cr>", "LSP Info")
          map("n", "<leader>cR", function()
            if Snacks and Snacks.rename then
              Snacks.rename.rename_file()
            end
          end, "Rename File")

          -- Enable inlay hints if supported
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = buf })
          end
        end,
      })

      -- Configure each server
      for server, server_opts in pairs(opts.servers) do
        if type(server_opts) == "table" and server_opts.enabled ~= false then
          vim.lsp.config(server, server_opts)
        end
      end

      -- Mason-lspconfig: auto-install and auto-enable servers
      local mlsp = require("mason-lspconfig")
      local mason_servers = {}
      local mapping = mlsp.get_mappings()
      if mapping and mapping.lspconfig_to_package then
        mason_servers = vim.tbl_keys(mapping.lspconfig_to_package)
      end

      local ensure_installed = {}
      for server, sopts in pairs(opts.servers) do
        if type(sopts) == "table" and sopts.enabled ~= false then
          if vim.tbl_contains(mason_servers, server) then
            table.insert(ensure_installed, server)
          else
            -- Non-mason server, enable directly
            vim.lsp.enable(server)
          end
        end
      end

      mlsp.setup({
        ensure_installed = ensure_installed,
        automatic_enable = true,
      })
    end,
  },

  -- Lazydev: Lua LSP for Neovim config editing
  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        { path = "snacks.nvim", words = { "Snacks" } },
        { path = "lazy.nvim", words = { "lazy" } },
      },
    },
  },
}
