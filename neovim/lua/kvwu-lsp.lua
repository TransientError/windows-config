local kvwu_lsp = {}

function kvwu_lsp.setup(use)
  use {
    "hrsh7th/nvim-cmp",
    opt = true,
    cond = function()
      return vim.fn.exists "g:vscode" == 0
    end,
    config = function()
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
        sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }),
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
        -- vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, bufopts)
        vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
        vim.keymap.set("n", "gu", vim.lsp.buf.references, bufopts)

        local builtin = require "telescope.builtin"
        vim.keymap.set("n", "<leader>si", builtin.lsp_document_symbols, bufopts)
        vim.keymap.set("n", "<leader>sI", builtin.lsp_workspace_symbols, bufopts)
      end

      vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float)

      lspconfig["lua_ls"].setup {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim", "use", "require" } },
            workspace = { library = vim.api.nvim_get_runtime_file("", true) },
            telemetry = { enable = false },
          },
        },
        capabilities = capabilities,
        on_attach = on_attach,
      }
      lspconfig["omnisharp"].setup {
        cmd = { "omnisharp" },
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        analyze_open_documents_only = true,
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          on_attach(client, bufnr)
          client.server_capabilities.semanticTokensProvider.legend = {
            tokenModifiers = { "static" },
            tokenTypes = {
              "comment",
              "excluded",
              "identifier",
              "keyword",
              "keyword",
              "number",
              "operator",
              "operator",
              "preprocessor",
              "string",
              "whitespace",
              "text",
              "static",
              "preprocessor",
              "punctuation",
              "string",
              "string",
              "class",
              "delegate",
              "enum",
              "interface",
              "module",
              "struct",
              "typeParameter",
              "field",
              "enumMember",
              "constant",
              "local",
              "parameter",
              "method",
              "method",
              "property",
              "event",
              "namespace",
              "label",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "xml",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
              "regexp",
            },
          }
        end,
      }

      local json_capabilities = vim.lsp.protocol.make_client_capabilities()
      json_capabilities.textDocument.completion.completionItem.snippetSupport = true
      lspconfig["jsonls"].setup {
        on_attach = on_attach,
        capabilities = json_capabilities,
      }

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "qf",
        callback = function()
          vim.keymap.set("n", "q", ":close<CR>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<Esc>", ":close<CR>", { buffer = true, noremap = true })
        end,
      })

      for _, server in ipairs { "pyright", "tsserver", "gopls", "kotlin_language_server", "hls", "julials" } do
        lspconfig[server].setup {
          on_attach = on_attach,
          capabilities = capabilities,
        }
      end
    end,
    requires = {
      { "hrsh7th/cmp-path", opt = true },
      { "hrsh7th/cmp-cmdline", opt = true },
      { "ray-x/cmp-treesitter", opt = true },
      { "hrsh7th/cmp-buffer", opt = true },
      { "hrsh7th/cmp-vsnip", opt = true },
      { "hrsh7th/vim-vsnip", opt = true },
      { "hrsh7th/cmp-nvim-lsp", module = "cmp_nvim_lsp" },
      { "neovim/nvim-lspconfig", module = "lspconfig" },
    },
  }
end

return kvwu_lsp
