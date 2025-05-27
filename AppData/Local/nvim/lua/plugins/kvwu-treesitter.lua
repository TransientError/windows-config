local utils = require "utils"
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    cond = utils.not_vscode,
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function(args)
          local ft = vim.bo.filetype
          local lang = vim.treesitter.language.get_lang(ft)
          if lang == nil then
            return
          end

          if vim.treesitter.language.add(lang) then
            vim.treesitter.start(args.buf, lang)
          else
            error(string.format("treesitter not installed for %s", lang))
          end
        end,
      })

      vim.treesitter.language.register("powershell", "ps1")
    end,
  },
}
