return {
  "glacambre/firenvim",
  build = function()
    vim.fn["firenvim#install"](0)
  end,
  cond = vim.g.started_by_firenvim,
  config = function()
    vim.g.firenvim_config = {
      localSettings = {
        ["https://mail.google.com/"] = {
          takeover = "never",
        },
        ["https://chat.openai.com/"] = {
          takeover = "never",
        },
        ["https://google.com/"] = {
          takeover = "never"
        },
        ["https://mail.proton.me/"] = {
          selector = "#rooster-editor"
        }
      }
    }
  end,
}
