vim.api.nvim_create_autocmd("BufReadPost", {
  print("Loading HTTP filetype configuration..."),
  pattern = "*.http",
  callback = function(args)
    local http_path = args.file
    local repo_dir = vim.fn.fnamemodify(http_path, ":h")
    local scripts_dir = repo_dir .. "/scripts/"
    if vim.fn.isdirectory(scripts_dir) == 1 then
      local lua_files = vim.fn.globpath(scripts_dir, "*.lua", false, true)
      for _, file in ipairs(lua_files) do
        dofile(file)
      end
      print("Loaded Lua scripts from: " .. scripts_dir)
    end
  end,
})
