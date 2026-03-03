return {
  "echasnovski/mini.pairs",
  event = { "BufReadPost", "BufNewFile" },
  version = false,
  opts = {
    modes = { insert = true, command = true, terminal = false },
    -- skip autopair when next character is one of these
    skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    -- better deal with markdown code blocks
    markdown = true,
  },
  config = function(_, opts)
    require("utils.mini").pairs(opts)

    -- Disable pairs for `typr` filetype
    local f = function(args)
      vim.b[args.buf].minipairs_disable = true
    end
    vim.api.nvim_create_autocmd("Filetype", { pattern = "typr", callback = f })
  end,
}
