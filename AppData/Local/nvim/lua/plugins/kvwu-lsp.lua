return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufWritePost", "BufNewFile" },
    init = function()
      vim.opt.completeopt = { "menuone", "noselect", "menu" }
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          print "LSP Attached"

          local bufopts = { noremap = true, silent = true, buffer = bufnr }
          vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
          vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
          vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
          vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
          vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, bufopts)
          vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, bufopts)
          vim.keymap.set("n", "gu", vim.lsp.buf.references, bufopts)

          local builtin = require "telescope.builtin"
          vim.keymap.set("n", "<leader>si", builtin.lsp_document_symbols, bufopts)
          vim.keymap.set("n", "<leader>sI", builtin.lsp_workspace_symbols, bufopts)
        end,
      })

      vim.keymap.set("n", "<C-k>", vim.diagnostic.open_float)

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = {
                "lua/?.lua",
                "lua/?/init.lua",
              },
            },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.api.nvim_get_runtime_file("", true),
              },
            },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("powershell_es", {
        bundle_path = os.getenv "USERPROFILE" .. "/utils/PowerShellEditorServices",
      })

      local json_capabilities = vim.lsp.protocol.make_client_capabilities()
      json_capabilities.textDocument.completion.completionItem.snippetSupport = true
      vim.lsp.config("jsonls", {
        capabilities = json_capabilities,
      })

      local omnisharp_extended = require "omnisharp_extended"
      vim.lsp.config("omnisharp", {
        enable_roslyn_analyzers = true,
        organize_imports_on_format = true,
        enable_import_completion = true,
        analyze_open_documents_only = true,
        handlers = {
          ["textDocument/definition"] = omnisharp_extended.handler,
        },
      })

      vim.lsp.enable { "lua_ls", "powershell_es", "ts_ls", "pyright", "omnisharp", "jsonls" }
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    config = function()
      local cmp = require "cmp"
      cmp.setup {
        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },
        window = {
          documentation = cmp.config.window.bordered(),
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
      vim.lsp.config("*", {
        capabilities = capabilities,
      })
    end,
    dependencies = {
      { "hrsh7th/cmp-nvim-lsp", lazy = true },
      { "hrsh7th/cmp-path", lazy = true },
      { "hrsh7th/cmp-cmdline", lazy = true },
      { "ray-x/cmp-treesitter", lazy = true },
      { "hrsh7th/cmp-buffer", lazy = true },
      { "hrsh7th/cmp-vsnip", lazy = true },
      { "hrsh7th/vim-vsnip", lazy = true },
      { "Hoffs/omnisharp-extended-lsp.nvim", lazy = true },
    },
  },
}
