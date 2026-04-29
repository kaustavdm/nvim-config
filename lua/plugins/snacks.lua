return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Enabled modules
      dashboard = {
        preset = {
          -- stylua: ignore
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = function() Snacks.picker.files({ hidden = true }) end },
            { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer()" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { gap = 1 },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          function()
            return require("lib.mountain_art").section()()
          end,
          function()
            return require("lib.dashboard_status").section()()
          end,
          { padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
        },
      },
      explorer = { enabled = true },
      picker = {
        enabled = true,
        sources = {
          explorer = {
            hidden = true,
            ignored = false,
          },
        },
      },
      toggle = { enabled = true },
      rename = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },

      -- Disabled modules
      notifier = { enabled = false },
      scroll = { enabled = false },
      indent = { enabled = false },
      scope = { enabled = false },
      statuscolumn = { enabled = false },
      words = { enabled = false },
      animate = { enabled = false },
      input = { enabled = false },
      dim = { enabled = false },
      zen = { enabled = false },
    },
    keys = {
      -- Explorer
      { "<leader>e", function()
        local root = vim.fs.root(0, ".git") or vim.uv.cwd()
        Snacks.explorer({ cwd = root })
      end, desc = "Explorer (Git Root)" },
      { "<leader>E", function() Snacks.explorer() end, desc = "Explorer (cwd)" },
      -- Picker keymaps
      { "<leader>ff", function() Snacks.picker.files({ hidden = true }) end, desc = "Find Files" },
      { "<leader>fF", function() Snacks.picker.files({ hidden = true, ignored = true }) end, desc = "Find Files (incl. ignored)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>P", function() Snacks.picker.commands() end, desc = "Command Palette" },
      { "<leader>K", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>bl", function() Snacks.picker.buffers() end, desc = "List Buffers" },
      { "<leader>B", function() Snacks.picker.buffers() end, desc = "List Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config Files" },
      -- Search
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume Search" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      -- Buffer delete
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      -- Tabs
      {
        "<leader><tab>L",
        function()
          local items = {}
          for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
            local win = vim.api.nvim_tabpage_get_win(tab)
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            local short = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
            local nr = vim.api.nvim_tabpage_get_number(tab)
            local cur = tab == vim.api.nvim_get_current_tabpage() and "%" or " "
            items[#items + 1] = {
              text = string.format("%s %d  %s", cur, nr, short),
              tab = tab,
            }
          end
          Snacks.picker.pick({
            source = "tabs",
            title = "Tabs",
            items = items,
            format = "text",
            confirm = function(picker, item)
              picker:close()
              if item and vim.api.nvim_tabpage_is_valid(item.tab) then
                vim.api.nvim_set_current_tabpage(item.tab)
              end
            end,
          })
        end,
        desc = "List Tabs",
      },
      -- Windows
      {
        "<leader>wL",
        function()
          local items = {}
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local buf = vim.api.nvim_win_get_buf(win)
            local name = vim.api.nvim_buf_get_name(buf)
            local short = name == "" and "[No Name]" or vim.fn.fnamemodify(name, ":~:.")
            local cur = win == vim.api.nvim_get_current_win() and "%" or " "
            items[#items + 1] = {
              text = string.format("%s %d  %s", cur, win, short),
              win = win,
            }
          end
          Snacks.picker.pick({
            source = "windows",
            title = "Windows",
            items = items,
            format = "text",
            confirm = function(picker, item)
              picker:close()
              if item and vim.api.nvim_win_is_valid(item.win) then
                vim.api.nvim_set_current_win(item.win)
              end
            end,
          })
        end,
        desc = "List Windows",
      },
      -- Dashboard
      { "<leader>;", function() Snacks.dashboard.open() end, desc = "Dashboard" },
    },
  },
}
