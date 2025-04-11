return {
  "elixir-tools/elixir-tools.nvim",
  version = "*",
  event = { "BufReadPre", "BufNewFile" },
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup {
      nextls = {
          enable = false, -- defaults to false
          port = 9000, -- connect via TCP with the given port. mutually exclusive with `cmd`. defaults to nil
          cmd = {"next-ls", "--stdio"}, -- path to the executable. mutually exclusive with `port`
          spitfire = true, -- defaults to false
          init_options = {
            extensions = {
              credo = { enable = true }
            },
            mix_env = "dev",
            mix_target = "host",
            experimental = {
              completions = {
                enable = true-- control if completions are enabled. defaults to false
              }
            }
        },
        on_attach = function(client, bufnr)
          -- custom keybinds
        end
      },
      elixirls = {
        -- specify a repository and branch
        repo = "elixir-lsp/elixir-ls", -- defaults to elixir-lsp/elixir-ls
        -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
        tag = "v0.27.2", -- defaults to nil, mutually exclusive with the `branch` option

        -- alternatively, point to an existing elixir-ls installation (optional)
        -- not currently supported by elixirls, but can be a table if you wish to pass other args `{"path/to/elixirls", "--foo"}`
        -- cmd = "/usr/local/Cellar/elixir-ls/0.27.2/libexec/launch",

        -- default settings, use the `settings` function to override settings
        settings = elixirls.settings {
          dialyzerEnabled = true,
          fetchDeps = false,
          enableTestLenses = true,
          suggestSpecs = true,
        },
        on_attach = function(client, bufnr)
          vim.keymap.set("n", "<space>Efp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("n", "<space>Etp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
          vim.keymap.set("v", "<space>Eem", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        end
      },
      projectionist = {
        enable = true
      }
    }
  end,
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
}
