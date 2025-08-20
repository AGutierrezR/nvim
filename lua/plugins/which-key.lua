return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec" },
	opts = {
		preset = "helix",
		delay = 300,
		spec = {
			{ "<leader>g", group = "+Git" },
			{ "[`", desc = "Prev mark" },
			{ "]`", desc = "Next mark" },
			{ "<leader>c", group = "+Code" },
			{ "<leader>s", group = "+Search" },
			{ "<leader>f", group = "+Files/Find" },
			{ "<leader>b", group = "+Buffers" },
			{ "<leader>x", group = "+diagnostics/quickfix" },
			{ "<leader>q", group = "+quit/session" },
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
	keys = {
		{
			"<leader>gg",
			function()
				require("which-key").show({ keys = '<leader>g', loop = true })
			end,
			desc = "Git (Hydra Mode)",
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
	end,
}
