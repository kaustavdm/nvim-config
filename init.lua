-- Load options first (leader key must be set before lazy.nvim)
require("config.options")

-- Neovim 0.12 ui2: redesigned messages + cmdline UI. Avoids "Press ENTER"
-- interruptions and highlights the cmdline as you type, letting cmdheight=0 work
-- cleanly without the old report=9999 + CmdlineLeave substitute-count workarounds.
-- pcall-guarded since the module is still marked experimental.
pcall(function()
  require("vim._core.ui2").enable()
end)

-- Bootstrap lazy.nvim and load plugins
require("config.lazy")

-- Load keymaps and autocmds after plugins are ready
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("config.keymaps")
    require("config.autocmds")
    -- Disable diagnostics (deferred from options.lua to avoid loading
    -- vim.diagnostic module during startup)
    vim.diagnostic.enable(false)
  end,
})
