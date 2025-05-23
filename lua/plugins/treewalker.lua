return {
  "aaronik/treewalker.nvim",
  keys = {
    { mode = "n", "<A-S-j>", "<CMD>Treewalker Down<CR>", silent = true, desc = "Treewalker Down" },
    { mode = "n", "<A-S-k>", "<CMD>Treewalker Up<CR>", silent = true, desc = "Treewalker Up" },
    { mode = "n", "<A-S-h>", "<CMD>Treewalker Left<CR>", silent = true, desc = "Treewalker Left" },
    { mode = "n", "<A-S-l>", "<CMD>Treewalker Right<CR>", silent = true, desc = "Treewalker Right" },
  },
  opts = {
    highlight = true,
  },
}
