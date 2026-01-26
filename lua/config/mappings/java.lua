-- JDTLS (Java) specific keymaps

-- Java refactoring
vim.keymap.set("n", "<A-o>", "<Cmd>lua require'jdtls'.organize_imports()<CR>", { desc = "JDTLS: Organize Imports" })
vim.keymap.set("n", "crv", "<Cmd>lua require('jdtls').extract_variable()<CR>", { desc = "JDTLS: Extract Variable" })
vim.keymap.set(
  "v",
  "crv",
  "<Esc><Cmd>lua require('jdtls').extract_variable(true)<CR>",
  { desc = "JDTLS: Extract Variable (visual)" }
)
vim.keymap.set("n", "crc", "<Cmd>lua require('jdtls').extract_constant()<CR>", { desc = "JDTLS: Extract Constant" })
vim.keymap.set(
  "v",
  "crc",
  "<Esc><Cmd>lua require('jdtls').extract_constant(true)<CR>",
  { desc = "JDTLS: Extract Constant (visual)" }
)
vim.keymap.set(
  "v",
  "crm",
  "<Esc><Cmd>lua require('jdtls').extract_method(true)<CR>",
  { desc = "JDTLS: Extract Method (visual)" }
)

-- Java testing
vim.keymap.set("n", "<leader>df", "<Cmd>lua require'jdtls'.test_class()<CR>", { desc = "JDTLS: Test Class" })
vim.keymap.set(
  "n",
  "<leader>dn",
  "<Cmd>lua require'jdtls'.test_nearest_method()<CR>",
  { desc = "JDTLS: Test Nearest Method" }
)

-- Note: Gradle keymaps are in plugins.lua to avoid conflict with git mappings
-- Use <leader>mb/mr for Maven, dedicated Java build tool commands
