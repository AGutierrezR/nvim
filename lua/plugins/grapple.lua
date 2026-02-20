return {
  "cbochs/grapple.nvim",
  dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
  enabled = true,
  opts = { scope = "git" },
  event = { "BufReadPost", "BufNewFile" },
  cmd = "Grapple",
  keys = function()
    local keys = {
      {
        "<leader>fg",
        function()
          require("grapple").toggle()
        end,
        desc = "Grapple file (toggle)",
      },
      {
        "gb",
        function()
          require("grapple").toggle_tags()
        end,
        desc = "Grapple list",
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("grapple").select({ index = i })
        end,
        desc = "Grapple to File " .. i,
      })
    end

    return keys
  end,
}
