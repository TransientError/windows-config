local utils = require "utils"
if utils.is_vscode() then
  return {}
end

return {
  {
    "mfussenegger/nvim-dap",
    cond = utils.not_vscode,
    lazy = true,
    keys = function()
      local dap = require "dap"
      return {
        { "<leader>db", dap.toggle_breakpoint },
        { "<leader>dc", dap.continue },
        { "<leader>dx", dap.repl.toggle },
      }
    end,
    init = function()
      vim.fn.sign_define("DapBreakpoint", { text = "🛑", texthl = "", linehl = "", numhl = "" })
    end,
    config = function()
      local dap = require "dap"
      dap.adapters["netcoredbg"] = {
        type = "executable",
        command = vim.fn.exepath "netcoredbg",
        args = { "--interpreter=vscode" },
        options = {
          detached = false,
        },
      }
      dap.configurations["cs"] = {
        {
          type = "netcoredbg",
          name = "Launch file",
          request = "launch",
          program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
        },
      }
    end,
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    opts = {
      "/home/kvwu/.venvs/debugpy/bin/python",
    },
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = "mfussenegger/nvim-dap",
    opts = {},
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    cond = utils.not_vscode,
    pin = true,
    ft = "typescript",
    dependencies = {
      "mfussenegger/nvim-dap",
      {
        "microsoft/vscode-js-debug",
        lazy = true,
        build = "npm install --legacy-peer-deps && npm run compile && rm package-lock.json",
        pin = true,
      },
    },
    config = function()
      require("dap-vscode-js").setup {
        adapters = { "pwa-node" },
      }

      require("dap").configurations["typescript"] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          runtimeArgs = { "--nolazy", "-r", "ts-node/register", "--loader", "ts-node/esm.mjs" },
          cwd = "${fileDirname}",
          args = "${file}",
          sourceMaps = true,
        },
      }
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    cond = utils.not_vscode,
    keys = { "<leader>dh", {
      "<leader>do",
      function()
        require("dapui").toggle {}
      end,
      desc = "Toggle DAP UI",
    } },
    config = function()
      local dap, dapui = require "dap", require "dapui"
      dapui.setup {
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              "breakpoints",
              "stacks",
              { id = "scopes", size = 0.25 },
              "watches",
            },
            size = 40, -- 40 columns
            position = "right",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
      }
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open {}
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close {}
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close {}
      end

      local hydra = require "hydra"
      local hint = [[
         _n_: step over   _c_: Continue/Start   _b_: Breakpoint     
         _i_: step into   _X_: Quit             _C_: Close session
         _o_: step out    _R_: Reset size       _q_: exit             
      ]]

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
          { "C", dapui.close, { silent = true } },
          {
            "R",
            function()
              dapui.open { reset = true }
            end,
            { silent = true },
          },
        },
        config = {
          color = "pink",
          invoke_on_body = true,
          hint = {
            position = "bottom",
          },
        },
      }
    end,
    dependencies = { "nvim-neotest/nvim-nio" },
  },
  {
    "nvimtools/hydra.nvim",
    lazy = true,
  },
}
