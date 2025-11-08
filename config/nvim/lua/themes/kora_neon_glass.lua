local base = require "themes.kora_neon"
local M = vim.deepcopy(base)

local function ensure(tbl, key)
  tbl[key] = tbl[key] or {}
  return tbl[key]
end

local transparent_groups = {
  "Normal",
  "NormalNC",
  "NormalFloat",
  "SignColumn",
  "EndOfBuffer",
  "StatusLineNC",
  "WinSeparator",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NvimTreeNormal",
  "NvimTreeNormalNC",
  "TelescopeNormal",
  "TelescopeBorder",
  "FloatBorder",
  "NoiceCmdlinePopup",
}

M.polish_hl = M.polish_hl or {}
M.polish_hl.defaults = M.polish_hl.defaults or {}

for _, group in ipairs(transparent_groups) do
  M.polish_hl.defaults[group] = vim.tbl_deep_extend("force", M.polish_hl.defaults[group] or {}, { bg = "NONE" })
end

M.polish_hl.defaults.CursorLine = vim.tbl_deep_extend("force", ensure(M.polish_hl.defaults, "CursorLine"), { bg = "#11131a" })
M.polish_hl.defaults.StatusLine = vim.tbl_deep_extend("force", ensure(M.polish_hl.defaults, "StatusLine"), { bg = "#14161e", fg = base.base_30.white })
M.polish_hl.defaults.Pmenu = { bg = "#14161e", fg = base.base_30.white }
M.polish_hl.defaults.PmenuSel = { bg = "#1e212c", fg = base.base_30.blue, bold = true }

return M
