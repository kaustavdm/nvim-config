return {
  -- Treesitter: syntax highlighting and code parsing
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall" },
    opts_extend = { "ensure_installed" },
    init = function()
      -- Enable treesitter highlighting via Neovim 0.11 native API.
      -- This runs at startup (before the plugin loads) so it catches the first file opened.
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("treesitter_start", { clear = true }),
        callback = function(args)
          local ok = pcall(vim.treesitter.start)
          -- Wire treesitter folding only when a parser actually started.
          if ok then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.wo.foldtext = ""
            vim.opt_local.foldlevel = 99 -- start fully expanded
          end
        end,
      })
    end,
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "diff",
        "html",
        "javascript",
        "jsdoc",
        "json",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "printf",
        "python",
        "query",
        "regex",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
      },
    },
    config = function(_, opts)
      require("nvim-treesitter").setup({})
      -- Main branch uses install() instead of ensure_installed in setup()
      if opts.ensure_installed and #opts.ensure_installed > 0 then
        require("nvim-treesitter").install(opts.ensure_installed)
      end
    end,
  },

  -- Treesitter text objects: navigate by function, class, parameter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = "VeryLazy",
    config = function()
      -- Ensure treesitter is loaded first
      if not package.loaded["nvim-treesitter"] then
        require("nvim-treesitter")
      end

      local move = require("nvim-treesitter-textobjects.move")
      local select = require("nvim-treesitter-textobjects.select")

      -- Navigation keymaps
      local map = vim.keymap.set
      -- stylua: ignore start
      map({ "n", "x", "o" }, "]f", function() move.goto_next_start("@function.outer") end, { desc = "Next Function Start" })
      map({ "n", "x", "o" }, "]F", function() move.goto_next_end("@function.outer") end, { desc = "Next Function End" })
      map({ "n", "x", "o" }, "[f", function() move.goto_previous_start("@function.outer") end, { desc = "Prev Function Start" })
      map({ "n", "x", "o" }, "[F", function() move.goto_previous_end("@function.outer") end, { desc = "Prev Function End" })
      map({ "n", "x", "o" }, "]c", function() move.goto_next_start("@class.outer") end, { desc = "Next Class Start" })
      map({ "n", "x", "o" }, "[c", function() move.goto_previous_start("@class.outer") end, { desc = "Prev Class Start" })
      map({ "n", "x", "o" }, "]a", function() move.goto_next_start("@parameter.inner") end, { desc = "Next Parameter" })
      map({ "n", "x", "o" }, "[a", function() move.goto_previous_start("@parameter.inner") end, { desc = "Prev Parameter" })

      -- Selection keymaps
      map({ "x", "o" }, "af", function() select.select_textobject("@function.outer") end, { desc = "Around Function" })
      map({ "x", "o" }, "if", function() select.select_textobject("@function.inner") end, { desc = "Inside Function" })
      map({ "x", "o" }, "ac", function() select.select_textobject("@class.outer") end, { desc = "Around Class" })
      map({ "x", "o" }, "ic", function() select.select_textobject("@class.inner") end, { desc = "Inside Class" })
      map({ "x", "o" }, "aa", function() select.select_textobject("@parameter.outer") end, { desc = "Around Parameter" })
      map({ "x", "o" }, "ia", function() select.select_textobject("@parameter.inner") end, { desc = "Inside Parameter" })
      -- stylua: ignore end
    end,
  },

  -- Auto-tag: auto-close and auto-rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "FileType",
    opts = {},
  },
}
