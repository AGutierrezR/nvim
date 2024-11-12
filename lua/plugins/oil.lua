return {
	"stevearc/oil.nvim",
	opts = {},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			skip_confirm_for_simple_edit = true,
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					return name == ".." or name == ".git"
				end,
			},
			win_options = {
				wrap = true,
			},
			keymaps = {
				["<C-s>"] = {
					"actions.select",
					opts = { horizontal = true, split = "botright" },
					desc = "Open the entry in a horizontal split",
				},
				["<C-h>"] = false,
				["<C-t>"] = false,
				["<C-l>"] = false,
				["<C-p>"] = {
					callback = function()
						local oil = require("oil")
						oil.open_preview({ vertical = true, split = "botright" })
					end,
				},
			},
		})

		vim.keymap.set("n", "-", vim.cmd.Oil, { desc = "Open parent directory " })
	end,
}
