local autocmd = vim.api.nvim_create_autocmd
local augroup = function(name)
  return vim.api.nvim_create_augroup("custom_" .. name, { clear = true })
end

-- Highlight on yank
autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Resize splits when window is resized
autocmd("VimResized", {
  group = augroup("resize_splits"),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
})

-- Go to last cursor position when opening a file
autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function(event)
    local exclude = { "gitcommit" }
    local buf = event.buf
    if vim.tbl_contains(exclude, vim.bo[buf].filetype) or vim.b[buf].last_loc then
      return
    end
    vim.b[buf].last_loc = true
    local mark = vim.api.nvim_buf_get_mark(buf, '"')
    local lcount = vim.api.nvim_buf_line_count(buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Close certain filetypes with q
autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "help",
    "lspinfo",
    "notify",
    "qf",
    "checkhealth",
    "man",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "startuptime",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Auto-create parent directories when saving a file
autocmd("BufWritePre", {
  group = augroup("auto_create_dir"),
  callback = function(event)
    if event.match:match("^%w%w+:[\\/][\\/]") then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- Check if file was changed outside of vim
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  callback = function()
    if vim.o.buftype ~= "nofile" then
      vim.cmd("checktime")
    end
  end,
})

-- Carve-out: 'report' is 9999 globally (see options.lua) so cmdheight=0
-- doesn't turn ":N lines moved/indented/yanked" into hit-enter prompts. But
-- :s/foo/bar/g's "N substitutions on M lines" is genuinely useful, so we
-- temporarily drop the threshold to 0 for substitute commands and restore it
-- on the next tick (after the command has printed).
autocmd("CmdlineLeave", {
  group = augroup("substitute_count"),
  pattern = ":",
  callback = function()
    local ok, parsed = pcall(vim.api.nvim_parse_cmd, vim.fn.getcmdline(), {})
    if not ok or not parsed then
      return
    end
    if parsed.cmd ~= "substitute" and parsed.cmd ~= "smagic" and parsed.cmd ~= "snomagic" then
      return
    end
    local prev = vim.o.report
    vim.o.report = 0
    vim.schedule(function()
      vim.o.report = prev
    end)
  end,
})
