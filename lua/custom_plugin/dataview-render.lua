-- Plugin Neovim para renderizar Dataview inline queries
-- Uso: Copia a ~/.config/nvim/lua/plugins/dataview-render.lua

local M = {}

-- Namespace para virtual text
local ns_id = vim.api.nvim_create_namespace("dataview_render")

-- Cache de resultados para performance
local cache = {}

-- Función para evaluar expresiones de fecha
local function eval_date_expr(expr)
  -- Extraer formato y operación
  local patterns = {
    -- dv.date("today").toFormat("yyyy-MM-dd")
    ['dv%.date%("today"%)%.toFormat%("([^"]+)"%)']=  function(fmt)
      return os.date(fmt:gsub("yyyy", "%%Y"):gsub("MM", "%%m"):gsub("dd", "%%d"))
    end,

    -- dv.date("today").minus({days: 1}).toFormat("...")
    ['dv%.date%("today"%)%.minus%({days: (%d+)}%)%.toFormat%("([^"]+)"%)']=  function(days, fmt)
      local time = os.time() - (tonumber(days) * 86400)
      return os.date(fmt:gsub("yyyy", "%%Y"):gsub("MM", "%%m"):gsub("dd", "%%d"), time)
    end,

    -- dv.date("today").plus({days: 1}).toFormat("...")
    ['dv%.date%("today"%)%.plus%({days: (%d+)}%)%.toFormat%("([^"]+)"%)']=  function(days, fmt)
      local time = os.time() + (tonumber(days) * 86400)
      return os.date(fmt:gsub("yyyy", "%%Y"):gsub("MM", "%%m"):gsub("dd", "%%d"), time)
    end,

    -- Día de la semana
    ['dv%.date%("today"%)%.toFormat%("cccc"%)']=  function()
      return os.date("%A")
    end,

    ['dv%.date%("today"%)%.toFormat%("ccc"%)']=  function()
      return os.date("%a")
    end,
  }

  for pattern, func in pairs(patterns) do
    local matches = {expr:match(pattern)}
    if #matches > 0 then
      return func(table.unpack(matches))
    end
  end

  return nil
end

-- Función para procesar una línea con inline query
local function process_line(line)
  -- Buscar patrón `$= "..."`
  local query = line:match('`%$=%s*"(.-)"`')
  if not query then
    return nil
  end

  -- Si está en cache, retornar
  if cache[query] then
    return cache[query]
  end

  -- Intentar evaluar expresiones simples
  local result = query

  -- Evaluar todas las expresiones dv.date() en la query
  for expr in query:gmatch("(dv%.date%b())") do
    local evaluated = eval_date_expr(expr)
    if evaluated then
      result = result:gsub(expr:gsub("([%.%(%)])", "%%%1"), evaluated)
    end
  end

  -- Si la query es solo un link, extraer el texto
  local link_text = result:match("%[%[.-%|(.-)%]%]")
  if link_text then
    cache[query] = link_text
    return link_text
  end

  cache[query] = result
  return result
end

-- Función principal para renderizar el buffer
function M.render_buffer()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  -- Limpiar virtual text anterior
  vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

  local count = 0
  -- Procesar cada línea
  for i, line in ipairs(lines) do
    local result = process_line(line)
    if result then
      count = count + 1
      -- Agregar virtual text en NUEVA LÍNEA debajo (más visible para líneas largas)
      vim.api.nvim_buf_set_extmark(bufnr, ns_id, i - 1, 0, {
        virt_lines = {
          {{"    ⟹ " .. result, "DiagnosticHint"}},
        },
        virt_lines_above = false, -- Debajo de la línea
      })
    end
  end

  -- Mensaje de confirmación
  if count > 0 then
    vim.notify("✅ Renderizadas " .. count .. " queries de Dataview", vim.log.levels.INFO)
  end
end

-- Auto-renderizar al abrir archivos .md en el vault
function M.setup()
  -- Soportar múltiples rutas posibles del vault
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = {
      "*/Vault/*.md",
      "*/BulletJournal/*.md",
      "*obsidian*/Documents/*/*.md",
    },
    callback = function()
      vim.defer_fn(function()
        M.render_buffer()
      end, 100) -- Delay pequeño para asegurar que el buffer está listo
    end,
  })

  -- Comando manual para re-renderizar
  vim.api.nvim_create_user_command("DataviewRender", M.render_buffer, {})

  -- Keymap opcional
  vim.keymap.set("n", "<leader>jR", M.render_buffer, { desc = "Render Dataview queries" })

  -- También renderizar al guardar
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = {"*.md"},
    callback = function()
      local bufname = vim.api.nvim_buf_get_name(0)
      if bufname:match("obsidian") or bufname:match("Vault") or bufname:match("BulletJournal") then
        M.render_buffer()
      end
    end,
  })
end

return M
