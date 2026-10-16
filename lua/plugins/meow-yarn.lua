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
      "<leader>ci",
      function() require("meow.yarn").open_tree("call_hierarchy", "callers") end,
      desc = "Call Hierarchy: Callers",
    },
    {
      "<leader>co",
      function() require("meow.yarn").open_tree("call_hierarchy", "callees") end,
      desc = "Call Hierarchy: Callees",
    },
  },
  config = function()
    require("meow.yarn").setup({})
  end,
}
