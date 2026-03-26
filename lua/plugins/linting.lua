return {
  {
    "mfussenegger/nvim-lint",
    event = { "BufWritePost", "FileType", "InsertLeave" },
    opts_extend = { "linters_by_ft" },
    opts = {
      linters_by_ft = {},
    },
    config = function(_, opts)
      local lint = require("lint")
      lint.linters_by_ft = opts.linters_by_ft

      local timer = assert(vim.uv.new_timer())
      local function debounced_lint()
        timer:stop()
        timer:start(100, 0, function()
          vim.schedule(function()
            lint.try_lint()
          end)
        end)
      end

      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
        group = vim.api.nvim_create_augroup("nvim_lint", { clear = true }),
        callback = debounced_lint,
      })

      -- Clean up timer on exit
      vim.api.nvim_create_autocmd("VimLeavePre", {
        callback = function()
          if not timer:is_closing() then
            timer:close()
          end
        end,
      })
    end,
  },
}
