--
local snacks_lsp_pickers_filter = require("utils.snacks").lsp_pickers_filter

return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "AstroNvim/astrolsp", opts = {} },
      -- Automatically install LSPs and related tools to stdpath for Neovim
      -- Mason must be loaded before its dependents so we need to set it up here.
      -- NOTE: `opts = {}` is the same as calling `require('mason').setup({})`
      {
        "mason-org/mason.nvim",
        ---@module 'mason.settings'
        ---@type MasonSettings
        ---@diagnostic disable-next-line: missing-fields
        opts = {},
      },
      -- Maps LSP server names between nvim-lspconfig and Mason package names.
      "mason-org/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",

      -- Useful status updates for LSP.
      { "j-hui/fidget.nvim", opts = {} },
    },
    config = function()
      --  This function gets run when an LSP attaches to a particular buffer.
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
        callback = function(event)
          -- Function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or "n"
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
          end

          local snacks_picker = require("snacks").picker

          map("gd", snacks_picker.lsp_definitions, "Goto Definition")
          map("grD", snacks_picker.lsp_declarations, "Goto Declaration")
          map("gri", snacks_picker.lsp_implementations, "Goto Implementation")
          map("cd", vim.lsp.buf.rename, "Rename Symbol")
          map("grn", vim.lsp.buf.rename, "Rename Symbol")
          map("grr", snacks_picker.lsp_references, "Goto References")
          map("grt", snacks_picker.lsp_type_definitions, "Goto Type Definition")
          map("gs", snacks_picker.lsp_symbols, "Goto Document Symbols")
          map("gS", snacks_picker.lsp_workspace_symbols, "Goto Workspace Symbols")
          map("K", vim.lsp.buf.hover, "")
          map("g.", require("tiny-code-action").code_action, "Code Action")
          map("gra", require("tiny-code-action").code_action, "Code Action")

          map("<leader>ss", function()
            snacks_picker.lsp_symbols(snacks_lsp_pickers_filter)
          end, "Goto Document Symbols")
          -- map("<leader>cd", snacks_picker.diagnostics_buffer, "Document Diagnostics")
          map("<leader>cm", function()
            vim.cmd("Mason")
          end, "Mason")
          map("<leader>cli", function()
            vim.cmd("LspInfo")
          end, "LspInfo")
          map("<leader>clr", function()
            vim.cmd("LspRestart")
          end, "LspRestart")

          vim.keymap.set("n", "<leader>cd", function()
            vim.diagnostic.open_float(0, { scope = "line" })
          end, { desc = "Line Diagnostics" })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method("textDocument/documentHighlight", event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
            vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>ct", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay Hints")
          end
        end,
      })

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --  See `:help lsp-config` for information about keys and how to configure
      ---@type table<string, vim.lsp.Config>
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              codeLens = {
                enable = false,
              },
            },
          },
        },
        vtsls = {
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "ts-lit-plugin",
                    location = "/Users/asgi/.fnm/node-versions/v18.20.8/installation/lib/node_modules/ts-lit-plugin",
                    languages = { "javascript", "typescript" },
                  },
                  {
                    name = "typescript-styled-plugin",
                    location = "/Users/asgi/.fnm/node-versions/v18.20.8/installation/lib/node_modules/typescript-styled-plugin",
                    languages = { "javascript", "typescript" },
                  },
                },
              },
            },
          },
        },
        svelte = {},
        jsonls = {},
        cssls = {},
        cssmodules_ls = {},
        emmet_language_server = {},
        html = {
          init_options = {
            configurationSection = { "html", "css", "javascript" },
            embeddedLanguages = {
              css = true,
              javascript = true,
            },
            provideFormatter = true,
          },
        },
        markdown_oxide = {}, -- Markdown LSP
        gopls = {},
        astro = {},
        tailwindcss = {},
        cucumber_language_server = {
          settings = {
            cucumber = {
              features = { "**/*.feature" },
              glue = { "**/*.steps.ts", "**/*.steps.js" },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "eslint",
        "prettier",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      for name, server in pairs(servers) do
        vim.lsp.config(name, server)
        vim.lsp.enable(name)
      end
    end,
  },
}
