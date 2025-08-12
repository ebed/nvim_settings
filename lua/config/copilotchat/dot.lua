local M = {}

-- Función para obtener la selección visual actual
local function get_visual_selection()
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])
  if #lines == 0 then return "" end
  lines[1] = string.sub(lines[1], start_pos[3])
  lines[#lines] = string.sub(lines[#lines], 1, end_pos[3])
  return table.concat(lines, "\n")
end

-- Función principal para crear archivo DOT
function M.create_dot_from_selection()
  local selection = get_visual_selection()
  if selection == "" then
    vim.notify("No hay selección visual", vim.log.levels.WARN)
    return
  end

  -- Aquí puedes invocar CopilotChat o tu lógica de transformación
  -- Por simplicidad, este ejemplo solo envuelve el texto en un grafo DOT básico
  local dot_content = "digraph G {\n" .. selection .. "\n}"

  -- Solicita el nombre del archivo
  vim.ui.input({ prompt = "Nombre del archivo DOT: ", default = "graph.dot" }, function(filename)
    if filename then
      local path = vim.fn.expand("%:p:h") .. "/" .. filename
      local file = io.open(path, "w")
      if file then
        file:write(dot_content)
        file:close()
        vim.notify("Archivo DOT creado: " .. path, vim.log.levels.INFO)
        vim.cmd("edit " .. path)
      else
        vim.notify("No se pudo crear el archivo", vim.log.levels.ERROR)
      end
    end
  end)
end

return M

