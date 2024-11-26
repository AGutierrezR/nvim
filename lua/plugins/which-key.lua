return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "helix",
		delay = 300,
		spec = {
			{ "<leader>g", group = "Git" },
			{ "[`", desc = "Prev mark" },
			{ "]`", desc = "Next mark" },
		},
		win = {
			height = {
				max = math.huge,
			},
		},
		plugins = {
			spelling = {
				enabled = false,
			},
		},
		icons = {
			rules = false,
			breadcrumb = "",
			separator = "󱦰",
			group = "󰹍 ",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
