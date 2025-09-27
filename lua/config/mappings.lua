-- Keymaps configuration for Neovim
-- All mappings use vim.keymap.set for consistency and modern options.
-- Groups are clearly documented for maintainability.

local opts = { noremap = true, silent = true }

vim.keymap.set({'n', 'v', 's', 'o', 'i', 'c'}, '<C-A>', '<Home>')
vim.keymap.set({'n', 'v', 's', 'o', 'i', 'c'}, '<C-E>', '<End>')
-- vim.api.nvim_set_keymap('n', '<CR>', [[:lua require('utils.neorg_utils').open_or_create_linked_file()<CR>]], { noremap = true, silent = true })
-- === General ===
vim.keymap.set("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit window" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<CR>", { desc = "Quit all (force)" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

-- === Buffer Navigation ===
vim.keymap.set("n", "<leader>bn", "<cmd>bn<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader>bp", "<cmd>bp<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })

-- === Window Management ===
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertical" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontal" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- === File Explorer (Neo-tree) ===
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<CR>", { desc = "Toggle Neo-tree" })

-- === Telescope: File and Content Search ===
vim.keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Help tags" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", require("telescope.builtin").grep_string, { desc = "Search word" })

-- === Git Integration ===
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>", { desc = "Open LazyGit" })
vim.keymap.set("n", "<leader>gb", "<cmd>Telescope git_branches<CR>", { desc = "Git branches" })
vim.keymap.set("n", "<leader>gc", "<cmd>Telescope git_commits<CR>", { desc = "Git commits" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_status<CR>", { desc = "Git status" })

-- === LSP Navigation and Actions ===
vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { desc = "Go to declaration" })
vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { desc = "Go to references" })
vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", { desc = "Hover documentation" })
vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
vim.keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { desc = "Code action" })
vim.keymap.set("n", "<leader>f", "<cmd>lua vim.lsp.buf.format({ async = true })<CR>", { desc = "Format buffer" })
vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<CR>", { desc = "List diagnostics" })

