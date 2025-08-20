return {
  "echasnovski/mini.pairs",
  event = { "BufReadPost", "BufNewFile" },
  version = false,
  config = function()
    require("mini.pairs").setup()

    -- Disable pairs for `typr` filetype
    local f = function(args)
      vim.b[args.buf].minipairs_disable = true
    end
    vim.api.nvim_create_autocmd("Filetype", { pattern = "typr", callback = f })
  end,
}
