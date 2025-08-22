return {
  "nvimtools/none-ls.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local null_ls = require("null-ls")
    null_ls.setup({
      sources = {
        -- Ruby
        null_ls.builtins.diagnostics.rubocop,
        null_ls.builtins.formatting.rubocop,

        -- Elixir
        null_ls.builtins.diagnostics.credo,
        null_ls.builtins.formatting.mix,

        -- Java
        -- null_ls.builtins.diagnostics.checkstyle.with({
        --   extra_args = { "-c", "/Users/ralbertomerinocolipe/workspaces/checkstyle.xml" },
        --   filetypes = { "java" },
        -- }),
        null_ls.builtins.formatting.google_java_format,
        -- Scala (scalafmt)
        null_ls.builtins.formatting.scalafmt,
        -- Terraform (terraform fmt)
        null_ls.builtins.formatting.terraform_fmt,
        null_ls.builtins.formatting.stylua

      },
    })
  end,
}

