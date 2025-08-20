return {
  -- Neovim Lua plugin to extend and create `a`/`i` textobjects
  "echasnovski/mini.ai",
  version = false,
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ai = require("mini.ai")
    local spec_treesitter = ai.gen_spec.treesitter

    require("mini.ai").setup({
      mappings = {
        around = "a",
        inside = "i",
        -- Next/last variants
        -- around_next = "an",
        -- inside_next = "in",
        -- around_last = "al",
        -- inside_last = "il",
      },
      -- -- Number of lines within which textobject is searched
      -- n_lines = 50,

      -- How to search for object (first inside current line, then inside
      -- neighborhood). One of 'cover', 'cover_or_next', 'cover_or_prev',
      -- 'cover_or_nearest', 'next', 'previous', 'nearest'.
      -- search_method = 'cover_or_next',

      -- Move cursor to corresponding edge of `a` textobject
      -- goto_left = "g[",
      -- goto_right = "g]",

      -- Whether to disable showing non-error feedback
      silent = true,
      custom_textobjects = {
        f = spec_treesitter({ a = "@function.outer", i = "@function.inner" }),
        o = spec_treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }),
        c = spec_treesitter({
          a = { "@class.outer" },
          i = { "@class.inner" },
        }),
        e = { -- Single words in different cases (camelCase, snake_case, etc.)
          {
            "%u[%l%d]+%f[^%l%d]",
            "%f[%S][%l%d]+%f[^%l%d]",
            "%f[%P][%l%d]+%f[^%l%d]",
            "^[%l%d]+%f[^%l%d]",
          },
          "^().*()$",
        },
        u = ai.gen_spec.function_call(), -- u for "Usage"
        U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        g = function() -- whole file
          local from = { line = 1, col = 1 }
          local to = {
            line = vim.fn.line("$"),
            col = math.max(vim.fn.getline("$"):len(), 1),
          }
          return { from = from, to = to }
        end,
      },
    })
  end,
}
