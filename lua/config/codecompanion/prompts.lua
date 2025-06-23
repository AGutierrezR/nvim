local M = {}

M.PROMPT_LIBRARY = {
  ["Better Naming"] = {
    strategy = "chat",
    description = "Give betting naming for the provided code snippet.",
    opts = {
      modes = { "v" }, -- Only available in visual mode
      short_name = "better-naming",
      auto_submit = true,
      is_slash_cmd = true,
    },
    prompts = {
      {
        role = "user",
        content = "Please provide better names for the following variables and functions.",
      },
    },
  },
  ["JSDocs"] = {
    strategy = "inline",
    description = "Add JSDocs documentation for code.",
    opts = {
      modes = { "v" },
      short_name = "jsdocs",
      auto_submit = true,
      user_prompt = false,
      stop_context_insertion = true,
    },
    prompts = {
      {
        role = "user",
        content = function(context)
          local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

          return "Please provide jsdocs code for the following code and suggest to have better naming to improve readability.\n\n```"
            .. context.filetype
            .. "\n"
            .. code
            .. "\n```\n\n"
        end,
        opts = {
          contains_code = true,
        },
      },
    },
  },
}

return M
