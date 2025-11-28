return {
  -- Navigate and manipulate file system
  "echasnovski/mini.files",
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
    content = {
      filter = function(entry)
        return entry.fs_type ~= "file" or entry.name ~= ".DS_Store"
      end,
    },
  },
  keys = {
    {
      "-",
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        require("mini.files").open(path)
        require("mini.files").reveal_cwd()
      end,
      desc = "Open Mini Files",
    },
    {
      "<leader>f-",
      function()
        local buf_name = vim.api.nvim_buf_get_name(0)
        local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
        require("mini.files").open(path)
        require("mini.files").reveal_cwd()
      end,
      desc = "Open Mini Files",
    },
  },
  -- config = function(_, opts)
  --   require("mini.files").setup(opts)
  --
  --   vim.keymap.set("n", "-", function()
  --     local buf_name = vim.api.nvim_buf_get_name(0)
  --     local path = vim.fn.filereadable(buf_name) == 1 and buf_name or vim.fn.getcwd()
  --     MiniFiles.open(path)
  --     MiniFiles.reveal_cwd()
  --   end, { desc = "Open Mini Files" })
  -- end,
}
