return {
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {},
    init = function()
      vim.g.indent_blankline_filetype = { "python" }
    end,
    ft = { "python", "yaml" },
  },
  { "michaeljsmith/vim-indent-object", ft = { "python", "yaml" } },
}
