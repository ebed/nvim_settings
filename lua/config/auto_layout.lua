-- Auto Layout por Tipo de Proyecto
-- Abre explorer + terminal automáticamente según el proyecto

local M = {}

function M.setup_project_layout()
  -- Solo si abriste Neovim con archivo/directorio (no dashboard vacío)
  local argc = vim.fn.argc()
  if argc == 0 then
    return -- Dejar que dashboard se encargue
  end

  -- Detectar tipo de proyecto
  local cwd = vim.fn.getcwd()

  local is_node = vim.fn.filereadable(cwd .. "/package.json") == 1
  local is_rust = vim.fn.filereadable(cwd .. "/Cargo.toml") == 1
  local is_python = vim.fn.filereadable(cwd .. "/pyproject.toml") == 1
                 or vim.fn.filereadable(cwd .. "/requirements.txt") == 1
  local is_go = vim.fn.filereadable(cwd .. "/go.mod") == 1

  -- Solo aplicar auto-layout para ciertos proyectos
  local should_auto_layout = is_node or is_rust or is_python or is_go

  if not should_auto_layout then
    return
  end

  -- Esperar a que Neovim termine de cargar
  vim.defer_fn(function()
    -- Verificar que no estemos en un buffer especial
    local buftype = vim.bo.buftype
    if buftype ~= "" then
      return
    end

    -- Layout: [explorer] [buffer] con terminal abajo

    -- 1. Abrir explorer a la izquierda
    vim.cmd("Snacks explorer")

    -- 2. Volver al buffer principal
    vim.cmd("wincmd l")

    -- 3. Split horizontal para terminal (15 líneas)
    vim.cmd("split")
    vim.cmd("wincmd j")
    vim.cmd("resize 15")
    vim.cmd("terminal")

    -- 4. Entrar en insert mode en terminal
    vim.cmd("startinsert")

    -- 5. Volver al buffer principal
    vim.defer_fn(function()
      vim.cmd("wincmd k")
    end, 100)

    -- Notificar
    vim.notify("🎯 Auto-layout aplicado para proyecto " ..
      (is_node and "Node.js" or
       is_rust and "Rust" or
       is_python and "Python" or
       is_go and "Go" or "detectado"),
      vim.log.levels.INFO)
  end, 200) -- Delay para que todo cargue
end

-- Comando para toggle auto-layout
vim.api.nvim_create_user_command("AutoLayoutToggle", function()
  -- Guardar estado en variable global
  _G.auto_layout_enabled = not _G.auto_layout_enabled

  local status = _G.auto_layout_enabled and "habilitado" or "deshabilitado"
  vim.notify("Auto-layout " .. status, vim.log.levels.INFO)
end, {})

return M
