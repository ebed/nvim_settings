-- Context-related functions for CopilotChatcopiconte
local utils = require("config.copilotchat.utils")
local CopilotChat = require("CopilotChat") -- Import required module
local M = {}



       function M.load_context_as_prompt()
        local context_path = context_dir .. get_project_name() .. "_synthesis.md"
        if vim.fn.filereadable(context_path) == 1 then
          local lines = {}
          for line in io.lines(context_path) do
            table.insert(lines, line)
          end
          vim.api.nvim_put(lines, 'c', true, true)
          vim.notify("Contexto de CopilotChat cargado desde: " .. context_path)
        end
      end

function M.get_global_context()
  local global_path = utils.get_context_dir() .. "_global.md"
  local f = io.open(global_path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content or ""
  end
  -- Si no existe, genera el contexto global
  local prompt = [[
Analiza el proyecto detectando automáticamente el stack tecnológico principal según los archivos presentes: ##files://glob/**.*

- Si detectas más de un stack, pregunta cuál debe usarse.
- Incluye patrones de archivos relevantes, archivos de infraestructura y contenedores si existen.
- Considera los cambios en el branch actual: ##git://diff/main..HEAD.
- Si necesitas más información, solicita la estructura del proyecto o acceso a archivos específicos.

Proporciona:
- Resumen del propósito del proyecto
- Estructura general y organización de componentes
- Áreas de mejora en arquitectura, código y buenas prácticas
- Análisis de dependencias y recomendaciones
- Sugerencias para documentación y contexto
- Recomendaciones de CI/CD (por ejemplo: Buildkite, CircleCI)
- Mejores prácticas de seguridad y rendimiento
- Otros aspectos relevantes

Mantén este contexto para futuras consultas.
]]
  -- Llama a CopilotChat y guarda la respuesta como contexto global
  CopilotChat.ask(prompt, {
    callback = function(response)
      local content = response.content or response
      local f2 = io.open(global_path, "w")
      if f2 then
        f2:write(content)
        f2:close()
        vim.notify("Contexto global generado y guardado en: " .. global_path)
      end
    end
  })
  -- Informa al usuario que debe reintentar tras generar el contexto
  vim.notify("Generando contexto global, por favor reintenta el comando en unos segundos.")
  return nil
end
      -- Prompt inicial para análisis de contexto de proyecto
      function M.project_context_prompt()
        local project_name = utils.get_project_name() -- Correct usage
        local context_dir = utils.get_context_dir() -- Correct usage
        CopilotChat.open()
        vim.defer_fn(function()
          local buf = vim.api.nvim_get_current_buf()
          local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
          -- Si el buffer está en estado inicial, inserta el prompt
          if #lines <= 3 and lines[1]:match("^👤 Usuario: ") then
            local context_path = context_dir .. project_name .. "_synthesis.md"
            local prompt
            if vim.fn.filereadable(context_path) == 1 then
              local file_lines = {}
              for line in io.lines(context_path) do
                table.insert(file_lines, line)
              end
              prompt = table.concat(file_lines, "\n")
            else
              prompt = [[
                  Analiza el proyecto detectando automáticamente el stack tecnológico principal según los archivos presentes: ##files://glob/**.*

                  - Si detectas más de un stack, pregunta cuál debe usarse.
                  - Incluye patrones de archivos relevantes, archivos de infraestructura y contenedores si existen.
                  - Considera los cambios en el branch actual: ##git://diff/main..HEAD.
                  - Si necesitas más información, solicita la estructura del proyecto o acceso a archivos específicos.

                  Proporciona:
                  - Resumen del propósito del proyecto
                  - Estructura general y organización de componentes
                  - Áreas de mejora en arquitectura, código y buenas prácticas
                  - Análisis de dependencias y recomendaciones
                  - Sugerencias para documentación y contexto
                  - Recomendaciones de CI/CD (por ejemplo: Buildkite, CircleCI)
                  - Mejores prácticas de seguridad y rendimiento
                  - Otros aspectos relevantes

                  Mantén este contexto para futuras consultas.
              ]]
            end
            CopilotChat.ask(prompt)
            vim.notify("Contexto inicial insertado en CopilotChat.")
          else
            vim.notify("Ya existe contexto en el chat, no se sobrescribe.")
          end
        end, 100)
      end

-- Extrae el ticket del nombre de la rama (ej: feature/PD-1234-foo)
function M.extract_ticket_from_branch(branch)
  local ticket = branch:match("([A-Z]+%-%d+)")
  return ticket
end

-- Obtiene el nombre de la rama actual
function M.get_current_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD")
  if not handle then return nil end
  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return branch
end

-- Obtiene el requerimiento desde el último commit (puedes mejorar esto)
function M.get_requirement_from_commit()
  local handle = io.popen("git log -1 --pretty=%B")
  if not handle then return nil end
  local msg = handle:read("*a"):gsub("^%s+", ""):gsub("%s+$", "")
  handle:close()
  return msg
end

-- Genera el enlace a Jira
function M.get_jira_link(ticket)
  return "https://pagerduty.atlassian.net/browse/" .. ticket
end

function M.get_or_ask_requirement(ticket)
  local context_dir = utils.get_context_dir()
  local req_path = context_dir .. ticket .. "_requirement.txt"
  -- Si ya existe, lo lee
  local f = io.open(req_path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  local jira_link = get_jira_link(ticket)

vim.fn.jobstart({ "open", jira_link }, { detach = true })
  -- Si no existe, solicita al usuario que lo pegue
  vim.notify("Pega el requerimiento completo de Jira para el ticket " .. ticket .. " en el buffer actual y guarda el archivo: " ..  jira_link )
  vim.cmd("vsplit " .. req_path)

  -- Espera a que el usuario lo pegue y guarde, luego lo lee
  vim.cmd("redraw")
  vim.cmd("echo 'Guarda el archivo cuando termines de pegar el requerimiento.'")
  -- El flujo puede esperar a que el usuario confirme, o puedes pedirle que ejecute de nuevo el comando
  return nil
end
-- Guarda la síntesis en un archivo por ticket
function M.save_synthesis(ticket, content)
  local context_dir = utils.get_context_dir()
  local path = context_dir .. ticket .. "_synthesis.md"
  local f = io.open(path, "w")
  if f then
    f:write(content)
    f:close()
  end
end


-- -- Lee el contexto general guardado
-- function M.get_global_context()
--   local f = io.open(utils.get_context_dir() .. "_global.md", "r")
--   if not f then return "" end
--   local content = f:read("*a")
--   f:close()
--   return content or ""
-- end

function M.get_ticket_context(ticket)
  local context_dir = utils.get_context_dir()
  local synth_path = context_dir .. ticket .. "_synthesis.md"
  local f = io.open(synth_path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content
  end
  return nil
end

-- Función principal para generar síntesis de ticket
function M.ticket_context_prompt()
  local branch = M.get_current_branch()
  local ticket = M.extract_ticket_from_branch(branch)
  if not ticket then
    vim.notify("No se pudo identificar el ticket en la rama: " .. branch)
    return
  end
  local ticket_context = M.get_ticket_context(ticket)
  if ticket_context then
    -- Usa el contexto del ticket existente
    CopilotChat.open()
    CopilotChat.ask(ticket_context)
    local context_dir = utils.get_context_dir()
    local synth_path = context_dir .. ticket .. "_synthesis.md"
    vim.notify("Contexto del ticket cargado desde: " .. synth_path)
    return
  end
local requirement = M.get_or_ask_requirement(ticket)
if not requirement then
  vim.notify("Reintenta el comando después de guardar el requerimiento.")
  return
end
  local jira_link = M.get_jira_link(ticket)
  local context_dir = utils.get_context_dir()

  -- Puedes agregar aquí lógica para obtener diff, archivos cambiados, etc.
  local diff_handle = io.popen("git diff --name-status origin/main..HEAD")
  local diff = diff_handle and diff_handle:read("*a") or ""
  if diff_handle then diff_handle:close() end

local global_context = M.get_global_context()
if not global_context or global_context == "" then
  return -- Espera a que se genere el contexto global antes de continuar
end
  local synthesis = string.format([[
%s

# Ticket: %s

- **Rama:** %s
- **Requerimiento:** %s
- **Enlace a Jira:** %s

## Cambios en esta rama

%s

---

Es importante que definas una lista de tareas para ordenar el trabajo del ticket e ir registrando avances,
y cada vez que se avance, identifique que tareas fueron cerradas. Si se envia una lista, esta se actualizará con 
la informacion actualizada. 

**Este contexto se mantendrá abierto hasta que la rama sea mergeada a main.**
]], global_context, ticket, branch, requirement, jira_link, diff)

  M.save_synthesis(ticket, synthesis)
  vim.notify("Síntesis de ticket guardada en: " .. context_dir .. ticket .. "_synthesis.md")

  -- Opcional: abrir CopilotChat con este contexto
  CopilotChat.open()
  CopilotChat.ask(synthesis)
end


function M.enrich_and_save_prompt(ticket, req_path, synth_path, extra_info)

  -- Lee el requerimiento actualizado
  --
  local f = io.open(req_path, "r")
  local requirement = f and f:read("*a") or ""
  if f then f:close() end

  -- Obtén otros datos relevantes
  local branch = M.get_current_branch()
  local jira_link = M.get_jira_link(ticket)
  local global_context = M.get_global_context()
  local diff = M.get_diff_for_ticket(ticket)

  -- Construye el prompt enriquecido
  local prompt = string.format([[
%s

# Ticket: %s

- **Rama:** %s
- **Enlace a Jira:** %s

## Requerimiento
%s

## Cambios en esta rama
%s

## Tareas pendientes
%s

## Problemas por solucionar
%s

---
Es importante que definas una lista de tareas para ordenar el trabajo del ticket e ir registrando avances,
y cada vez que se avance, identifique que tareas fueron cerradas. Si se envia una lista, esta se actualizará con 
la informacion actualizada. 
Este contexto se mantendrá abierto hasta que la rama sea mergeada a main.
]], global_context, ticket, branch, jira_link, requirement, diff, extra_info.tasks or "", extra_info.issues or "")

  -- Guarda el prompt enriquecido
  local f2 = io.open(synth_path, "w")
  if f2 then
    f2:write(prompt)
    f2:close()
  end
end




function M.on_buf_leave(args)
    local branch = get_current_branch()
    local ticket = extract_ticket_from_branch(branch)
    local context_dir = utils.get_context_dir()
    local req_path = context_dir .. ticket .. "_requirement.txt"
    local synth_path = context_dir .. ticket .. "_synthesis.md"
    local buf = args.buf
    if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
    vim.ui.select(
      { "Sí", "No" },
      { prompt = "¿Deseas sintetizar y guardar el contexto del Requerimiento de CopilotChat?" },
      function(choice)
        if choice == "Sí" then
          M.enrich_and_save_prompt(ticket, req_path, synth_path, {tasks = "", issues = ""})
          vim.notify("Prompt enriquecido y guardado para el ticket " .. ticket)
        end
      end
    )
  end
return M

