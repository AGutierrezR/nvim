local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

keymap("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- windows
keymap("n", "<C-w>.", ":vertical resize +20<cr>")
keymap("n", "<C-w>,", ":vertical resize -20<cr>")

-- remove Q keymap
keymap("n", "Q", "<nop>")

keymap("n", "<leader>w", ":w<CR>", { desc = "Save buffer", silent = true })
keymap("n", "<leader>qq", "<cmd>qa<CR>", { desc = "Quit All", silent = true })
keymap("n", "<leader>bD", "<cmd>:bd<CR>", { desc = "Delete Buffer and Window", silent = true })
keymap("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File", silent = true })

-- clear search highlighting
keymap("n", "<Esc>", ":nohlsearch<cr>", { silent = true, desc = "Clear search highlighting" })

-- search in file what is selected in visual mode
-- keymap("v", "*", '"6y/\\V<C-r>6<CR>N', { desc = "Search forward in file what is selected in visual mode" })
-- keymap("v", "#", '"6y?\\V<C-r>6<CR>N', { desc = "Search backward in file what is selected in visual mode" })

-- Better join lines
keymap("n", "J", "mzJ`z")

-- yank to system clipboard
keymap({ "n", "v" }, "<leader>y", '"+y', { desc = "Copy to system clipboard" })

-- paste from the system clipboard
keymap({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })

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

-- Switch to last accessed buffer
keymap("n", "ga", "<cmd>b#<CR>", { desc = "Switch to last accessed buffer" })

keymap("n", "<C-k>", "k")

keymap("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

-- Quickfix (Unimpaird style)
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Go to prev quickfix item" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Go to next quickfix item" })

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
