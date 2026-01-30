--
local snacks_lsp_pickers_filter = require("config.snacks.picker").lsp_pickers_filter

return {
  {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile", "BufWritePre" },
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { "williamboman/mason.nvim", opts = {} }, -- NOTE: Must be loaded before dependants
      "williamboman/mason-lspconfig.nvim",
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
          map("<leader>cd", snacks_picker.diagnostics_buffer, "Document Diagnostics")
          map("<leader>cm", function ()
            vim.cmd("Mason")
          end, "Mason")

          vim.keymap.set("n", "<leader>cl", function()
            vim.diagnostic.open_float(0, { scope = "line" })
          end, { desc = "Line Diagnostics" })

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>ct", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay Hints")
          end
        end,
      })

      -- Diagnostics configuration
      -- LSP Prevents inline buffer annotations
      vim.diagnostic.open_float()
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        underline = true,
        update_on_insert = false,
      })

      local signs = {
        Error = "󰅚 ",
        Warn = "󰳦 ",
        Hint = "󱡄 ",
        Info = " ",
      }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
      end

      -- LSP servers and clients are able to communicate to each other what features they support.
      --  By default, Neovim doesn't support everything that is in the LSP specification.
      --  When you add blink.cmp, luasnip, etc. Neovim now has *more* capabilities.
      --  So, we create new capabilities with blink.cmp, and then broadcast that to the servers.
      local original_capabilities = vim.lsp.protocol.make_client_capabilities()
      local capabilities = require("blink.cmp").get_lsp_capabilities(original_capabilities)

      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
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
                    location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/ts-lit-plugin",
                    languages = { "javascript", "typescript" },
                  },
                  {
                    name = "typescript-styled-plugin",
                    location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/typescript-styled-plugin",
                    languages = { "javascript", "typescript" },
                  },
                },
              },
            },
          },
        },
        -- ts_ls = {
        --   init_options = {
        --     plugins = {
        --       {
        --         name = "ts-lit-plugin",
        --         location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/ts-lit-plugin",
        --         languages = { "javascript", "typescript" },
        --       },
        --       {
        --         name = "typescript-styled-plugin",
        --         location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/typescript-styled-plugin",
        --         languages = { "javascript", "typescript" },
        --       },
        --     },
        --   },
        --   -- root_dir = function() return vim.loop.cwd() end
        -- },
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
        -- custom_elements_ls = {},
        marksman = {}, -- Markdown LSP
        gopls = {},
      }

      -- Ensure the servers and tools above are installed
      require("mason").setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        "stylua", -- Used to format Lua code
        "eslint-lsp",
        "prettier",
      })

      require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

      require("mason-lspconfig").setup({
        ensure_installed = {},
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
            require("lspconfig")[server_name].setup(server)
          end,
        },
      })
    end,
  },
}
