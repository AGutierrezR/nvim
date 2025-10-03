return {
  "ThePrimeagen/harpoon",
  branch = "harpoon2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = function()
    local keys = {
      {
        "<C-e>",
        function()
          require("harpoon"):list():add()
        end,
        desc = "Harpoon File",
      },
      {
        "gb",
        function()
          local harpoon = require("harpoon")
          harpoon.ui:toggle_quick_menu(harpoon:list())
        end,
        desc = "Harpoon Quick Menu",
      },
      {
        "<A-S-p>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():prev()
        end,
        desc = "Harpoon Previous File",
      },
      {
        "<A-S-n>",
        function()
          local harpoon = require("harpoon")
          harpoon:list():next()
        end,
        desc = "Harpoon Next File",
      },
    }

    for i = 1, 9 do
      table.insert(keys, {
        "<leader>" .. i,
        function()
          require("harpoon"):list():select(i)
        end,
        desc = "Harpoon to File " .. i,
      })
    end

    return keys
  end,
}
