-- Dashboard status line: git branch badge, diff counts, cwd breadcrumbs.
-- Mirrors lualine's visual conventions (icons, separators, highlight groups).

local M = {}

-- Highlight groups matching lualine's sections:
--   branch  → Constant  (like lualine_b section accent)
--   diff    → DiagnosticOk / DiagnosticError (like lualine diff component)
--   path    → Comment / Normal (like lualine_c pretty_path)
--   chrome  → NonText (separators, brackets)
local HL = {
  branch = "Constant",
  added = "DiagnosticOk",
  removed = "DiagnosticError",
  path_sep = "NonText",
  path_dir = "Comment",
  path_leaf = "Title",
  chrome = "NonText",
}

--- Get the current git branch name, or nil if not in a git repo.
---@param cwd string
---@return string|nil
local function git_branch(cwd)
  local out = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " rev-parse --abbrev-ref HEAD 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return nil
  end
  return vim.trim(out)
end

--- Get file-level git status counts.
---@param cwd string
---@return {added: number, removed: number}|nil
local function git_status(cwd)
  local out = vim.fn.system("git -C " .. vim.fn.shellescape(cwd) .. " status --porcelain 2>/dev/null")
  if vim.v.shell_error ~= 0 then
    return nil
  end

  local added, removed = 0, 0
  for line in out:gmatch("[^\n]+") do
    local x, y = line:sub(1, 1), line:sub(2, 2)
    if x == "D" or y == "D" then
      removed = removed + 1
    elseif x ~= " " or y ~= " " then
      added = added + 1
    end
  end
  return { added = added, removed = removed }
end

--- Convert cwd to full breadcrumb text segments.
---@param cwd string
---@return table[] snacks text segments
local function path_breadcrumbs(cwd)
  local home = vim.env.HOME or ""
  local display = cwd
  if home ~= "" and display:sub(1, #home) == home then
    display = "~" .. display:sub(#home + 1)
  end

  local parts = {}
  for part in display:gmatch("[^/]+") do
    parts[#parts + 1] = part
  end

  local segments = {}
  for i, part in ipairs(parts) do
    local hl = (i == #parts) and HL.path_leaf or HL.path_dir
    segments[#segments + 1] = { part, hl = hl }
    if i < #parts then
      segments[#segments + 1] = { " › ", hl = HL.path_sep }
    end
  end
  return segments
end

--- Returns a snacks dashboard section generator function.
--- Format: [ branch] +N -N : ~ › path › leaf
function M.section()
  return function()
    local cwd = vim.uv.cwd() or vim.fn.getcwd()
    local branch = git_branch(cwd)
    local status = branch and git_status(cwd) or nil

    local segments = {}

    -- [ branch] badge
    if branch then
      segments[#segments + 1] = { "[ ", hl = HL.chrome }
      segments[#segments + 1] = { " " .. branch .. " ", hl = HL.branch }
      segments[#segments + 1] = { "]", hl = HL.chrome }
    end

    -- +N -N diff counts (only when there are changes)
    if status and (status.added > 0 or status.removed > 0) then
      segments[#segments + 1] = { " ", hl = HL.chrome }
      segments[#segments + 1] = { "+" .. status.added, hl = HL.added }
      segments[#segments + 1] = { " ", hl = HL.chrome }
      segments[#segments + 1] = { "-" .. status.removed, hl = HL.removed }
    end

    -- : separator
    if branch then
      segments[#segments + 1] = { " : ", hl = HL.chrome }
    end

    -- Path breadcrumbs
    local path_segs = path_breadcrumbs(cwd)
    for _, seg in ipairs(path_segs) do
      segments[#segments + 1] = seg
    end

    return {
      { text = segments, align = "center" },
    }
  end
end

return M
