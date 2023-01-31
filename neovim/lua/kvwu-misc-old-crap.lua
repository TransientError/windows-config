local kvwu_crap = {}

function kvwu_crap.setup(use, not_vscode)
  use {
    "udalov/kotlin-vim",
    ft = "kotlin",
    cond = not_vscode,
  }
  use { "jparise/vim-graphql", ft = "graphql" }
  use { "cespare/vim-toml", ft = "toml" }
end

return kvwu_crap
