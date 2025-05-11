return {
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        "lazy.nvim",
        { path = "wezterm-types", mods = { "wezterm" } },
      },
    },
    dependencies = {
      { "gonstoll/wezterm-types", lazy = true },
    },
  },
}
