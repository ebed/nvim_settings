-- Comando simple para formatear Ruby con rubocop
-- Bypass LSP, usa rubocop directamente

vim.api.nvim_create_user_command("RubyFormat", function()
  local filetype = vim.bo.filetype
  if filetype ~= "ruby" and filetype ~= "eruby" then
    vim.notify("Este comando solo funciona en archivos Ruby", vim.log.levels.WARN)
    return
  end

  -- Verificar que rubocop existe
  if vim.fn.executable("rubocop") == 0 then
    vim.notify("rubocop no está instalado", vim.log.levels.ERROR)
    return
  end

  -- Guardar el archivo si tiene cambios
  if vim.bo.modified then
    vim.cmd("write")
  end

  local file_path = vim.fn.expand("%:p")
  vim.notify("Formateando con rubocop...", vim.log.levels.INFO)

  -- Usar system() en lugar de jobstart para ser síncrono y más simple
  local cmd = string.format("rubocop --autocorrect-all %s 2>&1", vim.fn.shellescape(file_path))
  local output = vim.fn.system(cmd)
  local exit_code = vim.v.shell_error

  -- Recargar el archivo
  vim.cmd("edit!")

  if exit_code == 0 or exit_code == 1 then
    vim.notify("✓ Formateado con rubocop", vim.log.levels.INFO)
  else
    vim.notify("Rubocop ejecutado (código " .. exit_code .. ")", vim.log.levels.WARN)
  end
end, { desc = "Formatear Ruby con rubocop" })

-- Autocomando para setear el keymap en archivos Ruby
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "ruby", "eruby" },
  callback = function()
    vim.keymap.set("n", "<leader>rf", "<cmd>RubyFormat<CR>", {
      buffer = true,
      desc = "Formatear con rubocop",
      silent = true
    })
  end,
})

return {}
