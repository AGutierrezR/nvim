---@brief
---
--- https://github.com/typescript-language-server/typescript-language-server
---
--- `ts_ls`, aka `typescript-language-server`, is a Language Server Protocol implementation for TypeScript wrapping `tsserver`. Note that `ts_ls` is not `tsserver`.
---
--- `typescript-language-server` depends on `typescript`. Both packages can be installed via `npm`:
--- ```sh
--- npm install -g typescript typescript-language-server
--- ```
---
--- To configure typescript language server, add a
--- [`tsconfig.json`](https://www.typescriptlang.org/docs/handbook/tsconfig-json.html) or
--- [`jsconfig.json`](https://code.visualstudio.com/docs/languages/jsconfig) to the root of your
--- project.
---
--- Here's an example that disables type checking in JavaScript files.
---
--- ```json
--- {
---   "compilerOptions": {
---     "module": "commonjs",
---     "target": "es6",
---     "checkJs": false
---   },
---   "exclude": [
---     "node_modules"
---   ]
--- }
--- ```
---
--- Use the `:LspTypescriptSourceAction` command to see "whole file" ("source") code-actions such as:
--- - organize imports
--- - remove unused code

-- source: https://github.com/neovim/nvim-lspconfig/blob/master/lsp/ts_ls.lua
return {
  -- Command and arguments to start the server.
  cmd = { "typescript-language-server", "--stdio" },

  -- Filetypes to automatically attach to.
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { "package.json", "tsconfig.json", "jsconfig.json", ".git" },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {},
  -- single_file_support = true,
  -- init_options = {
  --   plugins = {
  --     {
  --       name = "ts-lit-plugin",
  --       location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/ts-lit-plugin",
  --       languages = { "javascript", "typescript" },
  --     },
  --     {
  --       name = "typescript-styled-plugin",
  --       location = "/Users/asgi/Library/Application Support/fnm/node-versions/v18.0.0/installation/lib/node_modules/typescript-styled-plugin",
  --       languages = { "javascript", "typescript" },
  --     },
  --   },
  -- },
}
