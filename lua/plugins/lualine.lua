local mode_map = {
	["NORMAL"] = "N",
	["O-PENDING"] = "N?",
	["INSERT"] = "I",
	["VISUAL"] = "V",
	["V-BLOCK"] = "VB",
	["V-LINE"] = "VL",
	["V-REPLACE"] = "VR",
	["REPLACE"] = "R",
	["COMMAND"] = "!",
	["SHELL"] = "SH",
	["TERMINAL"] = "T",
	["EX"] = "X",
	["S-BLOCK"] = "SB",
	["S-LINE"] = "SL",
	["SELECT"] = "S",
	["CONFIRM"] = "Y?",
	["MORE"] = "M",
}

local function show_macro_recording()
	local recording_register = vim.fn.reg_recording()
	if recording_register == "" then
		return ""
	else
		return "󰑋 " .. recording_register
	end
end

local function place()
	local linePre = "L:"
	local line = "%l/%L"
	return string.format("%s%s", linePre, line)
end

return {
	"nvim-lualine/lualine.nvim",
	event = 'VeryLazy',
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		sections = {
			lualine_a = {
				{
					"mode",
					fmt = function(s)
						return mode_map[s] or s
					end,
				},
			},
			lualine_b = {
				{ "branch", icon = "󰘬" },
				"diff",
				"diagnostics",
			},
			lualine_c = {
				-- {
				-- 	"filename",
				-- 	symbols = {
				-- 		modified = "󰐖", -- Text to show when the file is modified.
				-- 		readonly = "", -- Text to show when the file is non-modifiable or readonly.
				-- 	},
				-- },
				-- {
				-- 	show_macro_recording,
				-- 	color = { fg = "#333333", bg = "#ff6666" },
				-- 	separator = { left = "", right = "" },
				-- },
			},
			lualine_x = { "encoding", "filetype" },
			lualine_y = { nil },
			lualine_z = { { place, padding = { left = 1, right = 1 } } },
		},
	},
	config = function(_, opts)
		require("lualine").setup(opts)
	end,
}
