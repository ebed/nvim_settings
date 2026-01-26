-- Plugin-specific keymaps: CopilotChat, Snacks, Bookmarks, Markdown, etc.

-- CopilotChat & AI Assistants
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle CopilotChat" })
vim.keymap.set("n", "<leader>cp", "<cmd>CopilotChatPrompt<CR>", { desc = "Prompt CopilotChat" })
vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDoc<CR>", { desc = "Document with CopilotChat" })

-- Snacks.nvim
vim.keymap.set("n", "<leader>sd", "<cmd>SnacksDashboard<CR>", { desc = "Snacks Dashboard" })
vim.keymap.set("n", "<leader>sp", "<cmd>SnacksPicker<CR>", { desc = "Snacks Picker" })
vim.keymap.set("n", "<leader>sn", "<cmd>SnacksNotify<CR>", { desc = "Snacks Notify" })
vim.keymap.set("n", "<leader>se", "<cmd>SnacksExplorer<CR>", { desc = "Snacks Explorer" })

-- Bookmarks
vim.keymap.set("n", "<leader>MB", "<cmd>BookmarksListAll<CR>", { desc = "Bookmarks list all" })
vim.keymap.set("n", "<leader>MB0", "<cmd>BookmarksList 0<CR>", { desc = "Bookmarks list group 0" })
vim.keymap.set("n", "<leader>MB1", "<cmd>BookmarksList 1<CR>", { desc = "Bookmarks list group 1" })
vim.keymap.set("n", "<leader>MB2", "<cmd>BookmarksList 2<CR>", { desc = "Bookmarks list group 2" })
vim.keymap.set("n", "<leader>MB3", "<cmd>BookmarksList 3<CR>", { desc = "Bookmarks list group 3" })
vim.keymap.set("n", "<leader>MB4", "<cmd>BookmarksList 4<CR>", { desc = "Bookmarks list group 4" })
vim.keymap.set("n", "<leader>MB5", "<cmd>BookmarksList 5<CR>", { desc = "Bookmarks list group 5" })
vim.keymap.set("n", "<leader>MB6", "<cmd>BookmarksList 6<CR>", { desc = "Bookmarks list group 6" })

-- Leap (motion plugin)
vim.keymap.set({ "x", "o" }, "R", function()
  require("leap.treesitter").select({
    opts = require("leap.user").with_traversal_keys("R", "r"),
  })
end, { desc = "Leap treesitter select" })

-- Markdown Preview
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- Terminal Build Tools
vim.keymap.set("n", "<leader>mb", "<cmd>lua _MAVEN_BUILD_TOGGLE()<CR>", { desc = "Maven Build" })
vim.keymap.set("n", "<leader>mr", "<cmd>lua _MAVEN_RUN_TOGGLE()<CR>", { desc = "Maven Run" })
vim.keymap.set("n", "<leader>et", "<cmd>lua _ELIXIR_MIX_TOGGLE()<CR>", { desc = "Elixir Mix" })
