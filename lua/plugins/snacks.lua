return {
  "folke/snacks.nvim",
  enabled = true, -- Re-enabled with minimal config to find problematic module
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {

widgets = {
      enabled = true  -- ✅ GRUPO 4: Enabled
},
    bigfile = { enabled = true },  -- ✅ GRUPO 1: Enabled
    lazygit = {
      enabled = true,  -- ✅ Git TUI integration
      configure = true,  -- Use snacks config
    },
    dashboard = {
      enabled = true,  -- ✅ GRUPO 4: Enabled
  formats = {
    key = function(item)
      return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
    end,
  },
  sections = {
    { title = "Recent Files", padding = 1 },
    { section = "recent_files", limit = 8, padding = 1 },
    { title = "Projects", padding = 1 },
    { section = "projects", limit = 8, padding = 1 },
    { title = "Keymaps", padding = 1 },
    { section = "keys", padding = 1 },
  },
},
    explorer = {
      enabled = true,  -- ✅ File explorer sidebar (replaces neotree)
      replace_netrw = false,  -- Keep oil.nvim for netrw (they complement each other)
    },
    indent = { enabled = false },  -- ❌ CULPRIT: Causes crash with lua files
    input = {
      enabled = true,  -- ✅ GRUPO 3: Enabled
      -- Mejora la visualización de input/prompts
      border = "rounded",
    },
    notifier = {
      enabled = true,  -- ✅ GRUPO 3: Enabled
      timeout = 3000,
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
      level = vim.log.levels.INFO,  -- Changed from TRACE to INFO (less noise)
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = " ",
      },
      style = "compact",
    },
    picker = { enabled = true,  -- ✅ GRUPO 3: Enabled
    sources = {
        explorer = {
          -- your explorer picker configuration comes here
          -- or leave it empty to use the default settings
        }
      }
    },
    quickfile = { enabled = true },  -- ✅ GRUPO 1: Enabled
    scope = { enabled = true },  -- 🧪 TESTING: scope + statuscolumn
    scroll = { enabled = true },  -- ✅ GRUPO 1: Enabled
    statuscolumn = { enabled = true },  -- 🧪 TESTING: scope + statuscolumn
    words = { enabled = true },  -- ✅ GRUPO 1: Enabled
    terminal = {
      enabled = true,  -- ✅ GRUPO 4: Enabled
      win = {
        position = "float",
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
    scratch = {
      enabled = true,  -- ✅ GRUPO 4: Enabled
      win = {
        border = "rounded",
        width = 0.8,
        height = 0.8,
      },
    },
    zen = {
      enabled = false,  -- ❌ Disabled: causing window errors with nvim_open_win
      -- Error: Invalid 'win': Expected Lua number
      -- TODO: Debug or use alternative zen mode plugin
      toggles = {
        dim = true,
        git_signs = false,
        mini_diff_signs = false,
      },
      zoom = {
        toggles = {},
      },
    },
    styles = {
      blame_line = {
        width = 0.6,
        height = 0.6,
        border = "rounded",
        title = " Git Blame ",
        title_pos = "center",
        ft = "git",
      },
      notification = {
        wo = { wrap = true },
        border = "rounded",
      },
      notification_history = {
        border = "rounded",
        zindex = 100,
      },
      input = {
        border = "rounded",
        title_pos = "center",
        relative = "editor",
        row = "50%",
        col = "50%",
      },
      scratch = {
        border = "rounded",
        title = " Scratch Buffer ",
        title_pos = "center",
        ft = "markdown",
      },
      terminal = {
        border = "rounded",
        title = " Terminal ",
        title_pos = "center",
      },
      zen = {
        backdrop = {
          transparent = false,
          blend = 80,
        },
        win = {
          width = 120,  -- Fixed width in columns instead of percentage
          height = 0.9, -- 90% of screen height
        },
      },
    }
  },
  keys = {
    -- Top Pickers & Explorer
    { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
    { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer (Snacks)" },
    { "<leader>E", function()
      -- Open Oil in current file's directory
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir = vim.fn.fnamemodify(current_file, ":h")
      require("oil").open(current_dir)
    end, desc = "Open Oil in current directory" },
    -- find
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent" },
    -- git
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
    { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
    { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
    { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
    { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
    { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
    -- Grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
    { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
    -- search
    { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
    { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
    { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
    { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
    { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
    { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
    { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
    { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
    { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
    -- LSP
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
    { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
    { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
    -- Other
    -- { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },  -- Disabled: zen causing errors
    { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    { "<leader>n",  function() Snacks.notifier.show_history() end, desc = "Notification History" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
    { "<leader>cR", function() Snacks.rename.rename_file() end, desc = "Rename File" },
    { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
    { "<c-/>",      function() Snacks.terminal() end, desc = "Toggle Terminal" },
    { "<c-_>",      function() Snacks.terminal() end, desc = "which_key_ignore" },
    { "]]",         function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference", mode = { "n", "t" } },
    { "[[",         function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference", mode = { "n", "t" } },
    {
      "<leader>N",
      desc = "Neovim News",
      function()
        Snacks.win({
          file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
          width = 0.6,
          height = 0.6,
          wo = {
            spell = false,
            wrap = false,
            signcolumn = "yes",
            statuscolumn = " ",
            conceallevel = 3,
          },
        })
      end,
    }
  },
  init = function()
    -- ✅ GRUPO 5: Full init restored
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        -- Snacks.toggle.indent():map("<leader>ug")  -- ❌ Disabled: indent causes crashes
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })

    -- LSP Progress Integration - Heavily Filtered
    -- Only show final completion messages, suppress all intermediate progress
    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value
        if not client or type(value) ~= "table" then
          return
        end

        -- Suppress ALL progress messages for noisy servers
        if client.name == "jdtls" or client.name == "lua_ls" or client.name == "rust_analyzer" then
          -- Only show final completion for these noisy servers
          if value.kind ~= "end" then
            return
          end

          -- And only if it's a significant operation
          if not value.title or value.title == "" then
            return
          end
        end

        -- For all servers: only show "end" messages (completion)
        -- Suppress "begin" and "report" (progress updates)
        if value.kind ~= "end" then
          return
        end

        -- Don't show messages with just numbers (e.g., "4732/4732")
        if value.message and value.message:match("^%d+/%d+$") then
          return
        end

        -- Build descriptive message
        local title = client.name
        local message = value.message or "Complete"

        -- If message is generic "Complete", enhance it with title
        if message == "Complete" and value.title and value.title ~= "" then
          message = value.title .. " completed"
        end

        -- Add title to notification title for context
        if value.title and value.title ~= "" then
          title = title .. " - " .. value.title
        end

        -- Don't show if still too generic after enhancement
        if message == "Complete" and (not value.title or value.title == "") then
          return
        end

        -- Show completion notification with short timeout
        Snacks.notifier.notify(message, {
          id = "lsp_progress_" .. client.id,
          title = title,
          level = "info",
          timeout = 2000,  -- 2 seconds
        })
      end,
    })

    -- Override vim.notify to use Snacks with filtering
    vim.notify = function(msg, level, opts)
      -- Filter out noisy messages
      if msg and type(msg) == "string" then
        -- Suppress "No results" messages from pickers
        if msg:match("No results found") then
          return
        end
        -- Suppress "Command failed" from git operations (usually harmless)
        if msg:match("Command failed:") and msg:match("git") then
          return
        end
        -- Suppress "Opening" messages from gitbrowse
        if msg:match("^Opening %[") then
          return
        end
      end

      Snacks.notifier.notify(msg, vim.tbl_extend("force", {
        level = level or vim.log.levels.INFO,
      }, opts or {}))
    end
  end,
}
