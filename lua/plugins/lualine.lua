local mode_map = {

  ["NORMAL"] = "N",
  ["O-PENDING"] = "N?",
  ["INSERT"] = "I",
  ["VISUAL"] = "V",
  ["V-BLOCK"] = "VB",
  ["V-LINE"] = "VL",
  ["V-REPLACE"] = "VR",
  ["REPLACE"] = "R",
  ["COMMAND"] = "!",
  ["SHELL"] = "SH",
  ["TERMINAL"] = "T",
  ["EX"] = "X",
  ["S-BLOCK"] = "SB",
  ["S-LINE"] = "SL",
  ["SELECT"] = "S",
  ["CONFIRM"] = "Y?",
  ["MORE"] = "M",
}

local function place()
  local linePre = "L:"
  local line = "%l/%L"
  return string.format("%s%s", linePre, line)
end

-- Normalize path (similar to LazyVim's norm function)
local function norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then
      home = home:sub(1, -2)
    end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

-- Helper function to format with highlight groups
local function format_hl(component, text, hl_group)
  if not hl_group or hl_group == "" then
    return text
  end
  component.hl_cache = component.hl_cache or {}
  local lualine_hl_group = component.hl_cache[hl_group]
  if not lualine_hl_group then
    local utils = require("lualine.utils.utils")
    local gui = vim.tbl_filter(function(x)
      return x
    end, {
      utils.extract_highlight_colors(hl_group, "bold") and "bold",
      utils.extract_highlight_colors(hl_group, "italic") and "italic",
    })

    lualine_hl_group = component:create_hl({
      fg = utils.extract_highlight_colors(hl_group, "fg"),
      gui = #gui > 0 and table.concat(gui, ",") or nil,
    }, "LV_" .. hl_group)
    component.hl_cache[hl_group] = lualine_hl_group
  end
  return component:format_hl(lualine_hl_group) .. text .. component:get_default_hl()
end

-- Pretty path function (inspired by LazyVim)
local function pretty_path(opts)
  opts = vim.tbl_extend("force", {
    relative = "cwd",
    modified_hl = "MatchParen",
    directory_hl = "",
    filename_hl = "Bold",
    modified_sign = "",
    readonly_icon = " 󰌾 ",
    length = 3,
  }, opts or {})

  return function(self)
    local path = vim.fn.expand("%:p")

    if path == "" then
      return ""
    end

    local cwd = norm(vim.fn.getcwd())
    path = norm(path)

    -- Make path relative to cwd if it starts with cwd
    if path:find(cwd, 1, true) == 1 then
      path = path:sub(#cwd + 2)
    end

    local sep = package.config:sub(1, 1)
    local parts = vim.split(path, "[\\/]")

    -- Shorten path if it's too long
    if opts.length > 0 and #parts > opts.length then
      parts = { parts[1], "…", unpack(parts, #parts - opts.length + 2, #parts) }
    end

    -- Format filename with appropriate highlight
    if opts.modified_hl and vim.bo.modified then
      parts[#parts] = parts[#parts] .. opts.modified_sign
      parts[#parts] = format_hl(self, parts[#parts], opts.modified_hl)
    else
      parts[#parts] = format_hl(self, parts[#parts], opts.filename_hl)
    end

    -- Format directory path
    local dir = ""
    if #parts > 1 then
      dir = table.concat({ unpack(parts, 1, #parts - 1) }, sep)
      dir = format_hl(self, dir .. sep, opts.directory_hl)
    end

    -- Add readonly icon if file is readonly
    local readonly = ""

    if vim.bo.readonly then
      readonly = format_hl(self, opts.readonly_icon, opts.modified_hl)
    end

    return dir .. parts[#parts] .. readonly
  end
end

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    options = {
      -- theme = "auto",
      -- globalstatus = vim.o.laststatus == 3,
      section_separators = "",
      component_separators = "",
      disabled_filetypes = { statusline = { "dashboard", "alpha", "ministarter", "snacks_dashboard" } },
      always_show_tabline = false,
    },
    sections = {
      lualine_a = {
        {
          "mode",
          fmt = function(s)
            return mode_map[s] or s
          end,
        },
      },
      lualine_b = {
        { "branch", icon = "󰘬" },
        "diff",
        "diagnostics",
      },
      lualine_c = {
        {
          pretty_path({
            modified_sign = "",
            modified_hl = "DiagnosticInfo", -- Usa un grupo de highlight azul
            relative = "cwd",
          }),
        },
      },
      lualine_x = {
        "encoding",
        "filetype",
      },
      lualine_y = {},
      lualine_z = { { place, padding = { left = 1, right = 1 } } },
    },
    tabline = {
      lualine_a = {
        {
          "tabs",
          mode = 1,
          use_mode_colors = true,
          path = 0,
          symbols = { modified = "+" },
          fmt = function(name, context)
            -- add icon to left of active filename (per tab)
            local devicons = require("nvim-web-devicons")
            local icon, _ = devicons.get_icon(name, nil, { default = true })
            return icon .. ' ' .. name 
          end,
          -- allow stretching full with of screen (tabline)
          max_length = vim.o.columns - 1
        },
      },
    },
  },
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
