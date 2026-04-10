-- General keymaps: navigation, save, quit, buffers, windows
-- Basic Vim operations and navigation

-- Emacs-style navigation - Moved to Alt to free Ctrl for Colemak-DH
-- <C-E> needed for Colemak-DH window navigation (↑)
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<M-a>", "<Home>", { desc = "Go to line start (Alt+a)" })
vim.keymap.set({ "n", "v", "s", "o", "i", "c" }, "<M-e>", "<End>", { desc = "Go to line end (Alt+e)" })

-- Quick save and quit
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- Buffer navigation
vim.keymap.set("n", "<tab>", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<s-tab>", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })

-- Window management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- File explorer - REMOVED (defined in snacks.lua keys)
-- Use: <leader>e to toggle Snacks Explorer

-- Terminal toggle - REMOVED (defined in snacks.lua keys)
-- Use: <c-/> to toggle Snacks Terminal

-- Zen mode - REMOVED (defined in snacks.lua keys)
-- Use: <leader>z to toggle Zen Mode

-- Diagnostics
vim.keymap.set("n", "!", "<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true, silent = true })
