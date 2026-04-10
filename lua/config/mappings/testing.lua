-- Testing keymaps: Neotest and HTTP client

-- Neotest
vim.keymap.set("n", "<leader>Te", '<cmd>lua require("neotest").run.run()<CR>', { desc = "Run Test" })
vim.keymap.set(
  "n",
  "<leader>Ta",
  '<cmd>lua require("neotest").run.run({suite = true})<CR>',
  { desc = "Run Test Suite" }
)
vim.keymap.set(
  "n",
  "<leader>Tc",
  '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
  { desc = "Run Test Current File" }
)
vim.keymap.set("n", "<leader>Ts", "<cmd>Neotest summary<CR>", { desc = "Test Summary" })

-- HTTP/REST client (filetype-specific)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    vim.keymap.set("n", "<leader>r", "<cmd>Rest run<cr>", { buffer = true, desc = "Run HTTP request" })
  end,
})
