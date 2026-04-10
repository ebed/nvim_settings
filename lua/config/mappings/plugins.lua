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

-- ============================================================================
-- QUICK LAYOUTS (Hybrid Approach)
-- ============================================================================

-- Helper: Detectar si hay ventanas de terminal
local function has_terminal()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "terminal" then
      return true
    end
  end
  return false
end

-- Helper: Detectar si explorer está abierto
local function has_explorer()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.bo[buf].filetype
    if ft == "snacks_explorer" or ft == "oil" or ft == "neotree" then
      return true
    end
  end
  return false
end

-- Layout rápido #1: Dev básico (explorer + terminal flotante)
vim.keymap.set("n", "<leader>ld", function()
  -- Solo abrir explorer si no está abierto
  if not has_explorer() then
    Snacks.explorer()
    vim.defer_fn(function()
      vim.cmd("wincmd l")
    end, 50)
  end
  vim.notify("📂 Layout: Dev (explorer ready)", vim.log.levels.INFO)
end, { desc = "Layout: Dev (explorer)" })

-- Layout rápido #2: Solo código (limpia todo)
vim.keymap.set("n", "<leader>lc", function()
  vim.cmd("only")
  vim.notify("🎯 Layout: Clean (solo código)", vim.log.levels.INFO)
end, { desc = "Layout: Clean (solo código)" })

-- Layout rápido #3: Full (explorer + code + terminal abajo en CWD)
vim.keymap.set("n", "<leader>lf", function()
  -- Siempre resetear y crear layout desde cero para ser predecible

  -- 1. Cerrar todo excepto buffer actual
  vim.cmd("only")

  -- 2. Abrir explorer
  Snacks.explorer()

  vim.defer_fn(function()
    -- 3. Ir a la derecha (código)
    vim.cmd("wincmd l")

    -- 4. Split horizontal para terminal en CWD (raíz del proyecto)
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")
    vim.cmd("terminal")
    vim.cmd("startinsert")

    -- 5. Volver al buffer principal
    vim.defer_fn(function()
      vim.cmd("wincmd k")
    end, 100)
  end, 50)

  vim.notify("🚀 Layout: Full (terminal en CWD)", vim.log.levels.INFO)
end, { desc = "Layout: Full (explorer + terminal en CWD)" })

-- ============================================================================
-- TERMINAL CONTEXTUAL (fuera de layouts)
-- ============================================================================

-- Terminal contextual: Abre terminal en directorio del archivo actual
vim.keymap.set("n", "<leader>T", function()
  -- Obtener directorio del archivo actual
  local current_file = vim.api.nvim_buf_get_name(0)
  local file_dir = vim.fn.fnamemodify(current_file, ":h")

  -- Si no hay archivo (buffer vacío), usar CWD
  if current_file == "" or file_dir == "." then
    file_dir = vim.fn.getcwd()
  end

  -- Crear split horizontal para terminal
  vim.cmd("split")
  vim.cmd("wincmd j")
  vim.cmd("resize 15")

  -- Abrir terminal en el directorio del archivo
  vim.cmd("terminal")

  -- Cambiar al directorio del archivo dentro del terminal
  vim.defer_fn(function()
    vim.api.nvim_chan_send(vim.b.terminal_job_id, "cd " .. vim.fn.shellescape(file_dir) .. "\n")
    vim.cmd("startinsert")
  end, 100)

  vim.notify("📂 Terminal abierto en: " .. vim.fn.fnamemodify(file_dir, ":~"), vim.log.levels.INFO)
end, { desc = "Terminal: Abrir en directorio del archivo actual" })

-- Layout rápido #4: Review (explorer ancho + código)
vim.keymap.set("n", "<leader>lr", function()
  -- Solo abrir explorer si no está abierto
  if not has_explorer() then
    Snacks.explorer()
    vim.defer_fn(function()
      vim.cmd("wincmd l")
    end, 50)
  end
  vim.notify("📖 Layout: Review (explorer para navegación)", vim.log.levels.INFO)
end, { desc = "Layout: Review (explorer ancho)" })
