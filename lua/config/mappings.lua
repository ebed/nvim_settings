-- telescope files
local builtin = require("telescope.builtin")
vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", { desc = "Buscar archivos" })
-- vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Buscar en el contenido" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Buscar en el contenido" })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Search word'})
--tlelescope git
vim.keymap.set('n', '<leader>gb', builtin.git_branches, { desc = 'Telescope Git Branches' })
vim.keymap.set('n', '<leader>gc', builtin.git_commits, { desc = 'Telescope Git Commits' })
vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = 'Telescope Git Status' })

-- telescope lsp
vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Telescope LSP References' })
vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, { desc = 'Telescope LSP Implementations' })
vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = 'Telescope LSP Definitions' })

-- Ejemplo de mapeos para debugging
vim.keymap.set("n", "<F6>", function() require("dap").continue() end, { desc = "Iniciar/Continuar Debug" })
vim.keymap.set("n", "<F10>", function() require("dap").step_over() end, { desc = "Step over" })
vim.keymap.set("n", "<F11>", function() require("dap").step_into() end, { desc = "Step into" })
vim.keymap.set("n", "<F12>", function() require("dap").step_out() end, { desc = "Step out" })
vim.keymap.set("n", "<leader>b", function() require("dap").toggle_breakpoint() end, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, { desc = "Set Conditional Breakpoint" })


-- Navegar entre buffers con <Tab> y <S-Tab>, por ejemplo:
vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Siguiente Buffer" })
vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Buffer Anterior" })

-- precognition
vim.keymap.set("n", "<leader>pt", ":Precognition toggle<CR>", { desc = "Precognition Toggle" })
vim.keymap.set("n", "<leader>pp", ":Precognition peek<CR>", { desc = "Precognition Toggle" })

-- NeoTree
vim.keymap.set("n", "<leader>nt", ":Neotree<CR>", { desc = "NeoTree" })

-- Neogit
-- vim.keymap.set("n", "<leader>lg", ":LazyGit<CR>", { desc = "Lazygit" })

-- CopilotChat

vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>", { desc = "Copilot Chat Toggle" })

-- Data viewer
vim.keymap.set("n", "<leader>dv", ":DataViewer<CR>", { desc = "Data Viewer Open" })
vim.keymap.set("n", "<leader>dV", ":DataViewerClose<CR>", { desc = "Data Viewer Close" })


-- Rest
--
vim.keymap.set("n", "<leader>Rr", ":Rest run<CR>", { desc = "Run rest" })
vim.keymap.set("n", "<leader>Ro", ":Rest open<CR>", { desc = "Open rest results" })

vim.keymap.set("n", "<leader>Rl", ":Rest logs<CR>", { desc = "Rest logs" })
vim.keymap.set("n", "<leader>Rc", ":Rest cookies<CR>", { desc = "Rest cookiees" })
vim.keymap.set("n", "<leader>Re", ":Rest env<CR>", { desc = "Rest show env file" })



-- local kaf_telescope = require("kaf.integrations.telescope")
--
-- vim.keymap.set('n', '<Leader>kc', function() kaf_telescope.clients() end, { desc = "List clients entries" })
--
-- vim.keymap.set('n', '<Leader>kt', function() kaf_telescope.topics() end, { desc = "List topics from selected client" })
--
-- vim.keymap.set('n', '<Leader>km', function() kaf_telescope.messages() end, { desc = "List messages from seleted topic and client" })
--
-- vim.keymap.set('n', '<Leader>kp', function()
--     require('kaf.api').produce({ value_from_buffer = true, })
-- end, { desc = "Produce a message into selected topic and client" })
--
--

-- LSP JAva
vim.keymap.set('n', '<leader>jco', function()
  vim.lsp.buf.code_action({
    context = { only = { 'source.organizeImports' } },
    apply = true,
  })
end, { desc = 'Organize Imports' })

vim.keymap.set('n', '<leader>jfa', function()
  vim.lsp.buf.code_action({
	context = { only = { 'source.fixAll' } },
	apply = true,
  })
end, { desc = 'Fix all' })

vim.keymap.set('n', '<leader>jrr', ":JavaRunnerRunMain<CR>", { desc = 'Run Java Main' })
vim.keymap.set('n', '<leader>jrs', ":JavaRunnerStopMain<CR>", { desc = 'Stops Java Main' })
vim.keymap.set('n', '<leader>jrl', ":JavaRunnerSwitchLop<CR>", { desc = 'Switch Log Java' })
vim.keymap.set('n', '<leader>jrt', ":JavaRunnerToggleLogs<CR>", { desc = 'Toggle Log Java' })
