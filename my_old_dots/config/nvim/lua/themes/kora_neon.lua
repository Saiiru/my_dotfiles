local M = {}

M.base_30 = {
  white = "#e6edf3",
  darker_black = "#050607",
  black = "#0a0b0d",
  black2 = "#0f1115",
  one_bg = "#12151b",
  one_bg2 = "#171b22",
  one_bg3 = "#1f232a",
  grey = "#3c4250",
  grey_fg = "#4c566a",
  grey_fg2 = "#586270",
  light_grey = "#768390",
  red = "#ff073a",
  baby_pink = "#ee79d1",
  pink = "#ee79d1",
  line = "#171b22",
  green = "#22e3b3",
  vibrant_green = "#44f7c5",
  nord_blue = "#6cb6ff",
  blue = "#6cb6ff",
  seablue = "#22d3ee",
  yellow = "#facc15",
  sun = "#ffd95a",
  purple = "#7c3aed",
  dark_purple = "#5f2ab3",
  teal = "#39c5cf",
  orange = "#ff6600",
  cyan = "#22d3ee",
  statusline_bg = "#0f1115",
  lightbg = "#12151b",
  pmenu_bg = "#22d3ee",
  folder_bg = "#22d3ee",
  infoForeground = "#6cb6ff",
  diagnostic_error = "#ff073a",
  diagnostic_warn = "#facc15",
  diagnostic_info = "#6cb6ff",
  diagnostic_hint = "#7c3aed",
  selectionBackground = "#1b2230",
}

M.base_16 = {
  base00 = M.base_30.black,
  base01 = M.base_30.black2,
  base02 = M.base_30.one_bg,
  base03 = M.base_30.one_bg3,
  base04 = M.base_30.grey_fg2,
  base05 = M.base_30.white,
  base06 = "#f0f6fc",
  base07 = "#ffffff",
  base08 = M.base_30.red,
  base09 = M.base_30.orange,
  base0A = M.base_30.yellow,
  base0B = M.base_30.green,
  base0C = M.base_30.cyan,
  base0D = M.base_30.blue,
  base0E = M.base_30.purple,
  base0F = M.base_30.pink,
}

M.extras = {
  diff_add = "#244032",
  diff_delete = "#422b2b",
  diff_change = "#314c72",
}

local C = M.base_30
local E = M.extras

M.polish_hl = {
  defaults = {
    LineNr = { fg = C.grey_fg },
    CursorLineNr = { fg = C.blue, bold = true },
    Search = { fg = C.black, bg = C.blue },
    IncSearch = { fg = C.black, bg = C.cyan },
    CurSearch = { fg = C.black, bg = C.cyan },
    Substitute = { fg = C.white, bg = C.dark_purple },
    DiffAdd = { bg = E.diff_add, fg = C.green },
    DiffDelete = { bg = E.diff_delete, fg = C.red },
    DiffChange = { bg = E.diff_change, fg = C.blue },
    DiffText = { bg = E.diff_change, fg = C.white, bold = true },
    GitSignsAdd = { fg = C.green },
    GitSignsChange = { fg = C.blue },
    GitSignsDelete = { fg = C.red },
  },
  treesitter = {
    ["@comment"] = { fg = C.light_grey, italic = true },
    ["@keyword"] = { fg = C.red },
    ["@keyword.function"] = { fg = C.red },
    ["@function"] = { fg = C.blue },
    ["@function.builtin"] = { fg = C.nord_blue },
    ["@string"] = { fg = "#96d0ff" },
    ["@number"] = { fg = C.yellow },
    ["@boolean"] = { fg = C.yellow },
    ["@type"] = { fg = C.teal },
    ["@constant"] = { fg = C.blue },
    ["@variable"] = { fg = C.white },
    ["@variable.builtin"] = { fg = C.orange, italic = true },
    ["@punctuation.bracket"] = { fg = C.red },
    ["@lsp.type.class"] = { fg = "#96d0ff" },
    ["@lsp.type.interface"] = { fg = "#96d0ff", italic = true },
    ["@lsp.type.parameter"] = { fg = C.pink },
    ["@lsp.type.property"] = { fg = C.white },
  },
}

-- Runtime palette + utilities ----------------------------------------------
local kitty_palette = {
  bg1 = "#0a0b0d",
  fg1 = "#e6edf3",
  red = "#ff073a",
  magenta = "#7c3aed",
  cyan = "#22d3ee",
  shadow = "#1f232a",
}

