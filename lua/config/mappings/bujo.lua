-- Bullet Journal specific mappings for Neovim + Obsidian.nvim
-- Additional shortcuts for BuJo workflow on top of obsidian.nvim defaults

vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    local map = vim.keymap.set
    local opts = { buffer = true, silent = true }

    -- ========================================
    -- Navigation & Quick Access
    -- ========================================

    -- Open Index (Dashboard)
    map("n", "<leader>oi", function()
      local index_path = vim.fn.expand("~/Vault/Index.md")
      vim.cmd("edit " .. index_path)
    end, vim.tbl_extend("force", opts, { desc = "Open Index (Dashboard)" }))

    -- Open Key (BuJo notation reference)
    map("n", "<leader>o?", function()
      vim.cmd("edit ~/Vault/templates/key.md")
    end, vim.tbl_extend("force", opts, { desc = "Open Key (notation guide)" }))

    -- Weekly note (current week)
    map("n", "<leader>ow", function()
      local week = os.date("%Y-W%V")
      local weekly_path = vim.fn.expand(string.format("~/Vault/weekly/%s.md", week))

      -- Create directory if it doesn't exist
      local weekly_dir = vim.fn.expand("~/Vault/weekly")
      if vim.fn.isdirectory(weekly_dir) == 0 then
        vim.fn.mkdir(weekly_dir, "p")
      end

      -- Open file
      vim.cmd("edit " .. weekly_path)

      -- If new file, insert template
      if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
        vim.cmd("ObsidianTemplate weekly")
      end
    end, vim.tbl_extend("force", opts, { desc = "Open current week note" }))

    -- Monthly note (current month)
    map("n", "<leader>oM", function()
      local month = os.date("%Y-%m")
      local monthly_path = vim.fn.expand(string.format("~/Vault/monthly/%s.md", month))

      -- Create directory if it doesn't exist
      local monthly_dir = vim.fn.expand("~/Vault/monthly")
      if vim.fn.isdirectory(monthly_dir) == 0 then
        vim.fn.mkdir(monthly_dir, "p")
      end

      -- Open file
      vim.cmd("edit " .. monthly_path)

      -- If new file, insert template
      if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
        vim.cmd("ObsidianTemplate monthly")
      end
    end, vim.tbl_extend("force", opts, { desc = "Open current month note" }))

    -- Future log (current year)
    map("n", "<leader>oF", function()
      local year = os.date("%Y")
      local future_path = vim.fn.expand(string.format("~/Vault/future-log/%s.md", year))

      -- Create directory if it doesn't exist
      local future_dir = vim.fn.expand("~/Vault/future-log")
      if vim.fn.isdirectory(future_dir) == 0 then
        vim.fn.mkdir(future_dir, "p")
      end

      -- Open file
      vim.cmd("edit " .. future_path)

      -- If new file, insert template
      if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
        vim.cmd("ObsidianTemplate future-log")
      end
    end, vim.tbl_extend("force", opts, { desc = "Open future log" }))

    -- ========================================
    -- BuJo Symbols (Insert Mode)
    -- ========================================

    -- Task symbols
    map("i", "<C-b>t", "- [ ] ", { buffer = true, desc = "Insert task [ ]" })
    map("i", "<C-b>x", "- [x] ", { buffer = true, desc = "Insert completed [x]" })
    map("i", "<C-b>>", "- [>] ", { buffer = true, desc = "Insert migrated [>]" })
    map("i", "<C-b><", "- [<] ", { buffer = true, desc = "Insert scheduled [<]" })
    map("i", "<C-b>-", "- [-] ", { buffer = true, desc = "Insert cancelled [-]" })

    -- Content symbols
    map("i", "<C-b>n", "- ", { buffer = true, desc = "Insert note -" })
    map("i", "<C-b>e", "o ", { buffer = true, desc = "Insert event o" })
    map("i", "<C-b>p", "* ", { buffer = true, desc = "Insert priority *" })
    map("i", "<C-b>i", "! ", { buffer = true, desc = "Insert idea !" })

    -- ========================================
    -- Task Management (Normal Mode)
    -- ========================================

    -- Toggle task states (cycle through)
    map("n", "<leader>ox", function()
      local line = vim.api.nvim_get_current_line()

      if line:match("^%s*-%s*%[%s%]") then
        -- [ ] → [x]
        local new_line = line:gsub("%[%s%]", "[x]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*-%s*%[x%]") then
        -- [x] → [>]
        local new_line = line:gsub("%[x%]", "[>]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*-%s*%[>%]") then
        -- [>] → [<]
        local new_line = line:gsub("%[>%]", "[<]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*-%s*%[<%]") then
        -- [<] → [-]
        local new_line = line:gsub("%[<%]", "[-]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*-%s*%[%-]") then
        -- [-] → [ ]
        local new_line = line:gsub("%[%-]", "[ ]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*•") then
        -- • → x (pure BuJo notation)
        local new_line = line:gsub("•", "x")
        vim.api.nvim_set_current_line(new_line)
      else
        vim.notify("Not a task line", vim.log.levels.WARN)
      end
    end, vim.tbl_extend("force", opts, { desc = "Cycle task state" }))

    -- Mark task as completed
    map("n", "<leader>od", function()
      local line = vim.api.nvim_get_current_line()
      if line:match("^%s*-%s*%[.%]") then
        local new_line = line:gsub("%[.%]", "[x]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*•") then
        local new_line = line:gsub("•", "x")
        vim.api.nvim_set_current_line(new_line)
      else
        vim.notify("Not a task line", vim.log.levels.WARN)
      end
    end, vim.tbl_extend("force", opts, { desc = "Mark task as done [x]" }))

    -- Mark task as migrated
    map("n", "<leader>o>", function()
      local line = vim.api.nvim_get_current_line()
      if line:match("^%s*-%s*%[.%]") then
        local new_line = line:gsub("%[.%]", "[>]")
        vim.api.nvim_set_current_line(new_line)
      elseif line:match("^%s*•") then
        local new_line = line:gsub("•", ">")
        vim.api.nvim_set_current_line(new_line)
      else
        vim.notify("Not a task line", vim.log.levels.WARN)
      end
    end, vim.tbl_extend("force", opts, { desc = "Mark task as migrated [>]" }))

    -- Mark task as cancelled
    map("n", "<leader>o-", function()
      local line = vim.api.nvim_get_current_line()
      if line:match("^%s*-%s*%[.%]") then
        local new_line = line:gsub("%[.%]", "[-]")
        vim.api.nvim_set_current_line(new_line)
      else
        vim.notify("Not a task line", vim.log.levels.WARN)
      end
    end, vim.tbl_extend("force", opts, { desc = "Cancel task [-]" }))

    -- ========================================
    -- Quick Templates
    -- ========================================

    -- Insert daily template snippet
    map("n", "<leader>oTd", function()
      local lines = {
        "## 🎯 Top Priorities (Max 3)",
        "",
        "- [ ] * Priority 1",
        "- [ ] * Priority 2",
        "- [ ] * Priority 3",
        "",
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    end, vim.tbl_extend("force", opts, { desc = "Insert priorities snippet" }))

    -- Insert rapid logging section
    map("n", "<leader>oTr", function()
      local lines = {
        "## 📝 Rapid Logging",
        "",
        "### Tasks",
        "- [ ] ",
        "",
        "### Events",
        "o ",
        "",
        "### Notes",
        "- ",
        "",
      }
      local row = vim.api.nvim_win_get_cursor(0)[1]
      vim.api.nvim_buf_set_lines(0, row, row, false, lines)
    end, vim.tbl_extend("force", opts, { desc = "Insert rapid logging snippet" }))

    -- ========================================
    -- Utilities
    -- ========================================

    -- Open BuJo System Guide
    map("n", "<leader>oH", function()
      vim.cmd("edit ~/Vault/templates/BUJO_SYSTEM_GUIDE.md")
    end, vim.tbl_extend("force", opts, { desc = "Open BuJo System Guide" }))

    -- Open Sync Guide
    map("n", "<leader>oS", function()
      vim.cmd("edit ~/Vault/SYNC_GUIDE.md")
    end, vim.tbl_extend("force", opts, { desc = "Open Sync Guide" }))

    -- Search in vault with live grep
    map("n", "<leader>o/", function()
      require("snacks").picker.grep({ cwd = vim.fn.expand("~/Vault") })
    end, vim.tbl_extend("force", opts, { desc = "Grep in Vault" }))

    -- Find files in vault
    map("n", "<leader>off", function()
      require("snacks").picker.files({ cwd = vim.fn.expand("~/Vault") })
    end, vim.tbl_extend("force", opts, { desc = "Find files in Vault" }))

    -- ========================================
    -- Visual Mode Operations
    -- ========================================

    -- Convert selection to task list
    map("v", "<leader>ot", function()
      vim.cmd("'<,'>s/^\\s*/- [ ] /")
      vim.cmd("nohlsearch")
    end, vim.tbl_extend("force", opts, { desc = "Convert to task list" }))

    -- Add priority marker to selected tasks
    map("v", "<leader>op", function()
      vim.cmd("'<,'>s/^\\(\\s*-\\s*\\[.\\]\\)\\s*/\\1 * /")
      vim.cmd("nohlsearch")
    end, vim.tbl_extend("force", opts, { desc = "Add priority marker" }))
  end,
})

