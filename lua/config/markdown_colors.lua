-- Configuración de colores limpios para Markdown
-- Elimina fondos rojos y establece colores simples

local M = {}

function M.setup()
  -- Crear autocmd que se ejecute cuando se abra un archivo markdown
  vim.api.nvim_create_autocmd({ "FileType", "BufEnter" }, {
    pattern = { "markdown", "md" },
    callback = function()
      -- Limpiar todos los highlight groups de markdown que puedan tener fondos molestos
      local groups = {
        -- Treesitter markdown groups
        "@markup.heading.1.markdown",
        "@markup.heading.2.markdown",
        "@markup.heading.3.markdown",
        "@markup.heading.4.markdown",
        "@markup.heading.5.markdown",
        "@markup.heading.6.markdown",
        "@markup.heading",
        "@text.title",
        "@text.title.1.markdown",
        "@text.title.2.markdown",
        "@text.title.3.markdown",
        "@text.title.4.markdown",
        "@text.title.5.markdown",
        "@text.title.6.markdown",

        -- Standard markdown groups
        "markdownH1",
        "markdownH2",
        "markdownH3",
        "markdownH4",
        "markdownH5",
        "markdownH6",
        "markdownHeadingDelimiter",

        -- HTML heading groups (sometimes used in markdown)
        "htmlH1",
        "htmlH2",
        "htmlH3",
        "htmlH4",
        "htmlH5",
        "htmlH6",

        -- Title groups
        "Title",
      }

      -- Establecer colores limpios sin fondos
      for _, group in ipairs(groups) do
        vim.api.nvim_set_hl(0, group, {
          fg = "#5fafd7",  -- Azul claro agradable
          bold = true,
          bg = "NONE",     -- Sin fondo
        })
      end

      -- Otros elementos markdown con colores simples
      vim.api.nvim_set_hl(0, "@markup.bold.markdown", { bold = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.italic.markdown", { italic = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.list.markdown", { fg = "#d7875f", bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.link.markdown", { fg = "#af87d7", underline = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.raw.markdown", { fg = "#87af87", bg = "NONE" })
      vim.api.nvim_set_hl(0, "@markup.quote.markdown", { fg = "#8a8a8a", italic = true, bg = "NONE" })

      -- Standard markdown syntax
      vim.api.nvim_set_hl(0, "markdownCode", { fg = "#87af87", bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownCodeBlock", { fg = "#87af87", bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownCodeDelimiter", { fg = "#8a8a8a", bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownBold", { bold = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownItalic", { italic = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownListMarker", { fg = "#d7875f", bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownLink", { fg = "#af87d7", underline = true, bg = "NONE" })
      vim.api.nvim_set_hl(0, "markdownUrl", { fg = "#5f87d7", underline = true, bg = "NONE" })
    end,
  })
end

return M
