return {
  {
    "folke/snacks.nvim",
    opts = {
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
            -- { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            -- { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            -- { gap = 1 },
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
          -- { section = "startup" },
        },
      },
    },
  },
}