-- === DAP (Debug Adapter Protocol) ===
vim.keymap.set("n", "<F5>", "<cmd>lua require'dap'.continue()<CR>", { desc = "DAP Continue" })
vim.keymap.set("n", "<F10>", "<cmd>lua require'dap'.step_over()<CR>", { desc = "DAP Step Over" })
vim.keymap.set("n", "<F11>", "<cmd>lua require'dap'.step_into()<CR>", { desc = "DAP Step Into" })
vim.keymap.set("n", "<F12>", "<cmd>lua require'dap'.step_out()<CR>", { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<CR>", { desc = "DAP REPL" })

-- === CopilotChat & AI Assistants ===
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<CR>", { desc = "Toggle CopilotChat" })
vim.keymap.set("n", "<leader>cp", "<cmd>CopilotChatPrompt<CR>", { desc = "Prompt CopilotChat" })
vim.keymap.set("n", "<leader>cd", "<cmd>CopilotChatDoc<CR>", { desc = "Document with CopilotChat" })

-- === Snacks.nvim ===
vim.keymap.set("n", "<leader>sd", "<cmd>SnacksDashboard<CR>", { desc = "Snacks Dashboard" })
vim.keymap.set("n", "<leader>sp", "<cmd>SnacksPicker<CR>", { desc = "Snacks Picker" })
vim.keymap.set("n", "<leader>sn", "<cmd>SnacksNotify<CR>", { desc = "Snacks Notify" })
vim.keymap.set("n", "<leader>se", "<cmd>SnacksExplorer<CR>", { desc = "Snacks Explorer" })

-- === Bookmarks Groups ===
vim.keymap.set("n", "<leader>MB", "<cmd>BookmarksListAll<CR>", { desc = "Bookmarks list all" })
vim.keymap.set("n", "<leader>MB0", "<cmd>BookmarksList 0<CR>", { desc = "Bookmarks list group 0" })
vim.keymap.set("n", "<leader>MB1", "<cmd>BookmarksList 1<CR>", { desc = "Bookmarks list group 1" })
vim.keymap.set("n", "<leader>MB2", "<cmd>BookmarksList 2<CR>", { desc = "Bookmarks list group 2" })
vim.keymap.set("n", "<leader>MB3", "<cmd>BookmarksList 3<CR>", { desc = "Bookmarks list group 3" })
vim.keymap.set("n", "<leader>MB4", "<cmd>BookmarksList 4<CR>", { desc = "Bookmarks list group 4" })
vim.keymap.set("n", "<leader>MB5", "<cmd>BookmarksList 5<CR>", { desc = "Bookmarks list group 5" })
vim.keymap.set("n", "<leader>MB6", "<cmd>BookmarksList 6<CR>", { desc = "Bookmarks list group 6" })

-- === Terminal Build Tools (Maven, Gradle, Elixir) ===
vim.keymap.set("n", "<leader>mb", "<cmd>lua _MAVEN_BUILD_TOGGLE()<CR>", { desc = "Maven Build" })
vim.keymap.set("n", "<leader>mr", "<cmd>lua _MAVEN_RUN_TOGGLE()<CR>", { desc = "Maven Run" })
vim.keymap.set("n", "<leader>gb", "<cmd>lua _GRADLE_BUILD_TOGGLE()<CR>", { desc = "Gradle Build" })
vim.keymap.set("n", "<leader>gr", "<cmd>lua _GRADLE_RUN_TOGGLE()<CR>", { desc = "Gradle Run" })
vim.keymap.set("n", "<leader>et", "<cmd>lua _ELIXIR_MIX_TOGGLE()<CR>", { desc = "Elixir Mix" })

-- === Catppuccin Theme Switching ===
vim.keymap.set("n", "<leader>cl", function()
  require("catppuccin").setup({ flavour = "latte" })
  vim.cmd.colorscheme "catppuccin"
end, { desc = "Catppuccin Latte" })

vim.keymap.set("n", "<leader>cf", function()
  require("catppuccin").setup({ flavour = "frappe" })
  vim.cmd.colorscheme "catppuccin"
end, { desc = "Catppuccin Frappe" })

vim.keymap.set("n", "<leader>cm", function()
  require("catppuccin").setup({ flavour = "macchiato" })
  vim.cmd.colorscheme "catppuccin"
end, { desc = "Catppuccin Macchiato" })

vim.keymap.set("n", "<leader>co", function()
  require("catppuccin").setup({ flavour = "mocha" })
  vim.cmd.colorscheme "catppuccin"
end, { desc = "Catppuccin Mocha" })

-- === Markdown Preview ===
vim.keymap.set("n", "<leader>mp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle Markdown Preview" })

-- === Miscellaneous ===
vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>z", "<cmd>ZenMode<CR>", { desc = "Toggle Zen Mode" })

-- Add more mappings as needed, following the documented group structure above.

-- -- Keymaps configuration for Neovim
-- -- Organized by functionality: Telescope, LSP, DAP, Buffers, Git, CopilotChat, Java, Elixir, DB, Hop, Marks, Formatting, Terminal, Markdown, Data Viewer, etc.
--
-- local builtin = require("telescope.builtin")
-- local tele_args = require("telescope").extensions.live_grep_args
--
-- -- === Telescope: File and Content Search ===
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>ff",
-- 	"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
-- 	{ desc = "Find files" }
-- )
-- vim.keymap.set("n", "<leader>fG", builtin.live_grep, { desc = "Live grep" })
-- vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
-- vim.keymap.set(
-- 	"n",
-- 	"<leader>fg",
-- 	":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
-- 	{ desc = "Live grep with args" }
-- )
-- vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "Search word" })
--
-- -- Telescope: Git
-- vim.keymap.set("n", "<leader>Gb", builtin.git_branches, { desc = "Telescope Git Branches" })
-- vim.keymap.set("n", "<leader>Gc", builtin.git_commits, { desc = "Telescope Git Commits" })
-- vim.keymap.set("n", "<leader>Gs", builtin.git_status, { desc = "Telescope Git Status" })
--
-- -- === LSP Navigation and Actions ===
-- -- Direct LSP navigation
-- vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
-- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
-- vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
--
-- -- Telescope LSP navigation
-- vim.keymap.set("n", "<leader>ld", builtin.lsp_definitions, { desc = "Telescope LSP Definitions" })
-- vim.keymap.set("n", "<leader>li", builtin.lsp_implementations, { desc = "Telescope LSP Implementations" })
-- vim.keymap.set("n", "<leader>lr", builtin.lsp_references, { desc = "Telescope LSP References" })
--
-- -- Document symbols
-- vim.keymap.set("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
-- vim.keymap.set("n", "<leader>lS", builtin.lsp_document_symbols, { desc = "Telescope document symbols" })
--
-- -- LSP formatting
-- vim.keymap.set("n", "<leader>fc", function()
-- 	vim.lsp.buf.format({ async = true })
-- end, { desc = "Format buffer" })
--
-- -- LSP code actions (generic)
-- vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, { desc = "LSP code action" })
-- vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, { desc = "LSP rename" })
--
-- -- LSP jump list navigation
-- vim.keymap.set("n", "<leader>lb", "<C-o>", { desc = "Go back (jump list)" })
-- vim.keymap.set("n", "<leader>lf", "<C-i>", { desc = "Go forward (jump list)" })
--
-- -- === Telescope: Frecency and Workspaces ===
-- vim.keymap.set("n", "<leader>fr<space>", function()
-- 	require("telescope").extensions.frecency.frecency()
-- end, { desc = "Frecency file search" })
-- vim.keymap.set("n", "<leader>frw", function()
-- 	require("telescope").extensions.frecency.frecency({ workspace = "web" })
-- end, { desc = "WEB: Frecency file search" })
-- vim.keymap.set("n", "<leader>frsc", function()
-- 	require("telescope").extensions.frecency.frecency({ workspace = "schedule_compute" })
-- end, { desc = "Schedule Compute: Frecency file search" })
-- vim.keymap.set("n", "<leader>frsf", function()
-- 	require("telescope").extensions.frecency.frecency({ workspace = "schedule_facade" })
-- end, { desc = "Schedule Facade: Frecency file search" })
--
-- -- Live grep in test folder
-- vim.keymap.set("n", "<leader>fst", function()
-- 	local test_dirs = vim.fn.glob("**/test", true, true)
-- 	require("telescope").extensions.live_grep_args.live_grep_args({
-- 		search_dirs = test_dirs,
-- 	})
-- end, { desc = "Live grep in test folder" })
--
-- -- Live grep excluding common dirs
-- vim.keymap.set("n", "<leader>fsa", function()
-- 	local args = vim.deepcopy(_G.base_vimgrep_args)
-- 	vim.list_extend(args, {
-- 		"--glob",
-- 		"!test/**",
-- 		"--glob",
-- 		"!**/test/**",
-- 		"--glob",
-- 		"!deps/**",
-- 		"--glob",
-- 		"!**/deps/**",
-- 		"--glob",
-- 		"!_build/**",
-- 		"--glob",
-- 		"!**/_build/**",
-- 		"--glob",
-- 		"!.git/**",
-- 		"--glob",
-- 		"!**/.git/**",
-- 		"--glob",
-- 		"!infra**",
-- 		"--glob",
-- 		"!**/mix.exs",
-- 		"--glob",
-- 		"!**/mix.lock",
-- 	})
-- 	require("telescope").extensions.live_grep_args.live_grep_args({
-- 		vimgrep_arguments = args,
-- 	})
-- end, { desc = "Live grep excluding common dirs" })
--
-- -- === DAP (Debug Adapter Protocol) ===
-- vim.keymap.set("n", "<F6>", function()
-- 	require("dap").continue()
-- end, { desc = "Start/Continue Debug" })
-- vim.keymap.set("n", "<F10>", function()
-- 	require("dap").step_over()
-- end, { desc = "Step over" })
-- vim.keymap.set("n", "<F11>", function()
-- 	require("dap").step_into()
-- end, { desc = "Step into" })
-- vim.keymap.set("n", "<F12>", function()
-- 	require("dap").step_out()
-- end, { desc = "Step out" })
-- vim.keymap.set("n", "<leader>b", function()
-- 	require("dap").toggle_breakpoint()
-- end, { desc = "Toggle Breakpoint" })
-- vim.keymap.set("n", "<leader>B", function()
-- 	require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
-- end, { desc = "Set Conditional Breakpoint" })
--
-- -- === Buffer Navigation ===
-- vim.keymap.set("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
-- vim.keymap.set("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Previous Buffer" })
--
-- -- === Precognition ===
-- vim.keymap.set("n", "<leader>pt", ":Precognition toggle<CR>", { desc = "Precognition Toggle" })
-- vim.keymap.set("n", "<leader>pp", ":Precognition peek<CR>", { desc = "Precognition Peek" })
--
-- -- === NeoTree ===
-- vim.keymap.set("n", "<leader>nt", ":Neotree<CR>", { desc = "NeoTree" })
--
-- -- === CopilotChat ===
-- local copilotchat = require("CopilotChat")
-- vim.keymap.set("n", "<leader>CC", ":CopilotChatToggle<cr>", { desc = "Copilot Chat" })
-- vim.keymap.set("n", "<leader>CP", ":CopilotChatPrompt<cr>", { desc = "Copilot Chat Prompts" })
-- vim.keymap.set("n", "<leader>Ce", ":CopilotChatExplain<CR>", { desc = "CopilotChat: Explain" })
-- vim.keymap.set("n", "<leader>Ct", ":CopilotChatTests<CR>", { desc = "CopilotChat: Tests" })
-- vim.keymap.set("n", "<leader>Cr", ":CopilotChatReview<CR>", { desc = "CopilotChat: Review" })
-- vim.keymap.set("n", "<leader>Cf", ":CopilotChatFix<CR>", { desc = "CopilotChat: Fix" })
-- vim.keymap.set("n", "<leader>Co", ":CopilotChatOptimize<CR>", { desc = "CopilotChat: Optimize" })
-- vim.keymap.set("n", "<leader>Cd", ":CopilotChatDocs<CR>", { desc = "CopilotChat: Docs" })
-- vim.keymap.set("n", "<leader>Cb", ":CopilotChatDebugging<CR>", { desc = "CopilotChat: Debugging" })
-- vim.keymap.set("n", "<leader>Cv", ":CopilotChatReviewBranch<CR>", { desc = "CopilotChat: Review Branch" })
-- vim.keymap.set("n", "<leader>Ca", ":CopilotChatRefactoring<CR>", { desc = "CopilotChat: Refactoring" })
-- vim.keymap.set("n", "<leader>Cp", ":CopilotChatPRDescription<CR>", { desc = "CopilotChat: PR Description" })
-- vim.keymap.set("n", "<leader>Cc", ":CopilotChatProjectContext<CR>", { desc = "CopilotChat: Project Context" })
--
-- -- === Data Viewer ===
-- vim.keymap.set("n", "<leader>dv", ":DataViewer<CR>", { desc = "Data Viewer Open" })
-- vim.keymap.set("n", "<leader>dV", ":DataViewerClose<CR>", { desc = "Data Viewer Close" })
--
-- -- === REST Client ===
-- vim.keymap.set("n", "<leader>R", ":Rest run<CR>", { desc = "Run rest" })
-- vim.keymap.set("n", "<leader>ro", ":Rest open<CR>", { desc = "Open rest results" })
-- vim.keymap.set("n", "<leader>rl", ":Rest logs<CR>", { desc = "Rest logs" })
-- vim.keymap.set("n", "<leader>rc", ":Rest cookies<CR>", { desc = "Rest cookies" })
-- vim.keymap.set("n", "<leader>re", ":Rest env<CR>", { desc = "Rest show env file" })
--
-- -- === Java LSP Actions ===
-- vim.keymap.set("n", "<leader>jco", function()
-- 	vim.lsp.buf.code_action({
-- 		context = { only = { "source.organizeImports" } },
-- 		apply = true,
-- 	})
-- end, { desc = "Java: Organize Imports" })
-- vim.keymap.set("n", "<leader>jfa", function()
-- 	vim.lsp.buf.code_action({
-- 		context = { only = { "source.fixAll" } },
-- 		apply = true,
-- 	})
-- end, { desc = "Java: Fix all" })
-- vim.keymap.set("n", "<leader>jrr", ":JavaRunnerRunMain<CR>", { desc = "Java: Run Main" })
-- vim.keymap.set("n", "<leader>jrs", ":JavaRunnerStopMain<CR>", { desc = "Java: Stop Main" })
-- vim.keymap.set("n", "<leader>jrl", ":JavaRunnerSwitchLop<CR>", { desc = "Java: Switch Log" })
-- vim.keymap.set("n", "<leader>jrt", ":JavaRunnerToggleLogs<CR>", { desc = "Java: Toggle Logs" })
--
-- -- === Elixir LSP Actions ===
-- vim.keymap.set("n", "<leader>ete", function()
-- 	vim.lsp.codelens.run()
-- end, { desc = "Elixir: Run Test" })
-- vim.keymap.set("n", "<leader>eop", function()
-- 	require("elixir.elixirls").open_output_panel()
-- end, { desc = "Elixir: Open Output Panel" })
--
-- -- === Database UI ===
-- vim.keymap.set("n", "<leader>Dt", ":DBUIToggle<CR>", { desc = "DB UI" })
--
-- -- === Hop (Easy Motion) ===
-- local hop = require("hop")
-- local directions = require("hop.hint").HintDirection
-- vim.keymap.set("", "f", function()
-- 	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, { remap = true })
-- vim.keymap.set("", "F", function()
-- 	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, { remap = true })
-- vim.keymap.set("", "t", function()
-- 	hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, { remap = true })
-- vim.keymap.set("", "T", function()
-- 	hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, { remap = true })
--
-- vim.keymap.set("n", "<leader>hw", ":HopWord<CR>", { desc = "Hop word" })
-- vim.keymap.set("n", "<leader>hc", ":HopChar1<CR>", { desc = "Hop char" })
-- vim.keymap.set("n", "<leader>hC", ":HopChar2<CR>", { desc = "Hop char 2" })
-- vim.keymap.set("n", "<leader>h/", ":HopPattern<CR>", { desc = "Hop Pattern" })
-- vim.keymap.set("n", "<leader>hl", ":HopLine<CR>", { desc = "Hop Line" })
-- vim.keymap.set("n", "<leader>hL", ":HopLineStart<CR>", { desc = "Hop Line start" })
-- vim.keymap.set("n", "<leader>ha", ":HopAnywhere<CR>", { desc = "Hop Anywhere" })
-- vim.keymap.set("n", "<leader>hm", ":Hop*MW<CR>", { desc = "Hop Multi windows" })
--
-- -- === Marks and Bookmarks ===
-- vim.keymap.set("n", "<leader>Mb", "<cmd>MarksListBuf<CR>", { desc = "Marks List Buffer" })
-- vim.keymap.set("n", "<leader>Mt", "<cmd>MarksToggleSigns<CR>", { desc = "Toggle Marks Signs All" })
-- vim.keymap.set("n", "<leader>Ms", function()
-- 	local bufnr = vim.api.nvim_get_current_buf()
-- 	vim.cmd("MarksToggleSigns " .. bufnr)
-- end, { desc = "Toggle Marks Signs for Current Buffer" })
-- vim.keymap.set("n", "<leader>Ml", "<cmd>MarksListAll<CR>", { desc = "Marks List All" })
-- vim.keymap.set("n", "<leader>MB", "<cmd>BookmarksListAll<CR>", { desc = "Bookmarks list all" })
-- vim.keymap.set("n", "<leader>MB0", "<cmd>BookmarksList 0<CR>", { desc = "Bookmarks list group 0" })
-- vim.keymap.set("n", "<leader>MB1", "<cmd>BookmarksList 1<CR>", { desc = "Bookmarks list group 1" })
-- vim.keymap.set("n", "<leader>MB2", "<cmd>BookmarksList 2<CR>", { desc = "Bookmarks list group 2" })
-- vim.keymap.set("n", "<leader>MB3", "<cmd>BookmarksList 3<CR>", { desc = "Bookmarks list group 3" })
-- vim.keymap.set("n", "<leader>MB4", "<cmd>BookmarksList 4<CR>", { desc = "Bookmarks list group 4" })
-- vim.keymap.set("n", "<leader>MB4", "<cmd>BookmarksList 5<CR>", { desc = "Bookmarks list group 5" })
-- vim.keymap.set("n", "<leader>MB4", "<cmd>BookmarksList 6<CR>", { desc = "Bookmarks list group 6" })
--
-- -- === Quick Quit and Save ===
-- vim.keymap.set("n", "<leader>q", ":q<CR>", { desc = "Quit" })
-- vim.keymap.set("n", "<leader>Q", ":q!<CR>", { desc = "Force Quit" })
-- vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save" })
--
-- -- === Terminal and Build Tools ===
-- vim.api.nvim_set_keymap("n", "<leader>mb", "<cmd>lua _MAVEN_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>mr", "<cmd>lua _MAVEN_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>lua _GRADLE_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gr", "<cmd>lua _GRADLE_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>et", "<cmd>lua _ELIXIR_MIX_TOGGLE()<CR>", { noremap = true, silent = true })
--
-- -- === Markdown Preview ===
-- vim.keymap.set("n", "<leader>mdp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Markdown preview" })
--
-- -- === DOT File Generation from Selection ===
-- vim.keymap.set("v", "<leader>cd", function()
-- 	require("config.copilotchat.dot").create_dot_from_selection()
-- end, { desc = "Create DOT file from selection" })
--
-- -- === Java JDTLS Extra Actions ===
-- local opts = { noremap = true, silent = true, buffer = true }
-- vim.keymap.set("n", "<leader>joi", "<Cmd>lua require'jdtls'.organize_imports()<CR>", opts)
-- vim.keymap.set("n", "<leader>jev", "<Cmd>lua require'jdtls'.extract_variable()<CR>", opts)
-- vim.keymap.set("v", "<leader>jem", "<Esc><Cmd>lua require'jdtls'.extract_method(true)<CR>", opts)
-- vim.keymap.set("n", "<leader>jtc", "<Cmd>lua require'jdtls'.test_class()<CR>", opts)
-- vim.keymap.set("n", "<leader>jtm", "<Cmd>lua require'jdtls'.test_nearest_method()<CR>", opts)
-- vim.keymap.set("n", "<leader>jjc", "<Cmd>lua require'jdtls'.compile()<CR>", opts)
-- vim.keymap.set("n", "<leader>jjs", "<Cmd>lua require'jdtls'.jshell()<CR>", opts)
-- vim.keymap.set("n", "<leader>jrv", "<Cmd>lua require'jdtls'.refactor_inline_variable()<CR>", opts)
-- vim.keymap.set("n", "<leader>jcu", "<Cmd>lua require'jdtls'.update_project_config()<CR>", opts)
-- vim.keymap.set("n", "<leader>jgs", "<Cmd>lua require'jdtls'.goto_super_implementation()<CR>", opts)
-- vim.keymap.set("n", "<leader>jsi", "<Cmd>lua require'jdtls'.super_implementation()<CR>", opts)
-- vim.keymap.set("n", "<leader>jcc", "<Cmd>lua require'jdtls'.code_action()<CR>", opts)
--
-- -- === VGit: Git Hunk and Diff Navigation (no conflicts) ===
-- vim.keymap.set("n", "<C-k>", function()
-- 	require("vgit").hunk_up()
-- end, { desc = "VGit: Hunk up" })
-- vim.keymap.set("n", "<C-j>", function()
-- 	require("vgit").hunk_down()
-- end, { desc = "VGit: Hunk down" })
--
-- vim.keymap.set("n", "<leader>vgs", function()
-- 	require("vgit").buffer_hunk_stage()
-- end, { desc = "VGit: Stage hunk" })
-- vim.keymap.set("n", "<leader>vgr", function()
-- 	require("vgit").buffer_hunk_reset()
-- end, { desc = "VGit: Reset hunk" })
-- vim.keymap.set("n", "<leader>vgp", function()
-- 	require("vgit").buffer_hunk_preview()
-- end, { desc = "VGit: Preview hunk" })
-- vim.keymap.set("n", "<leader>vgb", function()
-- 	require("vgit").buffer_blame_preview()
-- end, { desc = "VGit: Blame preview" })
-- vim.keymap.set("n", "<leader>vgf", function()
-- 	require("vgit").buffer_diff_preview()
-- end, { desc = "VGit: Buffer diff preview" })
-- vim.keymap.set("n", "<leader>vgh", function()
-- 	require("vgit").buffer_history_preview()
-- end, { desc = "VGit: Buffer history preview" })
-- vim.keymap.set("n", "<leader>vgu", function()
-- 	require("vgit").buffer_reset()
-- end, { desc = "VGit: Buffer reset" })
-- vim.keymap.set("n", "<leader>vgd", function()
-- 	require("vgit").project_diff_preview()
-- end, { desc = "VGit: Project diff preview" })
-- vim.keymap.set("n", "<leader>vgx", function()
-- 	require("vgit").toggle_diff_preference()
-- end, { desc = "VGit: Toggle diff preference" })
--
-- vim.keymap.set("n", "<space>Efp", ":ElixirFromPipe<cr>", { buffer = bufnr, noremap = true })
-- vim.keymap.set("n", "<space>Etp", ":ElixirToPipe<cr>", { buffer = bufnr, noremap = true })
-- vim.keymap.set("v", "<space>Eem", ":ElixirExpandMacro<cr>", { buffer = bufnr, noremap = true })
--
-- vim.keymap.set("n", "<leader>kc", ":KafkaConsume<CR>", { silent = true, desc = "Consume Kafka Topic" })
--
-- vim.keymap.set("n", "lgd", vim.lsp.buf.definition, opts)
-- vim.keymap.set("n", "lgD", vim.lsp.buf.declaration, opts)
-- vim.keymap.set("n", "lK", vim.lsp.buf.hover, opts)
-- vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
-- vim.keymap.set("n", "<leader>lca", vim.lsp.buf.code_action, opts)
-- vim.keymap.set("n", "<leader>lfm", function()
-- 	vim.lsp.buf.format({ async = true })
-- end, opts)
--
-- vim.keymap.set("n", "<leader>A<space>", function()
-- 	harpoon:list():add()
-- end)
-- vim.keymap.set("n", "<C-e>", function()
-- 	harpoon.ui:toggle_quick_menu(harpoon:list())
-- end)
--
-- vim.keymap.set("n", "<C-h>", function()
-- 	harpoon:list():select(1)
-- end)
-- vim.keymap.set("n", "<C-t>", function()
-- 	harpoon:list():select(2)
-- end)
-- vim.keymap.set("n", "<C-n>", function()
-- 	harpoon:list():select(3)
-- end)
-- vim.keymap.set("n", "<C-s>", function()
-- 	harpoon:list():select(4)
-- end)
--
-- -- Toggle previous & next buffers stored within Harpoon list
-- vim.keymap.set("n", "<C-S-P>", function()
-- 	harpoon:list():prev()
-- end)
-- vim.keymap.set("n", "<C-S-N>", function()
-- 	harpoon:list():next()
-- end)
--
-- vim.api.nvim_create_autocmd("FileType", {
-- 	pattern = "http",
-- 	callback = function()
-- 		-- Ejecutar petición y abrir resultados en split vertical (derecha)
-- 		vim.keymap.set("n", "<leader>re", ":vert Rest run<CR>", { buffer = true, desc = "Execute request" })
-- 		-- Previsualizar petición
-- 		vim.keymap.set("n", "<leader>rp", ":Rest curl yank<CR>", { buffer = true, desc = "Preview request" })
-- 		-- Re-ejecutar última petición en split vertical (derecha)
-- 		vim.keymap.set("n", "<leader>rl", ":vert Rest last<CR>", { buffer = true, desc = "Re-run last request" })
-- 	end,
-- })
--
-- vim.api.nvim_set_keymap("n", "<leader>mb", "<cmd>lua _MAVEN_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>mr", "<cmd>lua _MAVEN_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gb", "<cmd>lua _GRADLE_BUILD_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>gr", "<cmd>lua _GRADLE_RUN_TOGGLE()<CR>", { noremap = true, silent = true })
-- vim.api.nvim_set_keymap("n", "<leader>et", "<cmd>lua _ELIXIR_MIX_TOGGLE()<CR>", { noremap = true, silent = true })
--
-- -- Keymaps for switching flavours
-- vim.keymap.set("n", "<leader>cl", function()
-- 	require("catppuccin").setup({ flavour = "latte" })
-- 	vim.cmd.colorscheme("catppuccin")
-- end, { desc = "Catppuccin Latte" })
--
-- vim.keymap.set("n", "<leader>cf", function()
-- 	require("catppuccin").setup({ flavour = "frappe" })
-- 	vim.cmd.colorscheme("catppuccin")
-- end, { desc = "Catppuccin Frappe" })
--
-- vim.keymap.set("n", "<leader>cm", function()
-- 	require("catppuccin").setup({ flavour = "macchiato" })
-- 	vim.cmd.colorscheme("catppuccin")
-- end, { desc = "Catppuccin Macchiato" })
--
-- vim.keymap.set("n", "<leader>co", function()
-- 	require("catppuccin").setup({ flavour = "mocha" })
-- 	vim.cmd.colorscheme("catppuccin")
-- end, { desc = "Catppuccin Mocha" })
