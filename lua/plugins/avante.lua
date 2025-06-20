return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  enabled = false,
  version = false, -- Never set this value to "*"! Never!
  opts = {
    provider = "copilot",
    auto_suggestions_provider = "copilot",
    behaviour = {
      enable_cursor_planning_mode = true, -- enable cursor planning mode!
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = "make",
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    --- The below dependencies are optional,
    "ibhagwan/fzf-lua", -- for file_selector provider fzf
    "zbirenbaum/copilot.lua", -- for copilot provider
    {
      -- Make sure to set this up properly if you have lazy=true
      "MeanderingProgrammer/render-markdown.nvim",
      opts = {
        file_types = { "markdown", "Avante" },
      },
      ft = { "markdown", "Avante" },
    },
  },
}
