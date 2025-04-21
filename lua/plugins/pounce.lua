-- Pounce is a motion plugin similar to EasyMotion, Sneak, Hop, and Lightspeed. It's based on incremental fuzzy search
return {
	"rlane/pounce.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
	config = function()
		require("pounce").setup()

		vim.keymap.set({ "n", "x", "o" }, "gw", vim.cmd.Pounce, { desc = "Pounce" })
		vim.keymap.set({ "n", "x", "o" }, "gW", vim.cmd.PounceRepeat, { desc = "Pounce Repeat" })
	end,
}
