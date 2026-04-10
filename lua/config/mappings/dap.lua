-- DAP (Debug Adapter Protocol) keymaps

vim.keymap.set("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "DAP REPL" })
