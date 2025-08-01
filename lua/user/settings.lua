-- <leader> key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.netrw_banner = 0 -- gets rid of the banner for netrw
vim.g.netrw_altv = 1 -- change from left splitting to right splitting

-- This shows the current file path in the window title
vim.o.winbar = "%m %t - %{luaeval('vim.fn.expand(\"%:~:.\")')}"

-- Line number related settings
vim.opt.nu = true
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing split for example.
vim.opt.mouse = "a"

-- show which line your cursor is on
vim.opt.cursorline = true

-- Minimum number of screen lines to keep above and below the cursor
vim.opt.scrolloff = 6

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Improve backspace behavior
vim.opt.backspace = "indent,eol,start"
vim.opt.smartindent = true

-- Change undodir to undotree folder
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

-- tabs & indentation
vim.opt.tabstop = 2 -- 2 spaces for tab (prettier default)
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to space
vim.opt.autoindent = true -- copy indent from current line when starting new one

-- Highlight when yanking (copying) text
-- See `:help vim.highlight.on_yank()`
--
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-hightlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

vim.opt.spelllang = "en_us"
vim.opt.spell = true

--split windows
vim.opt.splitright = true --split vertical window to the right
vim.opt.splitbelow = true --split horizontal window to the bottom

vim.opt.colorcolumn = "80"

-- Enable editorconfig support
vim.g.editorconfig = true

-- Disable copilot for some files
vim.g.copilot_filetypes = {
  typr = false,
}
