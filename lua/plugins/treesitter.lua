return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- Usar la última versión
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").setup({
      ensure_installed = {
        "lua",
        "vim",
        "vimdoc",
        "query",
        "javascript",
        "typescript",
        "json",
        "ruby",
        "java",
        "yaml",
        "http",
        "elixir",
        "heex",
        "eex", -- Lenguajes para Elixir
      },
      sync_install = true,
      auto_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    })
  end,
  priority = 1000, -- Alta prioridad para asegurar que TreeSitter esté disponible para otros plugins
  dependencies = {}, -- Sin dependencias para evitar ciclos
}
