-- https://github.com/AgutierrezR/meow.yarn.nvim

return {
  -- Fork of retran/meow.yarn.nvim with a fix for vtsls: it omits the routing
  -- `data` on call-hierarchy caller/callee items, which made expanding them fail
  -- with "Cannot read properties of undefined (reading 'id')".
  -- branch fix/vtsls-call-hierarchy-data @ 97e29e4
  "AGutierrezR/meow.yarn.nvim",
  branch = "fix/vtsls-call-hierarchy-data",
  lazy = true,
  dependencies = { "MunifTanjim/nui.nvim" },
  keys = {
    {
      "<leader>cyi",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callers")
      end,
      desc = "Call Hierarchy: Callers",
    },
    {
      "<leader>cyo",
      function()
        require("meow.yarn").open_tree("call_hierarchy", "callees")
      end,
      desc = "Call Hierarchy: Callees",
    },
    {
      "<leader>cyl",
      function()
        require("meow.yarn").reopen_last()
      end,
      desc = "Call Hierarchy: Re-open last hierarchy",
    },
  },
  opts = {
    window = {
      preview_height_ratio = 0.4,
      layout = "vertical",
    },
    quickfix = {
      use_trouble = false,
    },
    expand_depth = 5,
  },
  config = function(_, opts)
    require("meow.yarn").setup(opts)
  end,
}
