-- A sidebar with a tree-like outline of symbols from your code, powered by LSP.
return {
  "hedyhli/outline.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
  lazy = true,
  cmd = { "Outline", "OutlineOpen" },
  keys = { -- Example mapping to toggle outline
    { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
  },
  opts = {
    -- Your setup opts here
  }
}
