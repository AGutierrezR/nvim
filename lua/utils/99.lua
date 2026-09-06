---@class NinetyNineUtils
---@field prompts table[]
---@field select_prompt fun(callback: fun(prompt: string)): nil
local M = {}

M.prompts = {
  {
    name = "JSDoc",
    prompt = "Add JSDoc documentation to this code. Include descriptions for all parameters, return values, and a brief description of what the function does.",
  },
  {
    name = "Refactor",
    prompt = "Refactor this code to improve readability, reduce complexity, and follow best practices. Keep the same functionality.",
  },
  {
    name = "Better Names",
    prompt = "Improve the names of variables and functions in this code. Make them more descriptive and intention-revealing while following conventional naming conventions.",
  },
  {
    name = "Fix",
    prompt = "Fix the bugs or issues in this code. Identify and correct any errors, edge cases, or problematic patterns.",
  },
}

---@param callback fun(prompt: string)
function M.select_prompt(callback)
  vim.ui.select(M.prompts, {
    prompt = "Select a prompt:",
    format_item = function(item)
      return item.name
    end,
  }, function(choice)
    if choice then
      callback(choice.prompt)
    end
  end)
end

return M
