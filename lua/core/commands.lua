-- Custom user commands

-- :Eslint [errors|warnings]
-- Runs ESLint in the current project (cwd) asynchronously
-- and sends the results to the quickfix list.
vim.api.nvim_create_user_command("Eslint", function(args)
  -- Current project directory
  local cwd = vim.fn.getcwd()

  -- Optional filter: "errors", "warnings" or empty (both)
  local filter = (args.args or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")

  -- Determine which severities to include
  local include_errors = filter == "" or filter:find("error", 1, true)
  local include_warnings = filter == "" or filter:find("warn", 1, true)

  -- Validate the argument
  if not include_errors and not include_warnings then
    vim.notify("ESLint: use 'errors', 'warnings' or none", vim.log.levels.WARN)
    return
  end

  vim.notify("ESLint: running in " .. cwd, vim.log.levels.INFO)

  -- Run eslint without blocking the UI
  vim.system({ "npx", "eslint", "--format", "json", "." }, {
    cwd = cwd,
    text = true,
  }, function(result)
    -- Back to Neovim's main thread
    vim.schedule(function()
      local output = result.stdout or ""

      -- If it failed and there is no output, report error
      if result.code ~= 0 and output == "" then
        vim.notify("ESLint execution failed: " .. (result.stderr or ""), vim.log.levels.ERROR)
        return
      end

      -- Parse ESLint JSON
      local ok, results = pcall(vim.json.decode, output)
      if not ok or type(results) ~= "table" then
        vim.notify("Could not parse ESLint JSON", vim.log.levels.ERROR)
        return
      end

      -- Convert ESLint messages to quickfix items
      local items = {}
      for _, result in ipairs(results) do
        for _, message in ipairs(result.messages or {}) do
          local is_error = message.severity == 2
          -- Apply the chosen severity filter
          if (is_error and include_errors) or (not is_error and include_warnings) then
            table.insert(items, {
              filename = result.filePath,
              lnum = message.line or 1,
              col = message.column or 1,
              end_lnum = message.endLine,
              end_col = message.endColumn,
              text = message.message .. " [" .. (message.ruleId or "unknown") .. "]",
              type = is_error and "E" or "W",
            })
          end
        end
      end

      -- If there are no items, notify and exit
      if #items == 0 then
        vim.notify("ESLint: no diagnostics", vim.log.levels.INFO)
        return
      end

      -- Replace the quickfix list with items and open it
      vim.fn.setqflist({}, " ", {
        title = "ESLint",
        items = items,
      })
      vim.cmd("copen")
      vim.notify("ESLint: " .. #items .. " diagnostics")
    end)
  end)
end, {
  nargs = "?",
  complete = function()
    return { "errors", "warnings" }
  end,
})