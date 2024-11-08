return {
  "chentoast/marks.nvim",
  event = "VeryLazy",
  opts = {},
  config = function ()
    require('marks').setup({
      mappings = {
        next = ']`',
        prev = '[`'
      }
    })
  end
}
