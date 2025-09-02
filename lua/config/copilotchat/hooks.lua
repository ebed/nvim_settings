
local M = {}

-- Simple pattern: "create file <path>"
function M.process_copilot_response(msg)
  for lang, path, content in msg:gmatch("```(%w+)%s+path=([%w%./_-]+)[^\n]*\n(.-)```") do
    -- Create directory if needed
    local dir = path:match("(.+)/[^/]+$")
    if dir and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
    -- Write content to file
    local lines = {}
    for line in content:gmatch("[^\r\n]+") do
      table.insert(lines, line)
    end
    vim.fn.writefile(lines, path)
    vim.notify("CopilotChat: Created file " .. path, vim.log.levels.INFO)
  end
end

function M.apply_code_blocks_from_string(msg)
  for lang, path, content in msg:gmatch("```(%w+)%s+path=([%w%./_-]+)[^\n]*\n(.-)```") do
    local dir = path:match("(.+)/[^/]+$")
    if dir and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, "p")
    end
    local file_lines = {}
    for line in content:gmatch("[^\r\n]+") do
      table.insert(file_lines, line)
    end
    vim.fn.writefile(file_lines, path)
    vim.notify("CopilotChat: Created file " .. path, vim.log.levels.INFO)
  end
end

return M
