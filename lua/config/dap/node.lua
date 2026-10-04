-- JavaScript / TypeScript debug adapters and configurations.
-- see configurations from https://github.com/rezhaTanuharja/minimalistNVIM/blob/2b50b04cdfd57797940540c51cc63c8c492fb0ac/lua/debug_js.lua

local M = {}

local languages = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
}

local js_debug_server = function()
  return {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }
end

-- Makes an old adapter name resolve to the js-debug (pwa) one
local alias_adapter = function(alias, target)
  return function(cb, config)
    if config.type == alias then
      config.type = target
    end

    local adapter = require("dap").adapters[target]
    if type(adapter) == "function" then
      adapter(cb, config)
    else
      cb(adapter)
    end
  end
end

-- Shared defaults for every js-debug (pwa-*) launch config.
local function debug_config(overrides)
  return vim.tbl_deep_extend("force", {
    type = "pwa-node",
    sourceMaps = true,
    cwd = "${workspaceFolder}",
    resolveSourceMapLocations = {
      "${workspaceFolder}/**",
      "!**/node_modules/**",
    },
  }, overrides)
end

local vitest_program = "${workspaceFolder}/node_modules/vitest/vitest.mjs"

local configurations = {
  debug_config({
    request = "launch",
    name = "Launch file",
    program = "${file}",
  }),
  debug_config({
    type = "pwa-chrome",
    request = "launch",
    name = "Launch using Chrome",
    url = function()
      vim.cmd("redraw")
      return vim.fn.input("URL: ", "http://localhost:3000")
    end,
    webRoot = "${workspaceFolder}",
  }),
  debug_config({
    request = "launch",
    name = "Vitest: current test file",
    program = vitest_program,
    args = { "run", "${file}", "--no-file-parallelism" },
  }),
  debug_config({
    request = "launch",
    name = "Vitest: current test by name",
    program = vitest_program,
    args = {
      "run",
      "-t",
      function()
        vim.cmd("redraw")
        return vim.fn.input("Test name: ")
      end,
      "--no-file-parallelism",
    },
  }),
  debug_config({
    request = "launch",
    name = "Vitest: all tests",
    program = vitest_program,
    args = { "run", "--no-file-parallelism" },
  }),
}

function M.setup()
  local dap = require("dap")

  dap.adapters["pwa-node"] = js_debug_server()
  dap.adapters["pwa-chrome"] = js_debug_server()
  dap.adapters["node"] = alias_adapter("node", "pwa-node")
  dap.adapters["chrome"] = alias_adapter("chrome", "pwa-chrome")

  for _, language in ipairs(languages) do
    dap.configurations[language] = configurations
  end
end

return M
