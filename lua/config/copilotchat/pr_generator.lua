local M = {}
local CopilotChat = require("CopilotChat")

-- 1. Obtener la descripción actual del PR
function M.get_pr_description()
  local handle = io.popen('gh pr view --json body --jq .body 2>/dev/null')
  local desc = handle:read("*a")
  handle:close()
  if desc == "" or desc:match("not found") then
    return nil
  end
  return desc
end

-- Check if a PR exists for the current branch
function M.ensure_pr_exists()
  local desc = M.get_pr_description()
  if desc ~= nil then
    return true
  end
  -- Create PR if it does not exist
  local title = vim.fn.input("Enter PR title: ")
  local base = "main"
  local cmd = string.format('gh pr create --base %s --title "%s" --body "Initial PR"', base, title)
  local result = os.execute(cmd)
  if result ~= 0 then
    vim.notify("Failed to create PR", vim.log.levels.ERROR)
    return false
  end
  vim.notify("PR created successfully.")
  return true
end
-- 2. Obtener los cambios recientes
function M.get_diff()
  local handle = io.popen('git diff origin/main..HEAD')
  local diff = handle:read("*a")
  handle:close()
  print(vim.inspect(diff))
  return diff or ""
end

-- 3. Actualizar la descripción del PR
function M.update_pr_description(new_desc)
  -- Guarda la nueva descripción en un archivo temporal
  local tmpfile = "/tmp/pr_desc_update.txt"
  local f = io.open(tmpfile, "w")
  f:write(new_desc)
  f:close()
  -- Actualiza el PR usando gh
  os.execute('gh pr edit --body-file ' .. tmpfile)
end

-- 4. Flujo principal
function M.enhance_pr_description()
  -- Ensure PR exists (create if not)
  if not M.ensure_pr_exists() then
    vim.notify("Could not ensure PR exists.", vim.log.levels.ERROR)
    return
  end
  local old_desc = M.get_pr_description()
  local diff = M.get_diff()
  if diff == "" then
    vim.notify("No hay cambios recientes para analizar.")
    return
  end

  local prompt = [[
Eres un asistente experto en documentación de Pull Requests.
Analiza los siguientes cambios y la descripción actual del PR.
- Si corresponde, agrega diagramas relevantes usando mermaid.
- Si aplica, incluye shapes y/o messages para clarificar el flujo o arquitectura.
- Mejora la descripción del PR agregando contexto relevante, pero manteniendo lo existente.
- Devuelve el texto completo de la nueva descripción, listo para reemplazar el cuerpo del PR.

Descripción actual:
]] .. old_desc .. [[

Cambios recientes:
]] .. diff

  CopilotChat.ask(prompt, {
    callback = function(response)
      print(vim.inspect(response))
      local new_desc = response.content or response
      M.update_pr_description(new_desc)
      vim.notify("Descripción del PR actualizada con éxito.")
    end
  })
end
return M
