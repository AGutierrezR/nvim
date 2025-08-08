-- Pounce is a motion plugin similar to EasyMotion, Sneak, Hop, and Lightspeed. It's based on incremental fuzzy search
return {
  "rlane/pounce.nvim",
  event = "LazyFile",
  opts = {},
  keys = {
    { "s", "<cmd>Pounce<CR>", mode = { "n", "x", "o" }, desc = "Pounce" },
    { "<leader>sp", "<cmd>PounceRepeat<CR>", mode = { "n", "x", "o" }, desc = "Pounce Repeat" },
  },
  -- config = function()
  --   require("pounce").setup()
  --
  --   vim.keymap.set({ "n", "x", "o" }, "s", vim.cmd.Pounce, { desc = "Pounce" })
  --   vim.keymap.set({ "n", "x", "o" }, "<leader>sp", vim.cmd.PounceRepeat, { desc = "Pounce Repeat" })
  -- end,
}
