-- JDTLS fixes and workarounds
-- Suppress known errors and noisy messages

-- Override window/showMessage to filter JDTLS noise
local original_show_message = vim.lsp.handlers["window/showMessage"]
vim.lsp.handlers["window/showMessage"] = function(err, result, ctx, config)
  -- Suppress copilot error about java.edit.organizeImports
  if result and result.message and result.message:match("java%.edit%.organizeImports") then
    return -- Suppress this error
  end

  -- Call original handler for other messages
  if original_show_message then
    return original_show_message(err, result, ctx, config)
  end
end

-- Override window/logMessage to filter JDTLS noise
local original_log_message = vim.lsp.handlers["window/logMessage"]
vim.lsp.handlers["window/logMessage"] = function(err, result, ctx, config)
  -- Filter out repetitive JDTLS messages
  if result and result.message then
    local msg = result.message
    if msg:match("^Building") or
       msg:match("^Validate documents") or
       msg:match("^Publish Diagnostics") then
      return -- Suppress noisy messages
    end
  end

  -- Call original handler for other messages
  if original_log_message then
    return original_log_message(err, result, ctx, config)
  end
end

-- Alternative: Organize imports command that works
-- This avoids the Copilot issue by providing the correct command
vim.api.nvim_create_user_command("OrganizeImports", function()
  if vim.bo.filetype == "java" then
    local ok, jdtls = pcall(require, 'jdtls')
    if ok and type(jdtls.organize_imports) == "function" then
      jdtls.organize_imports()
    else
      vim.notify("JDTLS not available", vim.log.levels.WARN)
    end
  else
    -- For other languages, use LSP code action
    vim.lsp.buf.code_action({
      context = { only = { "source.organizeImports" } },
      apply = true,
    })
  end
end, { desc = "Organize imports (all languages)" })

return {}
