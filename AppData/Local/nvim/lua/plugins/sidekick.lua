if require("utils").is_vscode() then
  return {}
end

return {
  {
    "folke/sidekick.nvim",
    config = function(_, opts)
      require("sidekick").setup(opts)
      -- prefer the copilot-nes client over copilot.lua's client for NES
      local config = require("sidekick.config")
      local orig_get_client = config.get_client
      config.get_client = function(buf)
        local clients = config.get_clients({ bufnr = buf or 0 })
        for _, c in ipairs(clients) do
          if c.name == "copilot-nes" then return c end
        end
        return orig_get_client(buf)
      end
    end,
    opts = {
      nes = {
        diff = { show = "cursor" },
      },
      cli = {
        mux = { enabled = false },
        picker = "telescope",
        win = {
          keys = {
            gf = {
              "gf",
              function()
                local file = vim.fn.expand("<cfile>")
                if file == "" then return end
                local cur_win = vim.api.nvim_get_current_win()
                local wins = vim.api.nvim_tabpage_list_wins(0)
                local target
                for _, w in ipairs(wins) do
                  if w ~= cur_win then
                    target = w
                    break
                  end
                end
                if target then
                  vim.api.nvim_set_current_win(target)
                  vim.cmd.edit(file)
                else
                  vim.cmd("vsplit " .. vim.fn.fnameescape(file))
                end
              end,
              mode = "n",
              desc = "open file under cursor in editor window",
            },
            files = false,
          },
        },
      },
    },
    keys = {
      {
        "<c-.>",
        function() require("sidekick.cli").focus({ name = "copilot" }) end,
        desc = "Sidekick Focus",
        mode = { "n", "t", "i", "x" },
      },
      {
        "<leader>aa",
        function() require("sidekick.cli").toggle({ name = "copilot" }) end,
        desc = "Sidekick Toggle CLI",
      },
      {
        "<leader>as",
        function() require("sidekick.cli").select() end,
        desc = "Select CLI",
      },
      {
        "<leader>ad",
        function() require("sidekick.cli").close() end,
        desc = "Detach a CLI Session",
      },
      {
        "<leader>at",
        function() require("sidekick.cli").send({ msg = "{this}" }) end,
        mode = { "x", "n" },
        desc = "Send This",
      },
      {
        "<leader>af",
        function() require("sidekick.cli").send({ msg = "{file}" }) end,
        desc = "Send File",
      },
      {
        "<leader>av",
        function() require("sidekick.cli").send({ msg = "{selection}" }) end,
        mode = { "x" },
        desc = "Send Visual Selection",
      },
      {
        "<leader>ap",
        function() require("sidekick.cli").prompt() end,
        mode = { "n", "x" },
        desc = "Sidekick Select Prompt",
      },
    },
  },
}
