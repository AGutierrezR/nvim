local function open_today_journal()
  local today = os.date("%Y-%m-%d")
  local path = vim.fn.expand("~/vimwiki/journals/" .. today .. ".md")

  if vim.fn.filereadable(path) == 1 then
    vim.cmd("edit " .. path)
  else
    local file = io.open(path, "w")
    if file then
      file:write("# Journal - " .. today .. "\n\n") -- Opcional: Escribe encabezado
      file:close()
    end
    vim.cmd("edit " .. path)
  end
end

local function open_wiki()
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
        mappings = {
          MkdnEnter = { { "n", "v" }, "<CR>" },
          MkdnGoBack = { "n", "<BS>" },
          MkdnGoForward = { "n", "<Del>" },
          MkdnMoveSource = { "n", "<F2>" },
          MkdnNextLink = { "n", "<Tab>" },
          MkdnPrevLink = { "n", "<S-Tab>" },
          MkdnFollowLink = false,
          MkdnDestroyLink = { "n", "<M-CR>" },
          MkdnTagSpan = { "v", "<M-CR>" },
          MkdnYankAnchorLink = { "n", "yaa" },
          MkdnYankFileAnchorLink = { "n", "yfa" },
          MkdnNextHeading = { "n", "]]" },
          MkdnPrevHeading = { "n", "[[" },
          MkdnIncreaseHeading = false, -- Modified
          MkdnDecreaseHeading = false, -- Modified 
          MkdnIncreaseHeadingOp = { { "n", "v" }, "g+" },
          MkdnDecreaseHeadingOp = { { "n", "v" }, "g-" },
          MkdnToggleToDo = { { "n", "v" }, "<C-Space>" },
          MkdnNewListItem = false,
          MkdnNewListItemBelowInsert = { "n", "o" },
          MkdnNewListItemAboveInsert = { "n", "O" },
          MkdnExtendList = false,
          MkdnUpdateNumbering = { "n", "<leader>nn" },
          MkdnTableNextCell = { "i", "<Tab>" },
          MkdnTablePrevCell = { "i", "<S-Tab>" },
          MkdnTableNextRow = false,
          MkdnTablePrevRow = { "i", "<M-CR>" },
          MkdnTableNewRowBelow = { "n", "<leader>ir" },
          MkdnTableNewRowAbove = { "n", "<leader>iR" },
          MkdnTableNewColAfter = { "n", "<leader>ic" },
          MkdnTableNewColBefore = { "n", "<leader>iC" },
          MkdnTableDeleteRow = { "n", "<leader>dr" },
          MkdnTableDeleteCol = { "n", "<leader>dc" },
          MkdnFoldSection = { "n", "<leader>f" },
          MkdnUnfoldSection = { "n", "<leader>F" },
          MkdnTab = false,
          MkdnSTab = false,
          MkdnIndentListItem = { "i", "<C-t>" },
          MkdnDedentListItem = { "i", "<C-d>" },
          MkdnCreateLink = false,
          MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>p" },
        },
      })

      vim.keymap.set("n", "<leader>ww", open_wiki, { desc = "Open wiki" })
      vim.keymap.set("n", "<leader>w<leader>w", open_today_journal, { desc = "Open today diary" })
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
