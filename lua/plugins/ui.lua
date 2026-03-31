local mode_map = {
  ["NORMAL"] = "N",
  ["O-PENDING"] = "O",
  ["INSERT"] = "I",
  ["VISUAL"] = "V",
  ["V-BLOCK"] = "V",
  ["V-LINE"] = "V",
  ["SELECT"] = "S",
  ["S-LINE"] = "S",
  ["S-BLOCK"] = "S",
  ["REPLACE"] = "R",
  ["V-REPLACE"] = "R",
  ["COMMAND"] = "C",
  ["EX"] = "X",
  ["TERMINAL"] = "T",
  ["CONFIRM"] = "Y",
  ["MORE"] = "M",
  ["SHELL"] = "$",
}

return {
  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "echasnovski/mini.icons" },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = { "snacks_dashboard" },
        },
      },
      sections = {
        lualine_a = {
          {
            "mode",
            fmt = function(mode)
              return mode_map[mode] or mode:sub(1, 1)
            end,
          },
        },
        lualine_b = { "branch" },
        lualine_c = {
          {
            "diff",
            symbols = { added = "+", modified = "~", removed = "-" },
            source = function()
              local gs = vim.b.gitsigns_status_dict
              if gs then
                return { added = gs.added, modified = gs.changed, removed = gs.removed }
              end
            end,
          },
          { "diagnostics" },
          {
            "filename",
            path = 1, -- relative path
            shorting_target = 40, -- leave room for other components
            symbols = { modified = " +", readonly = " -", unnamed = "[No Name]" },
            fmt = function(str)
              -- Show cwd breadcrumbs for neo-tree, file path breadcrumbs otherwise
              if vim.bo.filetype == "neo-tree" then
                local cwd = vim.uv.cwd() or vim.fn.getcwd()
                local home = vim.env.HOME or ""
                if home ~= "" and cwd:sub(1, #home) == home then
                  cwd = "~" .. cwd:sub(#home + 1)
                end
                return cwd:gsub("/", " › ")
              end
              return str:gsub("/", " › ")
            end,
          },
        },
        lualine_x = { "filetype" },
        lualine_y = {
          { "%S", separator = "" }, -- show pending keys/macro recording
          {
            "location",
            fmt = function(str)
              return str:gsub("%s+", "")
            end,
          },
        },
        lualine_z = {
          {
            function()
              return os.date("%R")
            end,
            cond = function()
              return vim.g.show_time == true
            end,
          },
        },
      },
      extensions = { "lazy" },
    },
  },

  -- Keybinding hints
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "code" },
        { "<leader>f", group = "file/find" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "quit/session" },
        { "<leader>s", group = "search" },
        { "<leader>u", group = "ui/toggle" },
        { "<leader>w", group = "windows" },
        { "<leader>x", group = "diagnostics/quickfix" },
        { "<leader><tab>", group = "tabs" },
        { "[", group = "prev" },
        { "]", group = "next" },
        { "g", group = "goto" },
        { "gs", group = "surround" },
        { "z", group = "fold" },
      },
    },
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Keymaps",
      },
    },
  },

  -- Icons
  {
    "echasnovski/mini.icons",
    lazy = true,
    opts = {},
    init = function()
      -- Register mini.icons as the icon provider for other plugins
      package.preload["nvim-web-devicons"] = function()
        require("mini.icons").mock_nvim_web_devicons()
        return package.loaded["nvim-web-devicons"]
      end
    end,
  },
}
