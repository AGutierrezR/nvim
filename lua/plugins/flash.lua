-- Pounce is a motion plugin similar to EasyMotion, Sneak, Hop, and Lightspeed. It's based on incremental fuzzy search
return {
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {
      modes = {
        char = { enabled = false },
      },
    },
    keys = {
      { "zk", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash", },
      { "Zk", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter", },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash", },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search", },
    },
  },
}