local glass_palette = {
  bg = "#0B0A12",
  surf = "#141127",
  base = "#1A1A2E",
  float = "#1E1E2E",
  text = "#F8F8F2",
  mut = "#6C7086",
  dim = "#262533",
  pink = "#FF2D95",
  mag = "#FF6EC7",
  cyan = "#00F0FF",
  blue = "#00CFFF",
  purp = "#9A6CFF",
  yel = "#FFD166",
  grn = "#7CFF00",
  red = "#FF5555",
}

local transparent_groups = {
  "Normal",
  "NormalNC",
  "SignColumn",
  "FoldColumn",
  "EndOfBuffer",
  "LineNr",
  "CursorLine",
  "CursorLineNr",
  "ColorColumn",
  "MsgArea",
  "NormalFloat",
  "FloatBorder",
  "Pmenu",
  "PmenuSel",
  "PmenuSbar",
  "PmenuThumb",
  "TelescopeNormal",
  "TelescopeBorder",
  "TelescopePromptNormal",
  "TelescopePromptBorder",
  "WhichKeyFloat",
  "LazyNormal",
  "NeoTreeNormal",
  "NeoTreeNormalNC",
  "NvimTreeNormal",
  "NvimTreeNormalNC",
  "NvimTreeEndOfBuffer",
  "CmpPmenu",
  "StatusLine",
  "StatusLineNC",
  "TabLine",
  "TabLineFill",
  "TabLineSel",
}

local state = { transparent = true, boost = 1 }
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

local function apply_transparency()
  local bg_val = state.transparent and "NONE" or kitty_palette.bg1
  for _, group in ipairs(transparent_groups) do
    local ok, def = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
    local fg = ok and def.fg or nil
    hl(group, vim.tbl_extend("force", {}, fg and { fg = fg } or {}, { bg = bg_val }))
  end
end

