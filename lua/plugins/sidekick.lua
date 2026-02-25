local haunt_sk = require("haunt.sidekick")

return {
  "folke/sidekick.nvim",
  cmd = "Sidekick",
  opts = {
    -- add any options here
    cli = {
      prompts = {
        commit = "Please propose a commit message for staged files",
        refactor = "Please propose a refactor for the attached snippet {this}",
        haunt_all = function()
          return haunt_sk.get_locations()
        end,
        haunt_buffer = function()
          return haunt_sk.get_locations({ current_buffer = true })
        end,
      },
      mux = {
        backend = "tmux",
        enabled = true,
        create = "split",
        split = {
          vertical = true, -- vertical or horizontal split
          size = 0.32, -- size of the split (0-1 for percentage)
        },
      },
    },
    nes = {
      enabled = false,
      debounce = 100,
    },
  },
  keys = {
    {
      "<tab>",
      function()
        -- if there is a next edit, jump to it, otherwise apply it if any
        if not require("sidekick").nes_jump_or_apply() then
          print("No more edit suggestions")
          return "<Tab>" -- fallback to normal tab
        end
      end,
      expr = true,
      desc = "Goto/Apply Next Edit Suggestion",
    },
    {
      "<leader>oo",
      function()
        require("sidekick.cli").toggle({ name = "opencode", focus = true })
      end,
      desc = "Sidekick Opencode",
    },
    -- No need for this one, just use Opencode directly
    -- {
    --   "<leader>os",
    --   function()
    --     require("sidekick.cli").select({ filter = { installed = true } })
    --   end,
    --   -- Or to select only installed tools:
    --   -- require("sidekick.cli").select({ filter = { installed = true } })
    --   desc = "Select CLI",
    -- },
    {
      "<leader>od",
      function()
        require("sidekick.cli").close()
      end,
      desc = "Detach a CLI Session",
    },
    {
      "<leader>ot",
      function()
        require("sidekick.cli").send({ msg = "{this}" })
      end,
      mode = { "x", "n" },
      desc = "Send This",
    },
    -- This one is not working
    -- {
    --   "<leader>or",
    --   function() require("sidekick.cli").send({ msg = "{range}" }) end,
    --   desc = "Send Range",
    -- },
    {
      "<leader>ob",
      function() require("sidekick.cli").send({ msg = "{buffers}" }) end,
      desc = "Send Buffers",
    },
    {
      "<leader>ol",
      function() require("sidekick.cli").send({ msg = "{line}" }) end,
      desc = "Send Line",
    },
    {
      "<leader>of",
      function()
        require("sidekick.cli").send({ msg = "{file}" })
      end,
      desc = "Send File",
    },
    {
      "<leader>ov",
      function()
        require("sidekick.cli").send({ msg = "{selection}" })
      end,
      mode = { "x" },
      desc = "Send Visual Selection",
    },
    {
      "<leader>op",
      function()
        require("sidekick.cli").prompt()
      end,
      mode = { "n", "x" },
      desc = "Sidekick Select Prompt",
    },
  },
}
