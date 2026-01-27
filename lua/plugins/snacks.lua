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
    dashboard = {
      enabled = true,  -- ✅ GRUPO 4: Enabled
  formats = {
    key = function(item)
      return { { "[", hl = "special" }, { item.key, hl = "key" }, { "]", hl = "special" } }
    end,
  },
  sections = {
    { section = "terminal", cmd = "fortune -s | cowsay", hl = "header", padding = 1, indent = 8 },
    { title = "MRU", padding = 1 },
    { section = "recent_files", limit = 8, padding = 1 },
    { title = "MRU ", file = vim.fn.fnamemodify(".", ":~"), padding = 1 },
    { section = "recent_files", cwd = true, limit = 8, padding = 1 },
    { title = "Sessions", padding = 1 },
    { section = "projects", padding = 1 },
    { title = "Bookmarks", padding = 1 },
    { section = "keys" },
  },
},
    -- explorer = {
    --   enabled = true,
    -- replace_netrw = true
    -- },
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
      level = vim.log.levels.TRACE,
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
      enabled = true,  -- ✅ GRUPO 4: Enabled
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
          width = 0.8,
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
    -- { "<leader>e<space>", function() Snacks.explorer() end, desc = "File Explorer" },
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
    { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
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

    -- LSP Progress Integration
    -- Show LSP progress as notifications (filtered for noisy servers)
    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local value = ev.data.params.value
        if not client or type(value) ~= "table" then
          return
        end

        -- Filter out JDTLS noisy progress messages
        if client.name == "jdtls" then
          -- Only show JDTLS completion messages, not building/validating
          if value.message and (
            value.message:match("^Building") or
            value.message:match("^Validate") or
            value.message:match("^Publish Diagnostics")
          ) then
            return -- Suppress noisy JDTLS messages
          end
        end

        local title = client.name
        if value.title then
          title = title .. " - " .. value.title
        end

        -- Only show notifications for significant progress
        if value.kind == "end" or value.percentage and value.percentage >= 90 then
          Snacks.notifier.notify(value.message or "Complete", {
            id = "lsp_progress_" .. client.id,
            title = title,
            level = "info",
            timeout = 1000,
          })
        elseif value.kind == "begin" then
          -- Don't show "begin" for JDTLS at all
          if client.name ~= "jdtls" then
            Snacks.notifier.notify(value.message or "Starting...", {
              id = "lsp_progress_" .. client.id,
              title = title,
              level = "info",
              timeout = false, -- Keep until completion
            })
          end
        end
      end,
    })

    -- Override vim.notify to use Snacks
    vim.notify = function(msg, level, opts)
      Snacks.notifier.notify(msg, vim.tbl_extend("force", {
        level = level or vim.log.levels.INFO,
      }, opts or {}))
    end
  end,
}
