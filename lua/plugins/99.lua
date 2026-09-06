return {
  "AGutierrezR/99",
  name = "99",
  config = function()
    local _99 = require("99")

    _99.setup({
      -- provider = _99.Providers.CopilotProvider,
      -- model = "github-copilot/claude-sonnet-5",
      provider = _99.Providers.OpenCodeProvider,
      model = "opencode/mimo-v2.5-free",
      tmp_dir = "./.99",
      md_files = { "AGENTS.md" },
    })

    vim.keymap.set("v", "<leader>av", _99.visual, { desc = "99: Replace visual selection" })
    vim.keymap.set("n", "<leader>as", _99.search, { desc = "99: Search and replace" })
    vim.keymap.set("n", "<leader>ax", _99.stop_all_requests, { desc = "99: Stop all requests" })
    vim.keymap.set("n", "<leader>ac", _99.clear_previous_requests, { desc = "99: Clear chat history" })
    vim.keymap.set("v", "<leader>ao", _99.open, { desc = "99: Open prompt with selection" })
    vim.keymap.set("v", "<leader>a.", _99.repeat_last, { desc = "99: Repeat last operation" })

    vim.keymap.set("v", "<leader>ap", function()
      require("utils.99").select_prompt(function(prompt)
        _99.visual({ additional_prompt = prompt })
      end)
    end, { desc = "99: Prompts" })
  end,
}
