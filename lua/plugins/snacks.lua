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
            { icon = " ", key = "f", desc = "Find File", action = function()
                local git_root = vim.fs.find(".git", { path = vim.uv.cwd(), upward = true })[1]
                if git_root then
                  Snacks.dashboard.pick("git_files")
                else
                  Snacks.dashboard.pick("files")
                end
              end,
            },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { gap = 1 },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        sections = {
          require("lib.mountain_art").section(),
          require("lib.dashboard_status").section(),
          { padding = 1 },
          { section = "keys", gap = 0, padding = 1 },
        },
      },
      picker = { enabled = true },
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
      -- Picker keymaps
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Git Files" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Config Files" },
      -- Search
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Grep Word", mode = { "n", "x" } },
      { "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sr", function() Snacks.picker.resume() end, desc = "Resume Search" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      -- Buffer delete
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      -- Dashboard
      { "<leader>;", function() Snacks.dashboard.open() end, desc = "Dashboard" },
    },
  },
}
