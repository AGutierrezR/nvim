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

---Snippets picker configuration for Snacks
---@class SnacksSnippetsConfig
M.snippets = {
  supports_live = false,
  preview = "preview",
  format = function(item, picker)
    local name = Snacks.picker.util.align(item.name, picker.align_1 + 5)
    return {
      { name, item.ft == "" and "Conceal" or "DiagnosticWarn" },
      { item.description },
    }
  end,
  finder = function(_, ctx)
    local snippets = {}
    for _, snip in ipairs(require("luasnip").get_snippets().all) do
      snip.ft = ""
      table.insert(snippets, snip)
    end
    for _, snip in ipairs(require("luasnip").get_snippets(vim.bo.ft)) do
      snip.ft = vim.bo.ft
      table.insert(snippets, snip)
    end
    local align_1 = 0
    for _, snip in pairs(snippets) do
      align_1 = math.max(align_1, #snip.name)
    end
    ctx.picker.align_1 = align_1
    local items = {}
    for _, snip in pairs(snippets) do
      local docstring = snip:get_docstring()
      if type(docstring) == "table" then
        docstring = table.concat(docstring)
      end
      local name = snip.name
      local description = table.concat(snip.description)
      description = name == description and "" or description
      table.insert(items, {
        text = name .. " " .. description,
        name = name,
        description = description,
        trigger = snip.trigger,
        ft = snip.ft,
        preview = {
          ft = snip.ft,
          text = docstring,
        },
      })
    end
    return items
  end,
  confirm = function(picker, item)
    picker:close()
    local expand = {}
    require("luasnip").available(function(snippet)
      if snippet.trigger == item.trigger then
        table.insert(expand, snippet)
      end
      return snippet
    end)
    if #expand > 0 then
      vim.cmd(":startinsert!")
      vim.defer_fn(function()
        require("luasnip").snip_expand(expand[1])
      end, 50)
    else
      Snacks.notify.warn("No snippet to expand")
    end
  end,
}

return M
