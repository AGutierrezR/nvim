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

M.grep_exclude = {
  "package-lock.json",
  "yarn.lock",
  "pnpm-lock.yaml",
  "bun.lock",
  "bun.lockb",

  "*.snap",
  "*.snapshot",
  "*.snap.js",
  "snap.js",
  "snapshots/",
  "__snapshots__/",
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

---Patch Snacks spelling source so corrections use native z=,
---keeping :spellrepall working (Snacks' default ciw does not register it).
---@return nil
M.patch_spelling = function()
  local ok, vim_source = pcall(require, "snacks.picker.source.vim")
  if not (ok and vim_source and vim_source.spelling) then
    return
  end
  local orig_spelling = vim_source.spelling
  vim_source.spelling = function(...)
    local items = orig_spelling(...)
    local bad = vim.fn.spellbadword()[1]
    if bad == "" then bad = vim.fn.expand("<cword>") end
    for idx, item in ipairs(items or {}) do
      item.action = function(...)
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = vim.api.nvim_buf_get_lines(0, cursor[1] - 1, cursor[1], false)[1] or ""
        local col = cursor[2] + 1
        while line:sub(col, col):match("%s") and col < #line do
          col = col + 1
          vim.api.nvim_win_set_cursor(0, { cursor[1], col - 1 })
        end
        vim.cmd("normal! " .. idx .. "z=")
        vim.g.last_spell_bad = bad
        vim.g.last_spell_good = vim.fn.expand("<cword>")
      end
    end
    return items
  end
end

return M
