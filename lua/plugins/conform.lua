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
				html = { "prettier" },
				json = { "prettier" },
				yaml = { "prettier" },
				markdown = { "prettier" },
				lua = { "stylua" },
				md = { "prettier" },
        go = { "gofmt" },
			},
			-- format_on_save = {
			--   lsp_fallback = false,
			--   async = false,
			--   timeout_ms = 500,
			-- },
		})

		formatters = {
			prettier = {
				require_cwd = true,
				cwd = require("conform.util").root_file({
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yml",
					".prettierrc.yaml",
					".prettierrc.json5",
					".prettierrc.js",
					".prettierrc.cjs",
					".prettierrc.mjs",
					".prettierrc.toml",
					"prettier.config.js",
					"prettier.config.cjs",
					"prettier.config.mjs",
				}),
			},
		}

		vim.keymap.set({ "n", "v" }, "<leader>=", function()
			conform.format({
				lsp_fallback = true,
				async = false,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
