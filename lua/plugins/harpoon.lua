return {

  {
		"cbochs/grapple.nvim",
		dependencies = { { "nvim-tree/nvim-web-devicons", lazy = true } },
    enabled = true,
		opts = { scope = "git" },
		event = { "BufReadPost", "BufNewFile" },
		cmd = "Grapple",
		keys = {
			{ "<C-e>", "<cmd>Grapple toggle<cr>", desc = "⇁ mark" },
			{ "gb", "<cmd>Grapple toggle_tags<cr>", desc = "⇁ menu" },

			{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "⇁ 1" },
			{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "⇁ 2" },
			{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "⇁ 3" },
			{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "⇁ 4" },
			{ "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "⇁ 5" },
			-- { "<leader>n", "<cmd>Grapple cycle_tags next<cr>", desc = "Grapple cycle next tag" },
			-- { "<leader>p", "<cmd>Grapple cycle_tags prev<cr>", desc = "Grapple cycle previous tag" },
		},
	},
  {
    "ThePrimeagen/harpoon",
    enabled = false,
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
  },
}
