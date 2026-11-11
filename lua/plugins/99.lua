-- https://github.com/AGutierrezR/99

return {
  "AGutierrezR/99",
  name = "99",
  config = function()
    local _99 = require("99")

    _99.setup({
      -- provider = _99.Providers.CopilotProvider,
      -- model = "github-copilot/claude-sonnet-5",
      -- model = "github-copilot/gpt-5.6-luna",
      -- provider_extra_args = {
      --   "--silent",
      -- },
      provider = _99.Providers.OpenCodeProvider,
      model = "opencode/beam-free", -- run `opencode models` to see list
      tmp_dir = "./.99",
      md_files = { "AGENTS.md" },
    })

    local scopes = {
      { key = "l", cmd = "V", desc = "Current line" },
      { key = "f", cmd = "vaf", desc = "Function" },
      { key = "b", cmd = "vab", desc = "Block" },
    }

    local keymap = function(mode, lhs, rhs, opts)
      vim.keymap.set(mode, lhs, rhs, opts or {})
    end

    keymap("v", "<leader>av", _99.visual, { desc = "99: Visual selection" })
    for _, scope in ipairs(scopes) do
      keymap("n", "<leader>a" .. scope.key, function()
        vim.cmd("normal! " .. scope.cmd)
        _99.visual()
      end, { desc = "99: " .. scope.desc })
    end

    keymap("v", "<leader>a.", _99.pick_saved_prompt, { desc = "99: Saved prompts" })
    for _, scope in ipairs(scopes) do
      keymap("n", "<leader>a." .. scope.key, function()
        vim.cmd("normal! " .. scope.cmd)
        _99.pick_saved_prompt()
      end, { desc = "99: Saved prompts (" .. scope.desc .. ")" })
    end

    keymap("v", "<leader>ap", function()
      require("utils.99").select_prompt(function(prompt)
        _99.visual({ additional_prompt = prompt })
      end)
    end, { desc = "99: Prompts" })
    for _, scope in ipairs(scopes) do
      keymap("n", "<leader>ap" .. scope.key, function()
        vim.cmd("normal! " .. scope.cmd)
        require("utils.99").select_prompt(function(prompt)
          _99.visual({ additional_prompt = prompt })
        end)
      end, { desc = "99: Prompts (" .. scope.desc .. ")" })
    end

    keymap("n", "<leader>aD", _99.delete_saved_prompt, { desc = "99: Delete saved prompts" })

    keymap("n", "<leader>as", _99.search, { desc = "99: Search" })
    keymap("n", "<leader>ax", _99.stop_all_requests, { desc = "99: Stop all requests" })
    keymap("n", "<leader>ac", _99.clear_previous_requests, { desc = "99: Clear chat history" })
    keymap("n", "<leader>ao", _99.open, { desc = "99: Open prompt with selection" })

    keymap({ "n", "x" }, "<leader>at", _99.tutorial, { desc = "99: Open tutorial" })
  end,
}
