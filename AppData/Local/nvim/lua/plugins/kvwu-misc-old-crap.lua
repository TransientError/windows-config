if require("utils").is_vscode() then
  return {}
end

return {
  {
    "udalov/kotlin-vim",
    ft = "kotlin",
  },
  { "jparise/vim-graphql", ft = "graphql" },
  { "cespare/vim-toml", ft = "toml" }
}
