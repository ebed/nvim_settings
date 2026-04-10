-- Harpoon Keymaps
-- Quick navigation between marked files
-- Plugin already installed, just adding keybindings

local harpoon = require("harpoon")

-- ============================================================================
-- HARPOON MANAGEMENT
-- ============================================================================

-- Add/remove files
vim.keymap.set("n", "<leader>ha", function()
  harpoon:list():add()
  vim.notify("📍 File marked with Harpoon", vim.log.levels.INFO)
end, { desc = "Harpoon: Add file" })

-- Toggle quick menu
vim.keymap.set("n", "<leader>hm", function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = "Harpoon: Toggle menu" })

-- ============================================================================
-- QUICK NAVIGATION (1-4)
-- ============================================================================

-- Jump to marked files
vim.keymap.set("n", "<leader>1", function()
  harpoon:list():select(1)
end, { desc = "Harpoon: Jump to file 1" })

vim.keymap.set("n", "<leader>2", function()
  harpoon:list():select(2)
end, { desc = "Harpoon: Jump to file 2" })

vim.keymap.set("n", "<leader>3", function()
  harpoon:list():select(3)
end, { desc = "Harpoon: Jump to file 3" })

vim.keymap.set("n", "<leader>4", function()
  harpoon:list():select(4)
end, { desc = "Harpoon: Jump to file 4" })

-- ============================================================================
-- CYCLE THROUGH MARKED FILES
-- ============================================================================

-- Next/Previous marked file
vim.keymap.set("n", "<leader>hn", function()
  harpoon:list():next()
end, { desc = "Harpoon: Next file" })

vim.keymap.set("n", "<leader>hp", function()
  harpoon:list():prev()
end, { desc = "Harpoon: Previous file" })
