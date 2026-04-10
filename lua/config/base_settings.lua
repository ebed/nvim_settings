-- Configuración de opciones básicas de Neovim
vim.o.number = true
vim.o.relativenumber = true
vim.o.clipboard = "unnamedplus"
vim.o.termguicolors = true

-- Configuración de leader key
vim.g.mapleader = " "

-- Terminal: Auto-entrar en insert mode al navegar a un terminal
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "WinEnter" }, {
  pattern = "term://*",
  callback = function()
    vim.cmd("startinsert")
  end,
  desc = "Auto-enter insert mode when entering terminal buffer"
})
