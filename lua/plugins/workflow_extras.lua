-- Workflow Enhancement Plugins
-- Plugins to complement the WezTerm + Neovim workflow

return {
  -- =========================================================================
  -- WHICH-KEY: Visual guide for keybindings
  -- =========================================================================
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = {
        spelling = true,
      },
      defaults = {},
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)

      -- Register groups for better organization
      wk.register({
        mode = { "n", "v" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>f"] = { name = "+find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>l"] = { name = "+layout/terminal" },
        ["<leader>s"] = { name = "+search/session" },
        ["<leader>t"] = { name = "+test" },
        ["<leader>u"] = { name = "+ui/toggle" },
        ["<leader>w"] = { name = "+window" },
      })
    end,
  },

  -- =========================================================================
  -- PERSISTENCE: Session management
  -- =========================================================================
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
      options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp" },
      pre_save = nil,
    },
    keys = {
      {
        "<leader>ss",
        function()
          require("persistence").save()
          vim.notify("💾 Session saved", vim.log.levels.INFO)
        end,
        desc = "Save session"
      },
      {
        "<leader>sl",
        function()
          require("persistence").load({ last = true })
          vim.notify("📂 Last session loaded", vim.log.levels.INFO)
        end,
        desc = "Load last session"
      },
      {
        "<leader>sr",
        function()
          require("persistence").load()
          vim.notify("📂 Session restored for current directory", vim.log.levels.INFO)
        end,
        desc = "Restore session for cwd"
      },
      {
        "<leader>sd",
        function()
          require("persistence").stop()
          vim.notify("⏸️  Session auto-save disabled", vim.log.levels.WARN)
        end,
        desc = "Don't save current session"
      },
    },
  },
}
