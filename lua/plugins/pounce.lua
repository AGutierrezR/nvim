-- Pounce is a motion plugin similar to EasyMotion, Sneak, Hop, and Lightspeed. It's based on incremental fuzzy search
return {
  {
    "rlane/pounce.nvim",
    event = "LazyFile",
    opts = {},
    keys = {
      { "zk", "<cmd>Pounce<CR>", mode = { "n", "x", "o" }, desc = "Pounce" },
      { "z;", "<cmd>PounceRepeat<CR>", mode = { "n", "x", "o" }, desc = "Pounce Repeat" },
    },
  },
}
