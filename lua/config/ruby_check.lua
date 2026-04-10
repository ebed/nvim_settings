-- Simple comando para verificar estado de Ruby/Rails

vim.api.nvim_create_user_command("RubyCheck", function()
  local lines = {}

  -- Verificar Ruby
  local ruby_version = vim.fn.system("ruby -v"):gsub("\n", "")
  table.insert(lines, "Ruby: " .. ruby_version)

  -- Verificar filetype
  local ft = vim.bo.filetype
  table.insert(lines, string.format("Filetype actual: %s", ft))

  -- Verificar gems
  local has_rubocop = vim.fn.executable("rubocop") == 1
  local has_rspec = vim.fn.executable("rspec") == 1
  local has_bundle = vim.fn.executable("bundle") == 1
  local has_ruby_lsp = vim.fn.executable("ruby-lsp") == 1

  table.insert(lines, "")
  table.insert(lines, "Herramientas:")
  table.insert(lines, string.format("  ruby-lsp: %s", has_ruby_lsp and "✓" or "✗"))
  table.insert(lines, string.format("  rubocop: %s", has_rubocop and "✓" or "✗"))
  table.insert(lines, string.format("  rspec: %s", has_rspec and "✓" or "✗"))
  table.insert(lines, string.format("  bundle: %s", has_bundle and "✓" or "✗"))

  -- Verificar LSP activo
  local clients = vim.lsp.get_clients({ name = "ruby_lsp", bufnr = 0 })
  table.insert(lines, "")
  table.insert(lines, string.format("ruby_lsp activo: %s", #clients > 0 and "✓" or "✗"))

  if #clients == 0 then
    table.insert(lines, "")
    table.insert(lines, "LSP no activo. Usa:")
    table.insert(lines, "  :RubyLspStart   - Forzar inicio del LSP")
    table.insert(lines, "  :LspInfo        - Ver información detallada")
    table.insert(lines, "  :LspLog         - Ver logs de error")
  else
    table.insert(lines, "")
    table.insert(lines, "Clientes activos:")
    for _, client in ipairs(clients) do
      table.insert(lines, string.format("  ID: %d, Root: %s", client.id, client.root_dir or "N/A"))
    end
  end

  -- Verificar formateo
  table.insert(lines, "")
  table.insert(lines, "Formateo:")
  table.insert(lines, "  <leader>f → conform.nvim con rubocop")

  -- Mostrar
  vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end, { desc = "Verificar configuración Ruby" })

-- Comando para forzar inicio de ruby_lsp
vim.api.nvim_create_user_command("RubyLspStart", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local ft = vim.bo[bufnr].filetype

  if ft ~= "ruby" and ft ~= "eruby" then
    vim.notify("Este comando solo funciona en archivos Ruby", vim.log.levels.WARN)
    return
  end

  -- Intentar iniciar el LSP
  vim.lsp.start({
    name = "ruby_lsp",
    cmd = { "ruby-lsp" },
    root_dir = vim.fs.root(bufnr, { ".git", "Gemfile", ".ruby-version" }) or vim.fn.getcwd(),
  })

  vim.notify("Intentando iniciar ruby_lsp...", vim.log.levels.INFO)

  -- Verificar después de 2 segundos
  vim.defer_fn(function()
    local clients = vim.lsp.get_clients({ name = "ruby_lsp", bufnr = bufnr })
    if #clients > 0 then
      vim.notify("ruby_lsp iniciado correctamente", vim.log.levels.INFO)
    else
      vim.notify("Error: ruby_lsp no se pudo iniciar. Verifica :LspLog", vim.log.levels.ERROR)
    end
  end, 2000)
end, { desc = "Forzar inicio de ruby_lsp" })

-- Comando para limpiar el directorio .ruby-lsp problemático
vim.api.nvim_create_user_command("RubyLspCleanCache", function()
  local root = vim.fs.root(0, { ".git", "Gemfile" })
  if not root then
    vim.notify("No se encontró el root del proyecto", vim.log.levels.WARN)
    return
  end

  local ruby_lsp_dir = root .. "/.ruby-lsp"
  local uv = vim.uv or vim.loop

  if uv.fs_stat(ruby_lsp_dir) then
    local choice = vim.fn.confirm(
      "¿Eliminar " .. ruby_lsp_dir .. "?",
      "&Sí\n&No",
      2
    )

    if choice == 1 then
      vim.fn.delete(ruby_lsp_dir, "rf")
      vim.notify("Cache de ruby-lsp eliminado. Reinicia Neovim.", vim.log.levels.INFO)
    else
      vim.notify("Operación cancelada", vim.log.levels.INFO)
    end
  else
    vim.notify("No existe el directorio .ruby-lsp en este proyecto", vim.log.levels.INFO)
  end
end, { desc = "Limpiar cache de ruby-lsp (.ruby-lsp/)" })

return {}
