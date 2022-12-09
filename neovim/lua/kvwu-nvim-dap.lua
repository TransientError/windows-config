local kvwu_nvim_dap = {}

function kvwu_nvim_dap.setup()
  local dap = require "dap"
  vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
  vim.keymap.set("n", "<leader>dc", dap.continue)
  vim.keymap.set("n", "<leader>dn", dap.step_over)
  vim.keymap.set("n", "<leader>dsi", dap.step_into)
  vim.keymap.set("n", "<leader>dx", dap.repl.open)

  local hydra = require "hydra"
  local hint = [[
         _n_: step over   _c_: Continue/Start   _b_: Breakpoint     
         _i_: step into   _X_: Quit                                
         _o_: step out    _q_: exit
        ]]

  vim.fn.sign_define('DapBreakpoint', {text='🛑', texthl='', linehl='', numhl=''})

  hydra {
    hint = hint,
    name = "dap",
    mode = { "n", "x" },
    body = "<leader>dh",
    heads = {
      { "n", dap.step_over, { silent = true } },
      { "i", dap.step_into, { silent = true } },
      { "o", dap.step_out, { silent = true } },
      { "c", dap.continue, { silent = true } },
      { "b", dap.toggle_breakpoint, { silent = true } },
      { "X", dap.close, { silent = true } },
      { "q", nil, { exit = true, nowait = true } },
    },
    config = {
      color = "pink",
      invoke_on_body = true,
      hint = {
        position = "bottom",
        border = "rounded",
      },
    },
  }
end

return kvwu_nvim_dap
