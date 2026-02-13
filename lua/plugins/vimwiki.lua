local function open_today_journal()
  local today = os.date("%Y-%m-%d")
  local path = vim.fn.expand("~/vimwiki/journals/" .. today .. ".md")
  vim.cmd("edit " .. path)
end

local function open_wiki()
  local today = os.date("%Y-%m-%d")
  local path = vim.fn.expand("~/vimwiki/index.md")
  vim.cmd("edit " .. path)
end

return {
  { "preservim/vim-pencil" },
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
          cursorline = false,
        },
      },
      plugins = {
        tmux = { enabled = true },
        gitsigns = { enabled = true },
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
  {
    "jakewvincent/mkdnflow.nvim",
    enabled = true,
    -- keys = {
    --   { "<leader>ww", function () open_wiki() end, mode = "n" },
    --   { "<leader>w<leader>w", function () open_today_journal() end, mode = "n" },
    -- },
    config = function()
      require("mkdnflow").setup({
        -- Config goes here; leave blank for defaults

        vim.keymap.set("n", "<leader>ww", open_wiki, { desc = "Open wiki" }),
        vim.keymap.set("n", "<leader>w<leader>w", open_today_journal, { desc = "Open today diary" }),
      })
    end,
  },
  {
    "vimwiki/vimwiki",
    enabled = false,
    event = "BufEnter *.md",
    keys = { "<leader>ww" },
    init = function()
      -- Set up vimwiki options
      vim.g.vimwiki_list = {
        {
          path = "~/vimwiki/", -- Set your wiki path here
          syntax = "markdown", -- You can change it to 'default' if you prefer Vimwiki syntax
          ext = "md", -- Markdown file extension
        },
      }
      -- Additional vimwiki options
      vim.g.vimwiki_global_ext = 0
    end,
  },
}
