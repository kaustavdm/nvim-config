-- Load options first (leader key must be set before lazy.nvim)
require("config.options")
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
