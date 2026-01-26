-- Java diagnostic filtering for wildcard imports
-- Suppress warnings about using wildcard imports (import foo.*)

local M = {}

-- Configuration
M.config = {
  enabled = true,  -- Set to false to disable wildcard filtering
  patterns = {
    "wildcard",
    "avoid.*%*",
    "on demand",
    "star import",
    "avoid using.*import",
  }
}

-- Check if a diagnostic message should be filtered
function M.should_filter(message)
  if not M.config.enabled then
    return false
  end

  if not message then
    return false
  end

  local msg = message:lower()
  for _, pattern in ipairs(M.config.patterns) do
    if msg:match(pattern) then
      return true
    end
  end

  return false
end

-- Filter diagnostics array
function M.filter_diagnostics(diagnostics)
  if not M.config.enabled then
    return diagnostics
  end

  return vim.tbl_filter(function(d)
    return not M.should_filter(d.message)
  end, diagnostics)
end

-- Toggle filtering on/off
function M.toggle()
  M.config.enabled = not M.config.enabled
  local status = M.config.enabled and "enabled" or "disabled"
  vim.notify("Wildcard import diagnostic filtering " .. status, vim.log.levels.INFO)

  -- Refresh diagnostics for all Java buffers
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) then
      local ft = vim.api.nvim_get_option_value('filetype', { buf = bufnr })
      if ft == "java" then
        -- Trigger diagnostic refresh
        vim.diagnostic.reset(nil, bufnr)
      end
    end
  end
end

-- Setup command
vim.api.nvim_create_user_command("ToggleWildcardWarnings", function()
  M.toggle()
end, {
  desc = "Toggle wildcard import diagnostic filtering"
})

return M
