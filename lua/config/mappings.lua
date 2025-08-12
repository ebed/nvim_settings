-- telescope files
-- esto
local builtin = require("telescope.builtin")
local tele_args = require("telescope").extensions.live_grep_args
vim.api.nvim_set_keymap('n', '<leader>pr', ':lua require("config.copilotchat").agent_pr.create_pr()<CR>', {})

vim.keymap.set('n', '<leader>ff', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>", { desc = "Buscar archivos" })
vim.keymap.set("n", "<leader>fG", builtin.live_grep, { desc = "Buscar en el contenido" })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set("n", "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", { desc = "Buscar en el contenido" })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Search word'})
--tlelescope git
vim.keymap.set('n', '<leader>Gb', builtin.git_branches, { desc = 'Telescope Git Branches' })
vim.keymap.set('n', '<leader>Gc', builtin.git_commits, { desc = 'Telescope Git Commits' })
vim.keymap.set('n', '<leader>Gs', builtin.git_status, { desc = 'Telescope Git Status' })

-- telescope lsp
vim.keymap.set('n', '<leader>lr', builtin.lsp_references, { desc = 'Telescope LSP References' })
vim.keymap.set('n', '<leader>li', builtin.lsp_implementations, { desc = 'Telescope LSP Implementations' })
vim.keymap.set('n', '<leader>ld', builtin.lsp_definitions, { desc = 'Telescope LSP Definitions' })

vim.keymap.set('n', '<leader>fr<space>', function()
 require('telescope').extensions.frecency.frecency()
end, { desc = "Frecency file search" })

vim.keymap.set('n', '<leader>frw', function()
 require('telescope').extensions.frecency.frecency({ workspace = "web" })
end, { desc = "WEB: Frecency file search" })

vim.keymap.set('n', '<leader>frsc', function()
 require('telescope').extensions.frecency.frecency({ workspace = "schedule_compute" })
end, { desc = "Schedule Compute: Frecency file search" })

vim.keymap.set('n', '<leader>frsf', function()
 require('telescope').extensions.frecency.frecency({ workspace = "schedule_facade" })
end, { desc = "Schedule Facade: Frecency file search" })
-- vim.keymap.set("n", "<leader>fsa", function()
--   tele_args.live_grep_args({
--     search_dirs = { "apps" }
--   })
-- end, { desc = "Live grep in apps/" })

vim.keymap.set("n", "<leader>fst", function()
  local test_dirs = vim.fn.glob("**/test", true, true)
  require("telescope").extensions.live_grep_args.live_grep_args({
    search_dirs = test_dirs 
  })
end, { desc = "Live grep in test folder" })
-- Mapping para excluir test, deps, _build, .git

vim.keymap.set("n", "<leader>fsa", function()
  -- Clone the base arguments from global
  local args = vim.deepcopy(_G.base_vimgrep_args)
  -- Add extra globs
  vim.list_extend(args, {
    "--glob", "!test/**",
    "--glob", "!**/test/**",
    "--glob", "!deps/**",
    "--glob", "!**/deps/**",
    "--glob", "!_build/**",
    "--glob", "!**/_build/**",
    "--glob", "!.git/**",
    "--glob", "!**/.git/**",
    "--glob", "!infra**",
    "--glob", "!**/mix.exs",
    "--glob", "!**/mix.lock",

  })
  require("telescope").extensions.live_grep_args.live_grep_args({
    vimgrep_arguments = args
  })
end, { desc = "Live grep excluding common dirs" })
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

-- -- CopilotChat
--
--
--

local copilotchat = require("CopilotChat")

vim.keymap.set("n", "<leader>CC", ":CopilotChatToggle<cr>", { desc = "Copilot Chat" })
vim.keymap.set("n", "<leader>CP", ":CopilotChatPrompt<cr>", { desc = "Copilot Chat Prompts" })
vim.keymap.set("n", "<leader>Ce", ":CopilotChatExplain<CR>", { desc = "CopilotChat: Explain" })
vim.keymap.set("n", "<leader>Ct", ":CopilotChatTests<CR>", { desc = "CopilotChat: Tests" })
vim.keymap.set("n", "<leader>Cr", ":CopilotChatReview<CR>", { desc = "CopilotChat: Review" })
vim.keymap.set("n", "<leader>Cf", ":CopilotChatFix<CR>", { desc = "CopilotChat: Fix" })
vim.keymap.set("n", "<leader>Co", ":CopilotChatOptimize<CR>", { desc = "CopilotChat: Optimize" })
vim.keymap.set("n", "<leader>Cd", ":CopilotChatDocs<CR>", { desc = "CopilotChat: Docs" })
vim.keymap.set("n", "<leader>Cb", ":CopilotChatDebugging<CR>", { desc = "CopilotChat: Debugging" })
vim.keymap.set("n", "<leader>Cv", ":CopilotChatReviewBranch<CR>", { desc = "CopilotChat: Review Branch" })
vim.keymap.set("n", "<leader>Ca", ":CopilotChatRefactoring<CR>", { desc = "CopilotChat: Refactoring" })
vim.keymap.set("n", "<leader>Cp", ":CopilotChatPRDescription<CR>", { desc = "CopilotChat: PR Description" })
vim.keymap.set("n", "<leader>Cc", ":CopilotChatProjectContext<CR>", { desc = "CopilotChat: Project Context" })

-- vim.keymap.set("n", "<leader>ct", ":CopilotChatToggle<CR>", { desc = "Copilot Chat Toggle" })
-- vim.keymap.set({"n","v"}, '<leader>cct', ":CopilotChatTests<CR>", { desc = "Copilot Chat tests"})
-- vim.keymap.set({"n","v"}, '<leader>ccc', ":CopilotChatCommit<CR>", { desc = "Copilot Chat commit"})
-- vim.keymap.set({"n","v"}, '<leader>cce', ":CopilotChatExplain<CR>", { desc = "Copilot Chat Explain"})
-- vim.keymap.set({"n","v"}, '<leader>ccf', ":CopilotChatFix<CR>", { desc = "Copilot Chat Fix"})
--
-- Data viewer
vim.keymap.set("n", "<leader>dv", ":DataViewer<CR>", { desc = "Data Viewer Open" })
vim.keymap.set("n", "<leader>dV", ":DataViewerClose<CR>", { desc = "Data Viewer Close" })

-- Rest
--
vim.keymap.set("n", "<leader>R", ":Rest run<CR>", { desc = "Run rest" })
vim.keymap.set("n", "<leader>ro", ":Rest open<CR>", { desc = "Open rest results" })

vim.keymap.set("n", "<leader>rl", ":Rest logs<CR>", { desc = "Rest logs" })
vim.keymap.set("n", "<leader>rc", ":Rest cookies<CR>", { desc = "Rest cookiees" })
vim.keymap.set("n", "<leader>re", ":Rest env<CR>", { desc = "Rest show env file" })



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

-- LSP FORMAT
vim.keymap.set('n', '<leader>fc', vim.lsp.buf.format, {desc = 'Format code'})

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


-- LSP Elixir
vim.keymap.set('n', '<leader>ete', function()
    vim.lsp.codelens.run()
end, { desc = 'Run Elixir Test' })

vim.keymap.set('n', '<leader>eop', function()
  require("elixir.elixirls").open_output_panel()
end, { desc = 'Open Elixir Output Panel' })




-- DB
vim.keymap.set('n', '<leader>Dt', ":DBUIToggle<CR>", { desc = 'DB UI' })


-- HOP
--
local hop = require('hop')
local directions = require('hop.hint').HintDirection
vim.keymap.set('', 'f', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 'F', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, {remap=true})
vim.keymap.set('', 't', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, {remap=true})
vim.keymap.set('', 'T', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, {remap=true})


vim.keymap.set('n','<leader>hw', ':HopWord<CR>', { desc = 'Hop word' })
vim.keymap.set('n','<leader>hc', ':HopChar1<CR>', { desc = 'Hop char' })
vim.keymap.set('n','<leader>hC', ':HopChar2<CR>', { desc = 'Hop char 2' })
vim.keymap.set('n','<leader>h/', ':HopPattern<CR>', { desc = 'Hop Pattern' })
vim.keymap.set('n','<leader>hl', ':HopLine<CR>', { desc = 'Hop Line' })
vim.keymap.set('n','<leader>hL', ':HopLineStart<CR>', { desc = 'Hop Line start' })
vim.keymap.set('n','<leader>ha', ':HopAnywhere<CR>', { desc = 'Hop Anywere' })
vim.keymap.set('n','<leader>hm', ':Hop*MW<CR>', { desc = 'Hop Multi windows' })


vim.keymap.set('n','<leader>q',':q<CR>', { desc = 'Quit' })
vim.keymap.set('n','<leader>Q',':q!<CR>', { desc = 'Force Quit' })


-- vim.keymap.set("n", "<leader>m", "<cmd>MarksList<cr>", { desc = "Marks List" })
-- vim.keymap.set("n", "<leader>ml", "<cmd>MarksListBuf<cr>", { desc = "Marks List Buffer" })
-- vim.keymap.set("n", "<leader>mc", "<cmd>MarksClear<cr>", { desc = "Clear Marks" })

-- -- Resolve conflict for <m> mappings
-- vim.keymap.set('n', '<m>', '<cmd>MarksSet<CR>', { desc = 'Set mark' })
-- vim.keymap.set('n', '<m-s>', '<cmd>MarksSetBookmark<CR>', { desc = 'Set bookmark' }) -- Example reassignment
-- vim.keymap.del('n', '<m2>') -- Remove unnecessary mapping if not needed

-- Resolve conflict for <dm> mappings
-- vim.keymap.set('n', '<dm>', '<cmd>MarksDelete<CR>', { desc = 'Delete mark' })
-- vim.keymap.set('n', '<dm-d>', '<cmd>MarksDeleteLine<CR>', { desc = 'Delete line' }) -- Example reassignment

vim.keymap.set('n', '<leader>Mb', '<cmd>MarksListBuf<CR>', { desc = 'Marks List Buffer' })
vim.keymap.set('n', '<leader>Mt', '<cmd>MarksToggleSigns<CR>', { desc = 'Toggle Marks Signs All' })
vim.keymap.set('n', '<leader>Ms', function()
  local bufnr = vim.api.nvim_get_current_buf()
  vim.cmd('MarksToggleSigns ' .. bufnr)
end, { desc = 'Toggle Marks Signs for Current Buffer' })
vim.keymap.set('n', '<leader>Ml', '<cmd>MarksListAll<CR>', { desc = 'Marks List All' })
vim.keymap.set('n', '<leader>MB', '<cmd>BookmarksListAll<CR>', { desc = 'Bookmarks list all' })
vim.keymap.set('n', '<leader>MB0', '<cmd>BookmarksList 0<CR>', { desc = 'Bookmarks list group 0' })
vim.keymap.set('n', '<leader>MB1', '<cmd>BookmarksList 1<CR>', { desc = 'Bookmarks list group 1' })
vim.keymap.set('n', '<leader>MB2', '<cmd>BookmarksList 2<CR>', { desc = 'Bookmarks list group 2' })
vim.keymap.set('n', '<leader>MB3', '<cmd>BookmarksList 3<CR>', { desc = 'Bookmarks list group 3' })
vim.keymap.set('n', '<leader>MB4', '<cmd>BookmarksList 4<CR>', { desc = 'Bookmarks list group 4' })
vim.keymap.set('n', '<leader>MB4', '<cmd>BookmarksList 5<CR>', { desc = 'Bookmarks list group 5' })
vim.keymap.set('n', '<leader>MB4', '<cmd>BookmarksList 6<CR>', { desc = 'Bookmarks list group 6' })


-- Resolve conflict for <gr> mappings
vim.keymap.set('n', '<gr>', '<cmd>References<CR>', { desc = 'References' })
vim.keymap.set('n', '<gr-a>', vim.lsp.buf.code_action, { desc = 'Code action' }) -- Example reassignment

-- Resolve conflict for <Space> mappings
vim.keymap.set('n', '<C><Space>n', '<cmd>NotificationHistory<CR>', { desc = 'Notification History' })
vim.keymap.set('n', '<C><Space>Nt', '<cmd>NeoTree<CR>', { desc = 'NeoTree' }) -- Example reassignment



-- basic keymaps

vim.keymap.set('n', '<leader>w', ':w<CR>', { desc = 'Save' }) -- Example reassignment



-- toggle term
vim.api.nvim_set_keymap("n", "<leader>mb", "<cmd>lua _MAVEN_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>mr", "<cmd>lua _MAVEN_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>lua _GRADLE_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>gr", "<cmd>lua _GRADLE_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>et", "<cmd>lua _ELIXIR_MIX_TOGGLE()<CR>", { noremap = true, silent = true })

vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Quit' }) -- Example reassignment


vim.keymap.set("n", '<leader>mdp', '<cmd>MarkdownPreviewToggle<CR>', {desc = 'MD preview'} )



vim.keymap.set('v', '<leader>cd', function()
  require('config.copilotchat.dot').create_dot_from_selection()
end, { desc = "Crear archivo DOT desde selección" })

