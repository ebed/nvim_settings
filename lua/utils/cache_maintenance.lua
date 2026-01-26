local M = {}

-- Función para limpiar archivos temporales específicos
M.clean_temp_files = function()
  -- Rutas de archivos problemáticos
  local lock_files = {
    vim.fn.stdpath("state") .. "/file_frecency.bin.lock",
    vim.fn.stdpath("state") .. "/lazy/state.json.lock"
  }

  -- Eliminar archivos de bloqueo si existen
  for _, file in ipairs(lock_files) do
    if vim.fn.filereadable(file) == 1 then
      vim.fn.delete(file)
    end
  end

  -- Limpiar caché de snacks si es demasiado grande
  local snacks_dir = vim.fn.stdpath("cache") .. "/nvim/snacks"
  if vim.fn.isdirectory(snacks_dir) == 1 then
    local cmd = "find " .. snacks_dir .. " -type f -name '*.txt' | wc -l"
    local count = tonumber(vim.fn.system(cmd):match("%d+"))

    -- Si hay más de 50 archivos, limpiar los más antiguos
    if count and count > 50 then
      vim.fn.system("find " .. snacks_dir .. " -type f -name '*.txt' -printf '%T@ %p\\n' | sort -n | head -n " ..
                   (count - 50) .. " | cut -d' ' -f2- | xargs rm -f")
    end
  end
end

-- Verificar espacio en disco
M.check_disk_space = function()
  local state_dir = vim.fn.stdpath("state")
  local cache_dir = vim.fn.stdpath("cache")

  -- Intentar crear un archivo temporal para probar permisos
  local function check_write_permissions(dir)
    local test_file = dir .. "/write_test"
    local success = pcall(function()
      local f = io.open(test_file, "w")
      if f then
        f:write("test")
        f:close()
        os.remove(test_file)
        return true
      end
      return false
    end)
    return success
  end

  -- Verificar permisos de escritura
  if not check_write_permissions(state_dir) then
    vim.notify("¡Advertencia! No se puede escribir en " .. state_dir, vim.log.levels.ERROR)
  end

  if not check_write_permissions(cache_dir) then
    vim.notify("¡Advertencia! No se puede escribir en " .. cache_dir, vim.log.levels.ERROR)
  end
end

-- Configurar limpieza automática
M.setup = function()
  -- Ejecutar limpieza al iniciar Neovim
  M.clean_temp_files()
  M.check_disk_space()

  -- Crear autocomandos para limpieza periódica
  local augroup = vim.api.nvim_create_augroup("cache_maintenance", { clear = true })

  -- Limpiar archivos temporales cada 30 minutos
  vim.api.nvim_create_autocmd("VimEnter", {
    group = augroup,
    callback = function()
      vim.defer_fn(function()
        M.clean_temp_files()
      end, 30 * 60 * 1000) -- 30 minutos
    end,
    desc = "Limpieza periódica de archivos temporales"
  })

  -- Verificar espacio al guardar archivos de configuración
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = augroup,
    pattern = vim.fn.stdpath("config") .. "/**/*.lua",
    callback = function()
      M.check_disk_space()
    end,
    desc = "Verificar espacio en disco al guardar archivos de configuración"
  })
end

return M