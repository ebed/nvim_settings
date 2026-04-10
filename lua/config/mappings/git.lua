-- Git integration keymaps
-- Note: Most git keymaps are defined in snacks.lua (snacks.picker.git_*)
-- Keeping only the main lazygit toggle here

vim.keymap.set("n", "<leader>gg", function()
  require("snacks").lazygit()
end, { desc = "Open LazyGit (Snacks)" })

-- Telescope git commands - REMOVED (duplicated with snacks.picker)
-- These are now defined in snacks.lua:
-- <leader>gb → Snacks.picker.git_branches()
-- <leader>gl → Snacks.picker.git_log()
-- <leader>gs → Snacks.picker.git_status()
-- <leader>gd → Snacks.picker.git_diff()
-- <leader>gc → Can use snacks picker or add here if needed

-- If you prefer telescope for git commits instead of snacks:
-- vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits (Telescope)" })
