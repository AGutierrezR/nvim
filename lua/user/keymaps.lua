local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- keymap("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- Close terminal
keymap("t", "<esc><esc>", "<c-\\><c-n>")

keymap("n", "<C-d>", "<C-d>zz", { desc = "Scroll half page down and center cursor" })
keymap("n", "<C-u>", "<C-u>zz", { desc = "Scroll half page up and center cursor" })

-- Select last pasted text
keymap("n", "gV", "`[v`]", { desc = "Select last pasted text" })

-- windows
keymap("n", "<C-w>.", ":vertical resize +20<cr>")
keymap("n", "<C-w>,", ":vertical resize -20<cr>")

-- remove Q keymap
keymap("n", "Q", "<nop>")

-- Helper function to insert empty lines
_G.put_empty_line = function(put_above)
  if type(put_above) == "boolean" then
    vim.o.operatorfunc = "v:lua.put_empty_line"
    vim.g._put_empty_line_above = put_above
    return "g@l"
  end

  local target = vim.fn.line(".") - (vim.g._put_empty_line_above and 1 or 0)
  vim.fn.append( target, vim.fn["repeat"]({ "" }, vim.v.count1))
end

-- NOTE: if you don't want to support dot-repeat, use this snippet:
-- ```
-- keymap('n', 'gO', "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>")
-- keymap('n', 'go', "<Cmd>call append(line('.'),     repeat([''], v:count1))<CR>")
-- ```
keymap( "n", "gO", "v:lua.put_empty_line(v:true)", { expr = true, desc = "Put empty line above" })
keymap( "n", "go", "v:lua.put_empty_line(v:false)", { expr = true, desc = "Put empty line below" })


keymap("n", "<C-S>", "<Cmd>silent! update | redraw<CR>", { desc = "Save" })
keymap({ "i", "x" }, "<C-S>", "<Esc><Cmd>silent! update | redraw<CR>", { desc = "Save and go to Normal mode" })
keymap("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All", silent = true })

-- file related keymaps
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File", silent = true })
keymap("n", "<leader>fyp", function()
  local file = vim.fn.expand("%:.") -- Relative path
  local line = vim.fn.line(".") -- Current line
  local col = vim.fn.col(".") -- Current column
  local path_with_pos = string.format("%s:%d:%d", file, line, col)

  -- Copy to clipboard
  vim.fn.setreg("+", path_with_pos)
  vim.notify("filepath: " .. path_with_pos .. " has been copied to clipboard", vim.log.levels.INFO)
end, { desc = "Copy relative filepath with line and column", silent = true })

keymap("n", "<leader>fya", ":let @+ = expand('%:p')<cr>", { desc = "Copy absolute filepath", silent = true })
keymap("n", "<leader>fyr", ":let @+ = expand('%:.')<cr>", { desc = "Copy relative filepath", silent = true })
keymap("n", "<leader>fyn", ":let @+ = expand('%:t')<cr>", { desc = "Copy filename", silent = true })

-- clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<cr>", { silent = true, desc = "Clear search highlighting" })

-- search in file what is selected in visual mode
-- keymap("v", "*", '"6y/\\V<C-r>6<CR>N', { desc = "Search forward in file what is selected in visual mode" })
-- keymap("v", "#", '"6y?\\V<C-r>6<CR>N', { desc = "Search backward in file what is selected in visual mode" })

-- Better join lines
keymap("n", "J", "mzJ`z")

-- yank to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })
keymap({ "n", "v" }, "gy", '"+y', { desc = "Copy to system clipboard" })
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
keymap({ "n" }, 'gY', '"+y$', { desc = 'Yank to clipboard EOL' })

-- paste from the system clipboard
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
keymap({ "n", "v" }, "gp", '"+p', { desc = "Paste from system clipboard" })

-- better indent handling
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- Move lines in visual mode
keymap("v", "J", ":m .+1<CR>==", { desc = "Move line down in v mode" })
keymap("v", "K", ":m .-2<CR>==", { desc = "Move line down in v mode" })
keymap("x", "J", ":move '>+1<CR>gv-gv", { desc = "Move line down in x mode" })
keymap("x", "K", ":move '<-2<CR>gv-gv", { desc = "Move line down in x mode" })

-- delete single character without copying into register
keymap("n", "x", '"_x')

-- -- delete the whole file content
-- keymap("n", "die", [[<Cmd>:%d<CR>]])

-- Buffer navigation
-- Switch to last accessed buffer
keymap("n", "ga", "<cmd>b#<CR>", { desc = "Switch to last accessed buffer" })
keymap("n", "<leader>bw", ":w<CR>", { desc = "Save buffer", silent = true })
keymap("n", "<leader>bD", "<cmd>:bd<CR>", { desc = "Delete Buffer and Window", silent = true })
keymap("n", "<leader>bn", "<cmd>:bnext<CR>", { desc = "Next buffer" })
keymap("n", "<leader>bp", "<cmd>:bprevious<CR>", { desc = "Prev buffer" })

-- Tabs
keymap("n", "<C-t>", ":tabnew<cr>", { desc = "New tab" }) -- remove ctags keymap
keymap("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
keymap("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
keymap("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
keymap("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
keymap("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
keymap("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
keymap("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- keymap("n", "<C-k>", "k")

keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix (Unimpaird style)
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Go to prev quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Go to next quickfix item" })

-- Search within visual selection
-- Use <C-\\><C-n> to exit visual mode properly and not <Esc> which can have issues in some terminals
keymap("x", "g/", "<C-\\><C-n>`</\\%V", { silent = false, desc = "Search inside visual selection" })

keymap("n", "<leader>xq", function()
  local qf_list = vim.fn.getqflist()
  for _, win in ipairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      vim.cmd("cclose")
      return
    end
  end
  if #qf_list > 0 then
    vim.cmd("copen")
  else
    print("Quickfix list is empty")
  end
end, { desc = "Toggle Quickfix list" })

-- Add current location to QF list
keymap("n", "<leader>xa", function()
  vim.fn.setqflist({
    {
      filename = vim.fn.expand("%:p"),
      lnum = vim.fn.line("."),
      col = vim.fn.col("."),
      text = vim.fn.getline("."),
    },
  }, "a")
  print("Current position added to QF list.")
end, { desc = "Add current location to QF list" })

-- Clean QF list
keymap("n", "<leader>xc", function()
  vim.fn.setqflist({}, "r")

  print("Quickfix list cleared.")
end, { desc = "Clean QF list" })
