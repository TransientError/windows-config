local kvwu_cmp = {}

function kvwu_cmp.setup()
  local cmp = require "cmp"

  vim.opt.completeopt = { "menu", "menuone", "noselect" }

  cmp.setup {
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert {
      ["<C-b>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<C-Space>"] = cmp.mapping.complete(),
      ["<C-e>"] = cmp.mapping.abort(),
      ["<CR>"] = cmp.mapping.confirm { select = true },
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { "i", "s" }),
      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { "i", "s" }),
    },
    sources = cmp.config.sources {
      { name = "nvim_lsp" },
      { name = "vsnip" },
    },
    {
      { name = "buffer" },
    },
  }

  cmp.setup.filetype("gitcommit", {
    sources = cmp.config.sources {
      { name = "cmp_git" },
    },
    {
      { name = "buffer" },
    },
  })

  cmp.setup.cmdline({ "/", "?" }, { mapping = cmp.mapping.preset.cmdline(), sources = { { name = "buffer" } } })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources { { name = "path" } },
    { name = "cmdline" },
  })

  local capabilities = require("cmp_nvim_lsp").default_capabilities()
  local lspconfig = require "lspconfig"
  local on_attach = function(client, bufnr)
    print "LSP Attached"
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
    vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set("n", "<space>wl", function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
    vim.keymap.set("n", "<space>f", function()
      vim.lsp.buf.format { async = true }
    end, bufopts)
  end

  lspconfig["pyright"].setup { capabilities = capabilities, on_attach = on_attach }
  lspconfig["sumneko_lua"].setup {
    settings = {
      Lua = {
        runtime = { version = "LuaJIT" },
        diagnostics = { globals = { "vim", "use" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
    capabilities = capabilities,
    on_attach = on_attach,
  }
  lspconfig["omnisharp"].setup {
    cmd = { "dotnet", "/usr/lib/omnisharp-roslyn/OmniSharp.dll" },
    enable_roslyn_analyzers = true,
    organize_imports_on_format = true,
    enable_import_completion = true,
    analyze_open_documents_only = true,
    capabilities = capabilities,
    on_attach = on_attach,
  }
  lspconfig["rust_analyzer"].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
      ["rust_analyzer"] = {
        procMacro = {
          enable = true,
        }
      }
    }
  }
end

return kvwu_cmp
