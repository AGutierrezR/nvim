local keymap = vim.keymap.set

-- ════════════════════════════════════════════════════════════════════════════
-- Essential Operations
-- ════════════════════════════════════════════════════════════════════════════

-- Save file
keymap("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
keymap({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })

-- Quit
keymap("n", "<leader>qq", "<cmd>q<cr>", { desc = "Quit" })
keymap("n", "<leader>qQ", "<cmd>qa<cr>", { desc = "Quit All" })

-- Clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<cr>", { silent = true, desc = "Clear search highlighting" })

-- remove Q keymap
keymap("n", "Q", "<nop>")

-- ════════════════════════════════════════════════════════════════════════════
-- Window Navigation (no prefix for speed)
-- ════════════════════════════════════════════════════════════════════════════

-- Windows resizing
keymap("n", "<C-w>.", ":vertical resize +20<cr>")
keymap("n", "<C-w>,", ":vertical resize -20<cr>")

-- ════════════════════════════════════════════════════════════════════════════
-- Line Movement (Visual Mode)
-- ════════════════════════════════════════════════════════════════════════════

keymap("v", "J", ":m .+1<CR>==", { desc = "Move line down in v mode" })
keymap("v", "K", ":m .-2<CR>==", { desc = "Move line down in v mode" })
keymap("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down in x mode" })
keymap("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line down in x mode" })

-- ════════════════════════════════════════════════════════════════════════════
-- Better Navigation
-- ════════════════════════════════════════════════════════════════════════════

-- Wrapped line navigation
keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (wrapped)" })
keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (wrapped)" })

keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center cursor" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center cursor" })

-- ════════════════════════════════════════════════════════════════════════════
-- Better Editing
-- ════════════════════════════════════════════════════════════════════════════

-- delete single character without copying into register
keymap("n", "x", '"_x')

-- Select last pasted text
keymap("n", "gV", "`[v`]", { desc = "Select last pasted text" })

-- better indent handling
keymap("v", "<", "<gv", { desc = "Indent Left" })
keymap("v", ">", ">gv", { desc = "Indent Right" })

-- Yank block
keymap("n", "YY", "va{Vy", { desc = "Yank Block {}" })

-- Better join lines
keymap("n", "J", "mzJ`z")

-- Split line (opposite of J)
keymap(
  "n",
  "X",
  ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>",
  { desc = "Split Line", silent = true }
)

-- Search within visual selection
-- Use <C-\\><C-n> to exit visual mode properly and not <Esc> which can have issues in some terminals
keymap("x", "g/", "<C-\\><C-n>`</\\%V", { silent = false, desc = "Search inside visual selection" })

-- Yank to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap({ "n", "v" }, "gy", '"+y', { desc = "Copy to system clipboard" })

-- Move yank register 0 to system clipboard
keymap({ "n" }, "yc", function()
  local target_register = "+"
  -- Get the content and type of the yank register
  local yank_content = vim.fn.getreg("0")
  local yank_type = vim.fn.getregtype("0")
  -- Move the content to the specified register
  vim.fn.setreg(target_register, yank_content, yank_type)
  print(string.format("Text moved to register '%s'.", target_register))
end, { desc = "Paste register 0 to system clipboard" })

-- copy to to system clipboard (till end of line)
keymap({ "n" }, "gY", '"+y$', { desc = "Yank to clipboard EOL" })

-- paste from the system clipboard
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap({ "n", "v" }, "gp", '"+p', { desc = "Paste from system clipboard" })

-- Helper function to insert empty lines
_G.put_empty_line = function(put_above)
  if type(put_above) == "boolean" then
    vim.o.operatorfunc = "v:lua.put_empty_line"
    vim.g._put_empty_line_above = put_above
    return "g@l"
  end

  local target = vim.fn.line(".") - (vim.g._put_empty_line_above and 1 or 0)
  vim.fn.append(target, vim.fn["repeat"]({ "" }, vim.v.count1))
end

-- NOTE: if you don't want to support dot-repeat, use this snippet:
-- ```
-- keymap('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
-- keymap('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
-- ```
keymap("n", "gO", "v:lua.put_empty_line(v:true)", { expr = true, desc = "Put empty line above" })
keymap("n", "go", "v:lua.put_empty_line(v:false)", { expr = true, desc = "Put empty line below" })

-- ════════════════════════════════════════════════════════════════════════════
-- File related Operations
-- ════════════════════════════════════════════════════════════════════════════

-- Create new file
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File", silent = true })

-- Copy file paths with line and column numbers
keymap("n", "<leader>fyp", function()
  local file = vim.fn.expand("%:.") -- Relative path
  local line = vim.fn.line(".") -- Current line
  local col = vim.fn.col(".") -- Current column
  local path_with_pos = string.format("%s:%d:%d", file, line, col)

  -- Copy to clipboard
  vim.fn.setreg("+", path_with_pos)
  vim.notify("filepath: " .. path_with_pos .. " has been copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy relative filepath with line and column", silent = true })

-- Copy different file paths
keymap("n", "<leader>fya", ":let @+ = expand('%:p')<cr>", { desc = "Copy absolute filepath", silent = true })
keymap("n", "<leader>fyr", ":let @+ = expand('%:.')<cr>", { desc = "Copy relative filepath", silent = true })
keymap("n", "<leader>fyn", ":let @+ = expand('%:t')<cr>", { desc = "Copy filename", silent = true })

-- ════════════════════════════════════════════════════════════════════════════
-- Buffer and Tab Management
-- ════════════════════════════════════════════════════════════════════════════

-- Switch to last accessed buffer
keymap("n", "ga", "<cmd>b#<CR>", { desc = "Switch to last accessed buffer" })

-- Close current buffer
keymap("n", "<leader>bD", "<cmd>:bd<CR>", { desc = "Delete Buffer and Window", silent = true })

-- Tabs
keymap("n", "<C-t>", ":tabnew<cr>", { desc = "New tab" }) -- remove ctags keymap
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- ════════════════════════════════════════════════════════════════════════════
-- TMUX
-- ════════════════════════════════════════════════════════════════════════════

keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix (Unimpaird style)
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Go to prev quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Go to next quickfix item" })

-- ════════════════════════════════════════════════════════════════════════════
-- Terminal
-- ════════════════════════════════════════════════════════════════════════════

-- Close terminal
keymap("t", "<esc><esc>", "<c-\\><c-n>")

-- These two keymaps go together because some terminals may register <C-/> as <C-_>
keymap("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
keymap("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })
