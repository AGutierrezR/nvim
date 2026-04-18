---@class SnacksUtils
---@field copy_action fun(picker: any, item: table): nil
---@field search_in_directory table
local M = {}

---Copies the selected file path to clipboard in different formats.
---Shows a menu to select between: relative path, absolute path, or filename.
---@param picker any The Snacks picker object (unused)
---@param table item Table with the selected file information
---@return nil
M.copy_action = function(_, item)
  local modify = vim.fn.fnamemodify

  local filepath = item.file
  local filename = modify(filepath, ":t")

  local results = {
    filepath,
    modify(filepath, ":."),
    modify(filepath, ":~"),
    filename,
    modify(filename, ":r"),
    modify(filename, ":e"),
  }

  local items = {
    "Relative Path (CWD): " .. results[2],
    "Absolute path: " .. results[1],
    "Filename: " .. results[4],
  }

  vim.ui.select(items, {
    prompt = "Select Copy Operation",
  }, function(choice, i)
    if not choice then
      vim.notify("Selection Cancelled")
      return
    end
    if not i then
      vim.notify("Invalid Selection")
      return
    end
    local result = results[i]
    vim.fn.setreg('"', result)
    vim.notify("Copied: " .. result)
  end)
end

---Action to search within the directory of the selected file.
---Opens Snacks grep picker in the file's directory with filters to ignore common directories.
---@field action fun(picker: any, item: table): nil
M.search_in_directory = {
  action = function(_, item)
    if not item then
      return
    end
    local dir = vim.fn.fnamemodify(item.file, ":p:h")
    Snacks.picker.grep({
      cwd = dir,
      cmd = "rg",
      args = {
        "-g", "!.git",
        "-g", "!node_modules",
        "-g", "!dist",
        "-g", "!build",
        "-g", "!coverage",
        "-g", "!.DS_Store",
        "-g", "!.docusaurus",
        "-g", "!.dart_tool",
      },
      show_empty = true,
      hidden = true,
      ignored = true,
      follow = false,
      supports_live = true,
    })
  end,
}

M.lsp_pickers_filter = {
  filter = {
    default = true,
    lua = true,
  },
}

return M
