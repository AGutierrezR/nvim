-- Main LSP Configuration
return {
	{
		-- Main LSP Configuration
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs and related tools to stdpath for Neovim
			{ "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Useful status updates for LSP.
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ "j-hui/fidget.nvim", opts = {} },

			-- Allows extra capabilities provided by nvim-cmp
			"hrsh7th/cmp-nvim-lsp",
			{
				"SmiteshP/nvim-navbuddy",
				dependencies = {
					"SmiteshP/nvim-navic",
					"MunifTanjim/nui.nvim",
				},
				opts = { lsp = { auto_attach = true } },
			},
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

					map("gd", require("fzf-lua").lsp_definitions, "Goto Definition")
					map("gI", require("fzf-lua").lsp_implementations, "Goto Implementation")
					map("gr", require("fzf-lua").lsp_references, "Goto References")
					map("gD", require("fzf-lua").lsp_typedefs, "Goto Type Definition")
					map("K", vim.lsp.buf.hover, "")
					map("<leader>a", require("fzf-lua").lsp_code_actions, "Code Action")
					map("<leader>s", require("fzf-lua").lsp_document_symbols, "Goto Document Symbols")
					map("<leader>S", require("fzf-lua").lsp_live_workspace_symbols, "GoTo Workspace Symbols")
					map("<leader>r", vim.lsp.buf.rename, "Rename Symbol")
					map("<leader>d", require("fzf-lua").diagnostics_document, "Document Diagnostics")

					vim.keymap.set("n", "<leader>l", function()
						vim.diagnostic.open_float(0, { scope = "line" })
					end, { desc = "Line Diagnostics" }) -- Navbuddy keymap
					vim.keymap.set("n", "<leader>O", vim.cmd.Navbuddy, { desc = "Toggle Navbuddy" })

					-- The following two autocommands are used to highlight references of the
					-- word under your cursor when your cursor rests there for a little while.
					--    See `:help CursorHold` for information about when this is executed
					--
					-- When you move your cursor, the highlights will be cleared (the second autocommand).
					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

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
				ts_ls = {
					init_options = {
						plugins = {
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
					-- root_dir = function() return vim.loop.cwd() end
				},
				jsonls = {},
				cssls = {},
				emmet_ls = {},
				custom_elements_ls = {},
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
			}

			-- Ensure the servers and tools above are installed
			require("mason").setup()

			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"eslint_d",
				"prettier",
			})

			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				auto_install = true,
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

			-- LSP Prevents inline buffer annotations
			vim.diagnostic.open_float()
			vim.lsp.handlers["textDocument/publishDiagnostics"] =
				vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
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
		end,
	},
}
