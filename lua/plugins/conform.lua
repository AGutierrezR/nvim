return { 
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettier" },
				typescript = { "prettier" },
				javascriptreact = { "prettier" },
				typescriptreact = { "prettier" },
				css = { "prettier" },
				scss = { "prettier" },
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
			},
			-- format_on_save = {
				--   lsp_fallback = false,
				--   async = false,
				--   timeout_ms = 500,
				-- },
			})

			vim.keymap.set({ "n", "v" }, "<leader>=", function()
				conform.format({
					lsp_fallback = true,
					async = false,
				})
			end, { desc = "Format file or range (in visual mode)" })
		end,
	}
