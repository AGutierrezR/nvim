return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "LazyFile", "VeryLazy" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "javascript",
          "typescript",
          "json",
          "html",
          "markdown",
          "markdown_inline",
          "css",
          "scss",
          "yaml",
          "toml",
        },

        highlight = {
          enable = true,
        },

        incremental_selection = {
          enable = false,
          keymaps = {
            node_incremental = "<Enter>",
            node_decremental = "<Tab>",
            scope_incremental = false,
          },
        },

        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            include_surrounding_whitespace = false,
            keymaps = {
              -- ["af"] = "@function.outer", -- Use mini.ai instead
              -- ["if"] = "@function.inner", -- Use mini.ai instead
              -- ["ac"] = "@class.outer",	-- Use mini.ai instead
              -- ["ic"] = "@class.inner",	-- Use mini.ai instead
              -- ["is"] = "@assignment.inner",
              -- ["as"] = "@assignment.outer",
              -- ["ig"] = "@block.inner", -- Use mini.ai instead
              -- ["ag"] = "@block.outer", -- Use mini.ai instead
              -- ["ia"] = "@parameter.inner", -- Use mini.ai instead
              -- ["aa"] = "@parameter.outer", -- Use mini.ai instead
              -- ["ik"] = "@call.inner",
              -- ["ak"] = "@call.outer",
              -- ["i/"] = "@comment.inner", -- Not working in Javascript
              -- ["a/"] = "@comment.outer",
              -- ["ir"] = "@conditional.inner", -- Use mini.ai instead
              -- ["ar"] = "@conditional.outer", -- Use mini.ai instead
              -- ["io"] = "@loop.inner", -- Use mini.ai instead
              -- ["ao"] = "@loop.outer", -- Use mini.ai instead
              -- ["it"] = "@return.inner", -- Not working in Javascript
              -- ["at"] = "@return.outer", -- Not working in Javascript
            },
          },
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ["]f"] = "@function.outer",
              ["]="] = "@assignment.outer",
              ["]c"] = "@class.outer",
              ["]g"] = "@block.outer",
              ["]a"] = "@parameter.outer",
              ["]k"] = "@call.outer",
              ["]/"] = "@comment.outer",
              ["]r"] = "@conditional.outer",
              ["]o"] = "@loop.outer",
              -- ["]t"] = "@return.outer",
            },
            goto_next_end = {
              ["]F"] = "@function.outer",
              ["]C"] = "@class.outer",
              ["]G"] = "@block.outer",
              ["]A"] = "@parameter.outer",
              ["]K"] = "@call.outer",
              ["]?"] = "@comment.outer",
              ["]R"] = "@conditional.outer",
              ["]O"] = "@loop.outer",
              -- ["]T"] = "@return.outer",
            },
            goto_previous_start = {
              ["[f"] = "@function.outer",
              ["[="] = "@assignment.outer",
              ["[c"] = "@class.outer",
              ["[g"] = "@block.outer",
              ["[a"] = "@parameter.outer",
              ["[k"] = "@call.outer",
              ["[/"] = "@comment.outer",
              ["[r"] = "@conditional.outer",
              ["[o"] = "@loop.outer",
              -- ["[t"] = "@return.outer",
            },
            goto_previous_end = {
              ["[F"] = "@function.outer",
              ["[C"] = "@class.outer",
              ["[G"] = "@block.outer",
              ["[A"] = "@parameter.outer",
              ["[K"] = "@call.outer",
              ["[?"] = "@comment.outer",
              ["[R"] = "@conditional.outer",
              ["[O"] = "@loop.outer",
            },
          },
        },
      })
      -- Configuration to treat JSONC files as JSON
      vim.treesitter.language.register("json", "jsonc")

      local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

      -- Create a repeatable pair of functions for diagnostics
      local goto_next_diagnostic, goto_prev_diagnostic =
        ts_repeat_move.make_repeatable_move_pair(vim.diagnostic.goto_next, vim.diagnostic.goto_prev)

      -- Set keymaps for diagnostics
      vim.keymap.set("n", "]d", goto_next_diagnostic, { desc = "Next diagnostic (repeatable)" })
      vim.keymap.set("n", "[d", goto_prev_diagnostic, { desc = "Prev diagnostic (repeatable)" })

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

      -- Make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
  { "nvim-treesitter/nvim-treesitter-textobjects", event = "VeryLazy" },
  {
    "David-Kunz/treesitter-unit",
    event = "VeryLazy",
    config = function()
      -- vim.keymap.set('x', 'u', ':<c-u>lua require"treesitter-unit".select()<CR>')
      vim.keymap.set("x", "u", ':<c-u>lua require"treesitter-unit".select(true)<CR>')
      -- vim.keymap.set('o', 'u', ':<c-u>lua require"treesitter-unit".select()<CR>')
      vim.keymap.set("o", "u", ':<c-u>lua require"treesitter-unit".select(true)<CR>')
    end,
  },
}
