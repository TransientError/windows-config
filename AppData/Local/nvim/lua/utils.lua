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

function utils.not_vscode()
  return fn.exists "g:vscode" == 0
end

---@generic T
---@param ... (T[]|T)[] 
---@return T[]
function utils.concat(...)
  local t = {}
  for _, v in ipairs { ... } do
    if type(v) == "table" then
      for _, v2 in ipairs(v) do
        table.insert(t, v2)
      end
    else
      table.insert(t, v)
    end
  end
  return t
end

---@generic K, V
---@param ... table<K, V>[]
---@return table<K, V>
function utils.merge(...)
  local t = {}
  for _, v in ipairs { ... } do
    for k, v2 in pairs(v) do
      t[k] = v2
    end
  end
  return t
end

return utils
