-- Keymaps on https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
local prompts = require("config.codecompanion.prompts")

return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
  cmd = {
    "CodeCompanionActions",
    "CodeCompanionChat",
  },
  opts = {
    display = {
      action_palette = {
        width = 95,
        height = 10,
        prompt = "Prompt ", -- Prompt used for interactive LLM calls
        provider = "snacks", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
        opts = {
          show_default_actions = true, -- Show the default actions in the action palette?
          show_default_prompt_library = true, -- Show the default prompt library in the action palette?
        },
      },
    },
    adapters = {
      http = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.5-sonnet",
              },
            },
          })
        end,
      },
    },
    strategies = {
      chat = { adapter = "copilot" },
      inline = { adapter = "copilot" },
      agent = { adapter = "copilot" },
    },
    prompt_library = prompts.PROMPT_LIBRARY,
  },
  keys = {
    { "<leader>ap", "<cmd>CodeCompanionActions<cr>", desc = "CodeCompanion: Actions", mode = { "n", "v" } },
    { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "CodeCompanion: Chat", mode = { "n", "v" } },
    -- { "ga", "<cmd>CodeCompanionChat Add<cr>", desc = "CodeCompanion: Add to Chat" },
  },
}
