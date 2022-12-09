local kvwu_material = {}

function kvwu_material.setup()
  vim.g.material_style = "darker"
  require("material").setup {
    lualine_style = "default",
    plugins = {
      "dap",
      "nvim-cmp",
      "nvim-tree",
      "telescope",
      "which-key",
      "gitsigns",
    },
    custom_colors = function(colors)
      colors.editor.fg = "#eeffff"
      colors.editor.fg_dark = colors.main.red
      colors.syntax.colors = "#546e7a"
      colors.editor.selection = "#2c2c2c"
      colors.main.red = "#ff5370"
      colors.editor.accent = colors.main.cyan
      colors.syntax.type = colors.main.yellow
    end,
  }
  vim.cmd "colorscheme material"
end

return kvwu_material
