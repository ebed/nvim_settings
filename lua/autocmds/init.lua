vim.api.nvim_create_autocmd("FileType", {
  pattern = "*copilot-chat*",
  callback = function()
    vim.cmd("hi! link markdownError Normal")
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "Trouble",
  callback = function()
    local opts = { buffer = true }
    -- Saltar al error y mostrar acciones
    vim.keymap.set("n", "a", function()
      vim.cmd("normal <CR>")
      vim.defer_fn(function()
        vim.lsp.buf.code_action()
      end, 100)
    end, vim.tbl_extend("force", opts, { desc = "Jump & Show Actions" }))

    -- Fix directo si hay una solución única
    vim.keymap.set("n", "f", function()
      vim.cmd("normal <CR>")
      vim.defer_fn(function()
        vim.lsp.buf.code_action({
          filter = function(a)
            return #a == 1
          end,
          apply = true,
        })
      end, 100)
    end, vim.tbl_extend("force", opts, { desc = "Fix (if single solution)" }))
  end,
})
