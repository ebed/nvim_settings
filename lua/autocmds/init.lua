    vim.api.nvim_create_autocmd("FileType", {
      pattern = "*copilot-chat*",
      callback = function()
        vim.cmd("hi! link markdownError Normal")
      end,
    })