-- ========================================
-- Global BuJo Commands (not markdown-specific)
-- ========================================

-- Helper function to open periodic notes with template
local function open_periodic_note(period_type, filename, template_name)
  local base_dir = vim.fn.expand(string.format("~/Vault/%s", period_type))
  local file_path = vim.fn.expand(string.format("%s/%s.md", base_dir, filename))

  -- Create directory if it doesn't exist
  if vim.fn.isdirectory(base_dir) == 0 then
    vim.fn.mkdir(base_dir, "p")
  end

  -- Open file
  vim.cmd("edit " .. file_path)

  -- If new file, insert template
  if vim.fn.line('$') == 1 and vim.fn.getline(1) == '' then
    vim.cmd("ObsidianTemplate " .. template_name)
  end
end

-- Quick open today's daily note from anywhere
vim.keymap.set("n", "<leader>jd", function()
  vim.cmd("ObsidianToday")
end, { desc = "Jump to today's daily note" })

-- Quick open Index from anywhere
-- Note: Using simple edit command to avoid conflicts with obsidian.nvim
vim.keymap.set("n", "<leader>jj", "<cmd>edit ~/Vault/Index.md<CR>", {
  desc = "Jump to Index (Dashboard)",
  noremap = true,
  silent = true
})

-- Quick open current week from anywhere
vim.keymap.set("n", "<leader>jw", function()
  local week = os.date("%Y-W%V")
  open_periodic_note("weekly", week, "weekly")
end, { desc = "Jump to current week" })

-- Quick open current month from anywhere
vim.keymap.set("n", "<leader>jm", function()
  local month = os.date("%Y-%m")
  open_periodic_note("monthly", month, "monthly")
end, { desc = "Jump to current month" })

-- Create user command for BuJo navigation
vim.api.nvim_create_user_command("BuJoToday", function()
  vim.cmd("ObsidianToday")
end, { desc = "Open today's daily note" })

vim.api.nvim_create_user_command("BuJoIndex", function()
  vim.cmd("edit ~/Vault/Index.md")
end, { desc = "Open BuJo Index" })

vim.api.nvim_create_user_command("BuJoWeek", function()
  local week = os.date("%Y-W%V")
  open_periodic_note("weekly", week, "weekly")
end, { desc = "Open current week note" })

vim.api.nvim_create_user_command("BuJoMonth", function()
  local month = os.date("%Y-%m")
  open_periodic_note("monthly", month, "monthly")
end, { desc = "Open current month note" })
