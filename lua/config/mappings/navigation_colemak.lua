-- Colemak-DH Navigation Keymaps
-- Physical positions of hjkl on Colemak-DH keyboard layout
-- Using Alt key to avoid conflicts with <C-m> = <CR> (Enter)
-- m = h (left), n = j (down), e = k (up), i = l (right)

-- ============================================================================
-- WINDOW NAVIGATION (Colemak-DH with Alt key)
-- ============================================================================

-- Navigate between windows/splits
-- NOTE: Can't use <C-m> because it equals <CR> (Enter key)
vim.keymap.set("n", "<M-m>", "<C-w>h", { desc = "← Go to left window" })
vim.keymap.set("n", "<M-n>", "<C-w>j", { desc = "↓ Go to lower window" })
vim.keymap.set("n", "<M-e>", "<C-w>k", { desc = "↑ Go to upper window" })
vim.keymap.set("n", "<M-i>", "<C-w>l", { desc = "→ Go to right window" })

-- Move windows around (with Shift)
vim.keymap.set("n", "<M-M>", "<C-w>H", { desc = "Move window left" })
vim.keymap.set("n", "<M-N>", "<C-w>J", { desc = "Move window down" })
vim.keymap.set("n", "<M-E>", "<C-w>K", { desc = "Move window up" })
vim.keymap.set("n", "<M-I>", "<C-w>L", { desc = "Move window right" })

-- ============================================================================
-- WINDOW RESIZE (Colemak-DH)
-- ============================================================================

-- Resize windows with Ctrl + Colemak-DH (arrows)
-- Using h/j/k/l positions for consistency
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Up>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })

-- ============================================================================
-- TERMINAL MODE NAVIGATION (Colemak-DH with Alt key)
-- ============================================================================

-- Navigate between windows from terminal mode
-- NOTE: Can't use <C-m> because it equals <CR> (Enter key) which breaks terminal
vim.keymap.set("t", "<M-m>", "<C-\\><C-n><C-w>h", { desc = "← Go to left window" })
vim.keymap.set("t", "<M-n>", "<C-\\><C-n><C-w>j", { desc = "↓ Go to lower window" })
vim.keymap.set("t", "<M-e>", "<C-\\><C-n><C-w>k", { desc = "↑ Go to upper window" })
vim.keymap.set("t", "<M-i>", "<C-\\><C-n><C-w>l", { desc = "→ Go to right window" })

-- Exit terminal mode easily
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
