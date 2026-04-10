-- Verificador de estado para ruby-lsp
local M = {}

-- Función para verificar si ruby-lsp está disponible y configurado correctamente
function M.check_ruby_lsp_status()
  -- Verificar binario
  local mason_bin = vim.fn.stdpath("data") .. "/mason/bin/ruby-lsp"
  local has_mason_bin = vim.fn.filereadable(mason_bin) == 1
  local has_global_bin = vim.fn.executable("ruby-lsp") == 1

  local status = {
    bin_found = has_mason_bin or has_global_bin,
    bin_path = has_mason_bin and mason_bin or (has_global_bin and vim.fn.exepath("ruby-lsp") or nil),
    clients_active = {},
    is_registered = false,
    ruby_version = nil,
  }

  -- Verificar versión de Ruby
  local ok, res = pcall(function()
    return vim.system({ "ruby", "-v" }, { text = true }):wait()
  end)
  if ok and res and res.code == 0 then
    status.ruby_version = res.stdout:match("ruby ([%d%.]+)")

    -- Verificar si la versión es suficiente (>= 2.7.0)
    if status.ruby_version then
      local major, minor = status.ruby_version:match("(%d+)%.(%d+)")
      if major and minor then
        status.ruby_version_ok = tonumber(major) > 2 or (tonumber(major) == 2 and tonumber(minor) >= 7)
      end
    end
  end

  -- Verificar que está configurado en lspconfig
  status.is_registered = true -- En Neovim 0.11 asumimos que está registrado por defecto

  -- Verificar clientes LSP activos
  for _, client in ipairs(vim.lsp.get_clients() or {}) do
    if client.name == "ruby_lsp" then
      table.insert(status.clients_active, {
        id = client.id,
        name = client.name,
        attached_buffers = vim.tbl_count(client.attached_buffers or {}),
      })
    end
  end

  return status
end

-- Función para formatear el estado como texto legible
function M.format_status(status)
  local lines = {
    "=== Estado de Ruby LSP ===",
    "",
    "Binario:",
    status.bin_found
      and string.format("  ✓ Encontrado: %s", status.bin_path)
      or "  ✗ No encontrado, instala con Mason o 'gem install ruby-lsp'",
    "",
    "Versión de Ruby:",
  }

  if status.ruby_version then
    table.insert(lines, string.format("  ✓ %s", status.ruby_version))
    if status.ruby_version_ok == false then
      table.insert(lines, "  ✗ Versión insuficiente, ruby-lsp requiere Ruby 2.7.0+")
    end
  else
    table.insert(lines, "  ✗ No se pudo determinar la versión")
  end

  table.insert(lines, "")
  table.insert(lines, "Registro LSP:")
  table.insert(lines, status.is_registered
    and "  ✓ ruby_lsp está registrado en Neovim"
    or "  ✗ ruby_lsp NO está registrado en Neovim")

  table.insert(lines, "")
  table.insert(lines, "Clientes activos:")
  if #status.clients_active > 0 then
    for _, client in ipairs(status.clients_active) do
      table.insert(lines, string.format("  ✓ ID: %d, Nombre: %s, Buffers: %d",
        client.id, client.name, client.attached_buffers))
    end
  else
    table.insert(lines, "  ✗ No hay clientes ruby_lsp activos")
  end

  table.insert(lines, "")
  table.insert(lines, "Comandos disponibles:")
  table.insert(lines, "  :RubyLspDebug     - Muestra información de depuración")
  table.insert(lines, "  :RubyLspRestart   - Reinicia el servidor ruby_lsp")
  table.insert(lines, "  :RubyLspForceStart - Fuerza el inicio del servidor")

  return table.concat(lines, "\n")
end

-- Función para mostrar el estado en un buffer flotante
function M.show_status()
  local status = M.check_ruby_lsp_status()
  local content = M.format_status(status)

  -- Crear un buffer para el contenido
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

  -- Calcular dimensiones
  local width = 60
  local height = 20
  local win_height = vim.api.nvim_get_option("lines")
  local win_width = vim.api.nvim_get_option("columns")
  local row = math.floor((win_height - height) / 2)
  local col = math.floor((win_width - width) / 2)

  -- Configurar ventana flotante
  local opts = {
    style = "minimal",
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    border = "rounded",
  }

  -- Abrir ventana
  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(content, "\n"))

  -- Establecer colores
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")
  vim.api.nvim_win_set_option(win, "winblend", 0)

  -- Mapear 'q' y 'Esc' para cerrar la ventana
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", {silent = true, noremap = true})
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", ":close<CR>", {silent = true, noremap = true})

  return status
end

return M