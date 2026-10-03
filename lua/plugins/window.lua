-- https://github.com/declancm/maximize.nvim/
-- https://github.com/yorickpeterse/nvim-window

return {
  {
    "declancm/maximize.nvim",
    keys = {
      {
        "<C-w>t",
        function()
          require("maximize").toggle()
        end,
        desc = "Maximizar ventana",
      },
    },
  },
  {
    "yorickpeterse/nvim-window",
    keys = {
      { "<C-w>w", "<cmd>lua require('nvim-window').pick()<cr>", desc = "nvim-window: Jump to window" },
    },
    config = true,
  },
}
