return {
	"rlane/pounce.nvim",
	config = function()
		require("pounce").setup()

		vim.keymap.set({ "n", "x", "o" }, "gw", vim.cmd.Pounce, { desc = "Pounce" })
		vim.keymap.set({ "n", "x", "o" }, "gW", vim.cmd.PounceRepeat, { desc = "Pounce Repeat" })
	end,
}
