local g = vim.g
local opt = vim.opt
local fn = vim.fn
local cmd = vim.cmd

local utils = {}

function utils.process_settings(settings_table)
  for k, v in pairs(settings_table.opt) do
    opt[k] = v
  end

  if settings_table.g ~= nil then
    for k, v in pairs(settings_table.g) do
      g[k] = v
    end
  end
end

function utils.vscode()
  return fn.exists "g:vscode" ~= 0
end

return utils
