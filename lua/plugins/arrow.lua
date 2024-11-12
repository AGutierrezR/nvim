return {
	"otavioschwanck/arrow.nvim",
	dependencies = {
		{ "nvim-tree/nvim-web-devicons" },
		-- or if using `mini.icons`
		-- { "echasnovski/mini.icons" },
	},
	opts = {
		show_icons = true,
		leader_key = "<C-e>", -- Recommended to be a single key
		buffer_leader_key = "m", -- Per Buffer Mappings
	},
	config = function(_, opts)
		require("arrow").setup(opts)

		vim.keymap.set("n", "H", require("arrow.persist").previous)
		vim.keymap.set("n", "L", require("arrow.persist").next)
		vim.keymap.set("n", "<leader>x", require("arrow.persist").toggle)
	end,
}
