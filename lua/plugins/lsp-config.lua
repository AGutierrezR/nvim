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
            vim.cmd("checkhealth vim.lsp")
          end, "LspInfo")
          map("<leader>clb", require("utils.lsp-config").lsp_info_buffer, "LspInfo buffer")
          map("<leader>clr", require("utils.lsp-config").lsp_restart, "LspRestart")

          vim.keymap.set("n", "<leader>cd", function()
            vim.diagnostic.open_float(0, { scope = "line" })
          end, { desc = "Line Diagnostics" })

          -- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
          ---@param client vim.lsp.Client
          ---@param method vim.lsp.protocol.Method
          ---@param bufnr? integer some lsp support methods only in specific files
          ---@return boolean
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has("nvim-0.11") == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, "textDocument/documentHighlight", event.buf) then
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
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map("<leader>ct", function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, "[T]oggle Inlay Hints")
          end

          -- Markdown Oxide specific features
          if client and client.name == "markdown_oxide" then
            -- Setup daily note commands for natural language input
            vim.api.nvim_create_user_command("Daily", function(args)
              local input = args.args
              vim.lsp.buf.execute_command({ command = "jump", arguments = { input } })
            end, {
              desc = 'Open daily note (e.g., ":Daily two days ago", ":Daily next monday")',
              nargs = "*",
            })

            -- Enable code lens for reference counts (if supported)
            if client_supports_method(client, vim.lsp.protocol.Methods.textDocument_codeLens, event.buf) then
              local function check_codelens_support()
                local clients = vim.lsp.get_active_clients({ bufnr = 0 })
                for _, c in ipairs(clients) do
                  if c.server_capabilities.codeLensProvider then
                    return true
                  end
                end
                return false
              end

              vim.api.nvim_create_autocmd({ "TextChanged", "InsertLeave", "CursorHold", "LspAttach", "BufEnter" }, {
                buffer = event.buf,
                callback = function()
                  if check_codelens_support() then
                    vim.lsp.codelens.refresh({ bufnr = 0 })
                  end
                end,
              })

              -- Trigger codelens refresh
              vim.api.nvim_exec_autocmds("User", { pattern = "LspAttached" })
            end
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
        css_variables = {},
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
        markdown_oxide = {
          capabilities = {
            workspace = {
              didChangeWatchedFiles = {
                dynamicRegistration = true,
              },
            },
          },
        }, -- Markdown LSP
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
        eslint = {},
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