local function apply_core()
  local P = glass_palette
  local bg_float = state.transparent and "NONE" or P.float
  local bg_norm = state.transparent and "NONE" or P.base
  local cursorline_bg = state.transparent and "#17152b" or P.surf

  hl("Normal", { fg = P.text, bg = bg_norm })
  hl("NormalNC", { fg = P.text, bg = bg_norm })
  hl("NormalFloat", { fg = P.text, bg = bg_float })
  hl("FloatBorder", { fg = P.purp, bg = "NONE" })
  hl("WinSeparator", { fg = kitty_palette.shadow, bg = "NONE" })
  hl("LineNr", { fg = P.mut })
  hl("CursorLine", { bg = cursorline_bg })
  hl("CursorLineNr", { fg = P.pink, bold = true })
  hl("ColorColumn", { bg = "#17152b" })
  hl("EndOfBuffer", { fg = state.transparent and "NONE" or P.bg, bg = "NONE" })

  hl("StatusLine", { fg = P.text, bg = state.transparent and "NONE" or P.surf })
  hl("StatusLineNC", { fg = P.mut, bg = "NONE" })
  hl("TabLine", { bg = "NONE", fg = P.mut })
  hl("TabLineSel", { bg = P.pink, fg = P.bg, bold = true })
  hl("TabLineFill", { bg = "NONE" })

  hl("Pmenu", { bg = "#1a1830", fg = P.text })
  hl("PmenuSel", { bg = state.boost == 2 and P.mag or P.purp, fg = P.bg, bold = true })
  hl("PmenuSbar", { bg = P.dim })
  hl("PmenuThumb", { bg = P.cyan })

  hl("@comment", { fg = P.purp, italic = true })
  hl("@keyword", { fg = P.pink, italic = true })
  hl("@keyword.function", { fg = P.pink, italic = true })
  hl("@string", { fg = P.grn })
  hl("@string.escape", { fg = P.yel, bold = true })
  hl("@function", { fg = P.cyan })
  hl("@function.call", { fg = P.cyan })
  hl("@method", { fg = P.cyan })
  hl("@type", { fg = P.yel, italic = true })
  hl("@variable", { fg = P.text })
  hl("@property", { fg = P.grn })
  hl("@parameter", { fg = P.yel, italic = true })
  hl("@operator", { fg = P.pink })

  hl("@lsp.type.namespace", { fg = P.yel, italic = true })
  hl("@lsp.type.class", { fg = P.yel, italic = true })
  hl("@lsp.type.interface", { fg = P.yel, italic = true })
  hl("@lsp.type.enum", { fg = P.yel, italic = true })
  hl("@lsp.type.parameter", { fg = P.yel, italic = true })
  hl("@lsp.type.property", { fg = P.grn })
  hl("@lsp.type.method", { fg = P.cyan })
  hl("@lsp.type.function", { fg = P.cyan })
  hl("@lsp.type.variable", { fg = P.text })

  hl("DiagnosticError", { fg = P.red })
  hl("DiagnosticWarn", { fg = P.yel })
  hl("DiagnosticInfo", { fg = P.cyan })
  hl("DiagnosticHint", { fg = P.purp })

  hl("TelescopeBorder", { fg = P.purp, bg = "NONE" })
  hl("TelescopePromptBorder", { fg = P.pink, bg = "NONE" })
  hl("TelescopeSelection", { bg = P.blue, fg = P.bg, bold = true })
  hl("TelescopeMatching", { fg = P.grn, bold = true })

  hl("SnacksNotifierBorderInfo", { fg = P.cyan })
  hl("SnacksNotifierIconInfo", { fg = P.cyan })
  hl("NoiceCmdlinePopupBorder", { fg = P.purp })
  hl("NotifyBackground", { bg = "NONE" })

  hl("GitSignsAdd", { fg = P.grn })
  hl("GitSignsChange", { fg = P.yel })
  hl("GitSignsDelete", { fg = P.red })

  vim.g.terminal_color_0 = P.bg
  vim.g.terminal_color_1 = P.pink
  vim.g.terminal_color_2 = P.grn
  vim.g.terminal_color_3 = P.yel
  vim.g.terminal_color_4 = P.cyan
  vim.g.terminal_color_5 = P.mag
  vim.g.terminal_color_6 = P.purp
  vim.g.terminal_color_7 = P.text
  vim.g.terminal_color_8 = P.dim
  vim.g.terminal_color_9 = P.pink
  vim.g.terminal_color_10 = P.grn
  vim.g.terminal_color_11 = P.yel
  vim.g.terminal_color_12 = P.blue
  vim.g.terminal_color_13 = P.mag
  vim.g.terminal_color_14 = P.purp
  vim.g.terminal_color_15 = "#FFFFFF"

  apply_transparency()
end

local runtime = {}

function runtime.set(theme)
  theme = theme or vim.g.neosairu_theme or "cyberdream"
  vim.schedule(function()
    if not pcall(vim.cmd.colorscheme, theme) then
      vim.notify("Failed to load colorscheme: " .. theme, vim.log.levels.WARN)
    end
    apply_core()
  end)
end

function runtime.transparent(mode)
  if mode == "toggle" then
    state.transparent = not state.transparent
  elseif mode == nil then
    state.transparent = true
  else
    state.transparent = not not mode
  end
  apply_core()
end

function runtime.toggle_transparency()
  runtime.transparent("toggle")
  vim.notify(state.transparent and "Transparency ON" or "Transparency OFF", vim.log.levels.INFO)
end

function runtime.boost(level)
  level = tonumber(level) or 1
  state.boost = math.max(0, math.min(2, level))
  apply_core()
end

function runtime.setup()
  local group = vim.api.nvim_create_augroup("neosairu_colors", { clear = true })
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = apply_core,
  })

  vim.api.nvim_create_user_command("NeoTheme", function(o)
    if o.args ~= "" then
      vim.g.neosairu_theme = o.args
    end
    runtime.set(vim.g.neosairu_theme)
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("NeoTransparent", function(o)
    local arg = o.args
    if arg == "on" then
      runtime.transparent(true)
    elseif arg == "off" then
      runtime.transparent(false)
    else
      runtime.toggle_transparency()
    end
  end, { nargs = "?" })

  vim.api.nvim_create_user_command("NeoBoost", function(o)
    runtime.boost(o.args)
  end, { nargs = "?" })

  _G.ColorMyPencils = function(color)
    if color and color ~= "" then
      vim.g.neosairu_theme = color
    end
    runtime.set(vim.g.neosairu_theme)
    runtime.transparent(true)
  end

  runtime.set(vim.g.neosairu_theme)
end

M.runtime = runtime

return M
