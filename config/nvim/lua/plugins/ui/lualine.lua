local colors = {
  bg = '#0b0a12', fg = '#f8f8f2',
  yellow = '#FFD166', cyan = '#00CFFF', darkblue = '#0b1020',
  green = '#7CFF00', orange = '#FF8800', violet = '#9A6CFF',
  magenta = '#FF2D95', blue = '#51afef', red = '#FF5555'
}

local conditions = {
  buffer_not_empty = function() return vim.fn.empty(vim.fn.expand('%:t')) ~= 1 end,
  hide_in_width = function() return vim.fn.winwidth(0) > 80 end,
  check_git_workspace = function()
    local filepath = vim.fn.expand('%:p:h')
    local gitdir = vim.fn.finddir('.git', filepath .. ';')
    return gitdir and #gitdir > 0 and #gitdir < #filepath
  end
}

local config = {
  options = {
    component_separators = '',
    section_separators = '',
    theme = {
      normal = { c = { fg = colors.fg, bg = 'NONE' } },
      inactive = { c = { fg = colors.fg, bg = 'NONE' } },
    },
    globalstatus = true,
  },
  sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
  inactive_sections = { lualine_a = {}, lualine_b = {}, lualine_c = {}, lualine_x = {}, lualine_y = {}, lualine_z = {} },
}

local function ins_left(component)
  table.insert(config.sections.lualine_c, component)
end
local function ins_right(component)
  table.insert(config.sections.lualine_x, component)
end

ins_left({ function() return '▊' end, color = { fg = colors.blue }, padding = 0 })

ins_left({
  function()
    local mode_color = {
      n = colors.red, i = colors.green, v = colors.blue, ['\\16'] = colors.blue, V = colors.blue,
      c = colors.magenta, no = colors.red, s = colors.orange, S = colors.orange, ['\\19'] = colors.orange,
      ic = colors.yellow, R = colors.violet, Rv = colors.violet, cv = colors.red, ce = colors.red,
      r = colors.cyan, rm = colors.cyan, ['r?'] = colors.cyan, ['!'] = colors.red, t = colors.red,
    }
    vim.api.nvim_set_hl(0, 'LualineMode', { fg = mode_color[vim.fn.mode()] or colors.red, bg = colors.darkblue, bold = true })
    return ''
  end,
  color = 'LualineMode',
  padding = { left = 0, right = 1 },
})

ins_left({
  'filename',
  cond = conditions.buffer_not_empty,
  path = 1,
  color = { fg = colors.magenta, gui = 'bold' },
})

ins_left({ 'location' })
ins_left({ 'progress', color = { fg = colors.fg, gui = 'bold' } })

ins_left({
  'diagnostics',
  sources = { 'nvim_diagnostic' },
  symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' },
  diagnostics_color = {
    color_error = { fg = colors.red },
    color_warn  = { fg = colors.yellow },
    color_info  = { fg = colors.cyan },
    color_hint  = { fg = colors.violet },
  },
})

ins_left({ function() return '%=' end })

ins_left({
  function()
    local msg = 'No LSP'
    local ft = vim.bo.filetype
    for _, client in ipairs(vim.lsp.get_clients()) do
      if client.config and client.config.filetypes and vim.tbl_contains(client.config.filetypes, ft) then
        return client.name
      end
    end
    return msg
  end,
  icon = ' ',
  color = { fg = colors.cyan, gui = 'bold' },
})

ins_right({ 'o:encoding', cond = conditions.hide_in_width, color = { fg = colors.green, gui = 'bold' } })
ins_right({ 'fileformat', icons_enabled = false, cond = conditions.hide_in_width, color = { fg = colors.green, gui = 'bold' } })
ins_right({ 'branch', icon = '', cond = conditions.check_git_workspace, color = { fg = colors.violet, gui = 'bold' } })
ins_right({
  'diff',
  symbols = { added = ' ', modified = '柳 ', removed = ' ' },
  diff_color = {
    added    = { fg = colors.green },
    modified = { fg = colors.orange },
    removed  = { fg = colors.red },
  },
  cond = conditions.hide_in_width,
})

ins_right({ function() return '▊' end, color = { fg = colors.blue }, padding = 0 })

return {
  "nvim-lualine/lualine.nvim",
  opts = config,
}
