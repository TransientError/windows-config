local kvwu_lualine = {}

function kvwu_lualine.setup()
  local colors = require "material.colors"
  require("lualine").setup {
    options = {
      theme = {
        normal = {
          a = { fg = colors.editor.bg, bg = colors.main.cyan, gui = "bold" },
          b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
          c = { fg = colors.editor.fg, bg = colors.editor.selection },
        },
        insert = {
          a = { fg = colors.editor.bg, bg = colors.main.purple, gui = "bold" },
          b = { fb = colors.editor.fg, bg = colors.editor.line_numbers },
        },
        visual = {
          a = { fg = colors.editor.bg, bg = colors.main.blue, gui = "bold" },
          b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
        },
        replace = {
          a = { fg = colors.editor.bg, bg = colors.main.green, gui = "bold" },
          b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
        },
        command = {
          a = { fg = colors.editor.bg, bg = colors.main.yellow, gui = "bold" },
          b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
        },
        inactive = {
          a = { fg = colors.editor.fg, bg = colors.editor.bg, gui = "bold" },
          b = { fg = colors.editor.fg, bg = colors.editor.line_numbers },
          c = { fg = colors.editor.fg, bg = colors.editor.selection },
        },
      },
    },
  }
end

return kvwu_lualine
