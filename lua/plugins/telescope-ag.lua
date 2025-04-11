return {
    "nvim-telescope/telescope.nvim" ,
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        {
        "nvim-telescope/telescope-live-grep-args.nvim" ,
        -- This will not install any breaking changes.
        -- For major updates, this must be adjusted manually.
        version = "^1.0.0",
        },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        { "kelly-lin/telescope-ag" },
        { 
            "nvim-telescope/telescope-frecency.nvim",
           -- install the latest stable version
          version = "*",
        }
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            defaults = {
                pickers = {
                    live_grep = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        additional_args = function(_)
                            return { "--hidden" }
                        end
                    },
                    find_files = {
                        file_ignore_patterns = { 'node_modules', '.git', '.venv' },
                        hidden = true
                    }

                },
                    vimgrep_arguments = {
                      "rg",
                      "-L",
                      "--color=never",
                      "--no-heading",
                      "--with-filename",
                      "--line-number",
                      "--column",
                      "--smart-case",
                      "--hidden",
                    },
                extensions = {
                    "fzf",
                    live_grep_args = {
                      auto_quoting = true, -- enable/disable auto-quoting
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
                    }

                },
            },
        })
        telescope.load_extension("fzf")
        telescope.load_extension("live_grep_args")
        telescope.load_extension("frecency")

    end,
}
