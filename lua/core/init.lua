-- Core configuration loader
require("core.options")
require("core.keymaps")
require("core.autocmds")
require("core.commands")

-- Load plugins if not disabled by the user
if vim.g.load_plugins ~= false then
  require("core.lazy")
end
