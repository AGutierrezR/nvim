return {
  { "vimwiki/vimwiki", },
  { "preservim/vim-pencil", cmd = "Pencil" },
  {
    "folke/zen-mode.nvim",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      window = {
        width = 100,
        options = {
          number = false,
          relativenumber = false,
          colorcolumn = "0",
        },
      },
      plugins = {
        tmux = { enabled = true },
      },
      -- callback where you can add custom code when the Zen window opens
      on_open = function(win)
        vim.cmd("PencilSoft")
      end,
      -- callback where you can add custom code when the Zen window closes
      on_close = function()
        vim.cmd("PencilOff")
      end,
    },
    keys = {
      {
        "<leader>uz",
        "<cmd> ZenMode<CR>",
        mode = "n",
        desc = "Zen Mode",
      },
    },
  },
}
