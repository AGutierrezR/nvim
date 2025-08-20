return {
  -- Neovim Lua plugin with fast and feature-rich surround actions
  "echasnovski/mini.surround",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    mappings = {
      add = "gza", -- Add surrounding in Normal and Visual modes
      delete = "gzd", -- Delete surrounding
      find = "gzf", -- Find surrounding (to the right)
      find_left = "", -- Find surrounding (to the left)
      highlight = "", -- Highlight surrounding
      replace = "gzr", -- Replace surrounding
      update_n_lines = "", -- Update `n_lines`
    },
  },
  keys = {
    { "gz", "", desc = "+Surround" },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)
  end,
}
