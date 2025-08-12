local telescope = require("telescope")

_G.base_vimgrep_args = {
  "rg",
  "--color=never",
  "--no-heading",
  "--with-filename",
  "--line-number",
  "--column",
  "--smart-case",
  "--hidden"
}
telescope.setup({
  defaults = {
    vimgrep_arguments = base_vimgrep_args,
  },
    -- defaults = {
    --     debug = true,
    --     -- pickers = {
    --     --     -- live_grep = {
    --     --     --     file_ignore_patterns = { 'node_modules', '.git', '.venv' },
    --     --     --     -- additional_args = function(_)
    --     --     --     --     return { "--hidden" }
    --     --     --     -- end
    --     --     -- },
    --     --     find_files = {
    --     --         file_ignore_patterns = { 'node_modules', '.git', '.venv' },
    --     --         hidden = true
    --     --     }
    --     --
    --     -- }
    -- },
    extensions = {
        live_grep_args = {
          auto_quoting = false, -- enable/disable auto-quoting
          -- define mappings, e.g.
          -- mappings = { -- extend mappings
          --   i = {
          --     ["<C-k>"] = lga_actions.quote_prompt(),
          --     ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
          --     -- freeze the current list and start a fuzzy search in the frozen list
          --     ["<C-space>"] = lga_actions.to_fuzzy_refine,
          --   },
          -- },
          -- ... also accepts theme settings, for example:
          -- theme = "dropdown", -- use dropdown theme
          -- theme = { }, -- use own theme spec
          -- layout_config = { mirror=true }, -- mirror preview pane
        },
        
        frecency = {
          show_scores = true,
          show_unindexed = false,
          ignore_patterns = {"*.git/*", "*/tmp/*"},
            workspaces = {
              ["conf"]    = "~/.config",
              ["data"]    = "~/.local/share",
              ["pd"] = "~/workspaces/Pagerduty",
              ["web"] = "~/workspaces/Pagerduty/web",
              ["schedule_facade"] = "~/workspaces/Pagerduty/ir-schedules-facade/",
              ["schedule_compute"] = "~/workspaces/Pagerduty/schedule-compute-service/",
              ["les"] = "~/workspaces/Pagerduty/log_entry_service/",
              ["fos"] = "~/workspaces/Pagerduty/flexible-objects-service/",
            }
        }


    },
})
-- telescope.load_extension("fzf")
telescope.load_extension("live_grep_args")
telescope.load_extension("frecency")
