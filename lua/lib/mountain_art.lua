-- Mountain with clouds dashboard art (16:9, 64x18)
-- Uses standard Neovim highlight groups so colors follow the active theme.

local M = {}

-- Map art elements to standard Neovim highlight groups.
-- These resolve dynamically to whatever the active colorscheme defines.
local HL = {
  sky = "Comment",
  cloud = "Normal",
  snow = "Normal",
  rock = "NonText",
  grass = "String",
  sun = "DiagnosticWarn",
  border = "FloatBorder",
}

local W = 62 -- inner width (64 total with borders)

--- Build the character grid. Each cell is {char, hl_group}.
---@return table[] rows, each row is an array of {string, string} cells
local function generate()
  local rows = {}

  local function new_row()
    local row = {}
    for i = 1, W do
      row[i] = { "░", HL.sky }
    end
    return row
  end

  -- Row 1: sky
  rows[#rows + 1] = new_row()

  -- Row 2: sun
  local r = new_row()
  for i = 51, 56 do r[i] = { "░", HL.sun } end
  for i = 52, 55 do r[i] = { "█", HL.sun } end
  rows[#rows + 1] = r

  -- Row 3: left cloud + sun glow
  r = new_row()
  for i = 6, 15 do r[i] = { "█", HL.cloud } end
  for i = 51, 55 do r[i] = { "░", HL.sun } end
  r[53] = { "█", HL.sun }
  r[54] = { "█", HL.sun }
  rows[#rows + 1] = r

  -- Row 4: bigger left cloud + right cloud
  r = new_row()
  for i = 4, 18 do r[i] = { "█", HL.cloud } end
  for i = 36, 43 do r[i] = { "█", HL.cloud } end
  rows[#rows + 1] = r

  -- Row 5: cloud bottoms
  r = new_row()
  for i = 5, 16 do r[i] = { "▓", HL.cloud } end
  for i = 37, 42 do r[i] = { "▓", HL.cloud } end
  rows[#rows + 1] = r

  -- Row 6: sky gap
  rows[#rows + 1] = new_row()

  -- Mountain (8 rows)
  local mtn_peak = 29
  for mi = 0, 7 do
    r = new_row()
    local spread = math.floor(mi * 1.75)
    local left = mtn_peak - spread
    local right = mtn_peak + spread + 2

    -- Secondary mountain (behind main)
    local m2_peak = 49
    local m2_spread = math.floor((mi - 2) * 1.5)
    local m2_left = m2_peak - m2_spread
    local m2_right = m2_peak + m2_spread + 2
    if mi >= 2 then
      for j = math.max(1, m2_left), math.min(W, m2_right - 1) do
        if j < left or j >= right then
          r[j] = { "▒", HL.rock }
        end
      end
    end

    for j = math.max(1, left), math.min(W, right - 1) do
      if mi <= 1 then
        r[j] = { "█", HL.snow }
      elseif mi <= 2 then
        if (j + mi) % 3 == 0 then
          r[j] = { "▓", HL.snow }
        else
          r[j] = { "▒", HL.rock }
        end
      elseif mi <= 4 then
        if (j + mi) % 5 == 0 then
          r[j] = { "█", HL.rock }
        elseif (j * mi) % 7 == 0 then
          r[j] = { "░", HL.rock }
        else
          r[j] = { "▓", HL.rock }
        end
      else
        if (j + mi) % 4 == 0 then
          r[j] = { "█", HL.grass }
        elseif (j * mi) % 3 == 0 then
          r[j] = { "▒", HL.grass }
        else
          r[j] = { "▓", HL.grass }
        end
      end
    end

    rows[#rows + 1] = r
  end

  -- Ground (2 rows)
  for gi = 0, 1 do
    r = {}
    for j = 1, W do
      if (j + gi) % 5 == 0 then
        r[j] = { "█", HL.grass }
      elseif (j + gi) % 3 == 0 then
        r[j] = { "░", HL.grass }
      else
        r[j] = { "▒", HL.grass }
      end
    end
    rows[#rows + 1] = r
  end

  return rows
end

--- Convert a row of cells into a text segments array for snacks dashboard.
--- Merges consecutive cells with the same hl group into single segments.
---@param row table[] array of {char, hl_group}
---@return table[] segments array of {text, hl=group}
local function row_to_segments(row)
  local segments = { { "║", hl = HL.border } }
  local buf = ""
  local cur_hl = nil

  for _, cell in ipairs(row) do
    if cell[2] == cur_hl then
      buf = buf .. cell[1]
    else
      if cur_hl then
        segments[#segments + 1] = { buf, hl = cur_hl }
      end
      buf = cell[1]
      cur_hl = cell[2]
    end
  end
  if cur_hl then
    segments[#segments + 1] = { buf, hl = cur_hl }
  end

  segments[#segments + 1] = { "║", hl = HL.border }
  return segments
end

--- Returns a snacks dashboard section generator function.
--- Use in dashboard sections: require("lib.mountain_art").section()
function M.section()
  return function()
    local rows = generate()
    local items = {}

    -- Top border
    items[#items + 1] = {
      text = { { "╔" .. ("═"):rep(W) .. "╗", hl = HL.border } },
      align = "center",
    }

    -- Art rows
    for _, row in ipairs(rows) do
      items[#items + 1] = { text = row_to_segments(row), align = "center" }
    end

    -- Bottom border
    items[#items + 1] = {
      text = { { "╚" .. ("═"):rep(W) .. "╝", hl = HL.border } },
      align = "center",
    }

    return items
  end
end

return M
