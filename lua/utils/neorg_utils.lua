

-- En tu archivo ~/.config/nvim/lua/neorg_utils.lua
local M = {}

function M.open_or_create_linked_file()
  local line = vim.api.nvim_get_current_line()
  local link = line:match("%[(.-)%]%((.-)%)")
  if link then
    local path = link:match("%((.-)%)")
    if path then
      if vim.fn.filereadable(path) == 0 then
        vim.cmd("edit " .. path)
        vim.cmd("write")
      else
        vim.cmd("edit " .. path)
      end
    end
  end
end

return M
