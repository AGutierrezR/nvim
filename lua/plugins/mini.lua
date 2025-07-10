return {
  {
    -- Navigate and manipulate file system
    "echasnovski/mini.files",
    event = "VeryLazy",
    version = false,
    opts = {
      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        go_in_plus = "<CR>",
        go_out = "H",
        go_out_plus = "h",
        reveal_cwd = ".",
        synchronize = "s",
        reset = ",",
      },
      options = {
        -- If set to false, files are moved to the trash directory
        -- To get this dir run :echo stdpath('data')
        -- ~/.local/share/neobean/mini.files/trash
        permanent_delete = false,
      },
    },
    config = function(_, opts)
      require("mini.files").setup(opts)

      vim.keymap.set("n", "-", function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        MiniFiles.open(path)
        MiniFiles.reveal_cwd()
      end, { desc = "Open Mini Files" })
    end,
  },
  {
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
              "^[%l%d]+%f[^%l%d]"
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
  },
  {
    -- Neovim Lua plugin with fast and feature-rich surround actions
    "echasnovski/mini.surround",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "", -- Find surrounding (to the left)
        highlight = "", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "", -- Update `n_lines`
      },
    },
    keys = {
      { "gz", "", desc = "+Surround" },
    },
    config = function(_, opts)
      require("mini.surround").setup(opts)
    end,
  },
  {
    "echasnovski/mini.pairs",
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    config = function()
      require("mini.pairs").setup()

      -- Disable pairs for `typr` filetype
      local f = function (args) vim.b[args.buf].minipairs_disable = true end
      vim.api.nvim_create_autocmd('Filetype', { pattern = 'typr', callback = f })
    end,
  },
  {
    -- Text edit operators
    "echasnovski/mini.operators",
    event = { "BufReadPost", "BufNewFile" },
    version = false,
    config = function()
      -- Each entry configures one operator.
      require("mini.operators").setup({
        -- Evaluate text and replace with output
        evaluate = {
          prefix = "",
        },

        -- Exchange text regions
        exchange = {
          prefix = "cx",

          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Multiply (duplicate) text
        multiply = {
          prefix = "cm",

          -- Function which can modify text before multiplying
          func = nil,
        },

        -- Replace text with register
        replace = {
          prefix = "cr",

          -- Whether to reindent new text to match previous indent
          reindent_linewise = true,
        },

        -- Sort text
        sort = {
          prefix = "cs",

          -- Function which does the sort
          func = nil,
        },
      })
    end,
  },
}
