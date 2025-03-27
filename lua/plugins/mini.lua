return {
	{
		"echasnovski/mini.ai",
		version = false,
		config = function()
			local spec_treesitter = require("mini.ai").gen_spec.treesitter
			require("mini.ai").setup({
				mappings = {
					around = "a",
					inside = "i",
					-- Next/last variants
					-- around_next = "",
					-- inside_next = "",
					-- around_last = "",
					-- inside_last = "",
				},
				-- -- Number of lines within which textobject is searched
				-- n_lines = 50,

				-- How to search for object (first inside current line, then inside
				-- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
				-- 'cover_or_nearest', 'next', 'previous', 'nearest'.
				-- search_method = 'cover_or_next',

				-- Move cursor to corresponding edge of `a` textobject
				-- goto_left = "g[",
				-- goto_right = "g]",

				-- Whether to disable showing non-error feedback
				silent = true,
				custom_textobjects = {
					f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
					o = spec_treesitter({
						a = { "@conditional.outer", "@loop.outer" },
						i = { "@conditional.inner", "@loop.inner" },
					}),
					c = spec_treesitter({
						a = { "@class.outer" },
						i = { "@class.inner" },
					}),
				},
			})
		end,
	},
	{
		"echasnovski/mini.surround",
		opts = {
			mappings = {
				add = "ys",
				delete = "ds",
				replace = "sr",
				find = "",
				find_left = "",
				highlight = "",
				update_n_lines = "",
			},
			search_method = "cover_or_next",
		},
		config = function(_, opts)
			require("mini.surround").setup(opts)
		end,
	},
	{
		"echasnovski/mini.pairs",
		version = false,
		config = function()
			require("mini.pairs").setup()
		end,
	},
}
