-- Context-related functions for CopilotChat
local utils = require("config.copilotchat.utils")
local CopilotChat = require("CopilotChat")
local M = {}

-- Load previously saved synthesis into current buffer (plain insert)
function M.load_context_as_prompt()
  local context_dir = utils.get_context_dir()
  local context_path = context_dir .. utils.get_project_name() .. "_synthesis.md"
  if vim.fn.filereadable(context_path) == 1 then
    local lines = {}
    for line in io.lines(context_path) do
      table.insert(lines, line)
    end
    vim.api.nvim_put(lines, "c", true, true)
    vim.notify("Contexto de CopilotChat cargado desde: " .. context_path)
  else
    vim.notify("No existe síntesis previa para el proyecto.", vim.log.levels.WARN)
  end
end

-- Read or (if missing) generate a global context
function M.get_global_context()
  local global_path = utils.get_context_dir() .. "_global.md"
  local f = io.open(global_path, "r")
  if f then
    local content = f:read("*a")
    f:close()
    return content or ""
  end

  -- If not exists, request generation asynchronously
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
Responde exclusivamente en español a menos que el usuario pida explícitamente otro idioma.

]]
  CopilotChat.ask(prompt, {
    callback = function(response)
      local content = (response and response.content) or response or ""
      local f2 = io.open(global_path, "w")
      if f2 then
        f2:write(content)
        f2:close()
        vim.notify("Contexto global generado y guardado en: " .. global_path)
      end
    end,
  })
  vim.notify("Generando contexto global, reintenta el comando luego.")
  return nil
end

-- Project context (initial analysis)
function M.project_context_prompt()
  local project_name = utils.get_project_name()
  local context_dir = utils.get_context_dir()
  CopilotChat.open()
  vim.defer_fn(function()
    local buf = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    if #lines <= 3 and lines[1] and lines[1]:match("^👤 Usuario: ") then
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
Responde exclusivamente en español a menos que el usuario pida explícitamente otro idioma.
]]
      end
      CopilotChat.ask(prompt)
      vim.notify("Contexto inicial insertado en CopilotChat.")
    else
      vim.notify("Buffer de chat ya contiene contenido, no se sobrescribe.", vim.log.levels.INFO)
    end
  end, 100)
end

-- Extract ticket name from branch (e.g., feature/PD-1234-foo)
function M.extract_ticket_name()
  local branch = M.get_current_branch()
  local project_name = utils.get_project_name()
  if not branch or branch == "" then
    return project_name
  end
  local ticket = branch:match("([A-Z]+%-%d+)")
  if ticket and ticket ~= "" then
    return ticket
  end
  return project_name .. "-" .. branch:sub(1, 8)
end

function M.get_current_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD 2>/dev/null")
  if not handle then return nil end
  local branch = handle:read("*a") or ""
  handle:close()
  return (branch:gsub("%s+", ""))
end

function M.get_requirement_from_commit()
  local handle = io.popen("git log -1 --pretty=%B 2>/dev/null")
  if not handle then return nil end
  local msg = handle:read("*a") or ""
  handle:close()
  return (msg:gsub("^%s+", ""):gsub("%s+$", ""))
end

function M.get_jira_link(ticket)
  return "https://pagerduty.atlassian.net/browse/" .. ticket
end

-- Read requirement file or prompt user to create it
function M.get_or_ask_requirement(ticket)
  local context_dir = utils.get_context_dir()
  local req_path = context_dir .. ticket .. "_requirement.txt"
  local f = io.open(req_path, "r")
  if f then
    local content = f:read("*a") or ""
    f:close()
    if content ~= "" then
      return content
    end
  end

  -- File does not exist or empty: open split for user to paste
  local jira_link = M.get_jira_link(ticket)
  vim.fn.jobstart({ "open", jira_link }, { detach = true })
  vim.notify(
    "Pega el requerimiento de Jira en el nuevo buffer y guarda: " .. jira_link,
    vim.log.levels.INFO
  )
  vim.cmd("vsplit " .. req_path)
  vim.cmd("redraw")
  vim.cmd("echo 'Guarda el archivo y re-ejecuta :CopilotTickets'")
  return nil
end

function M.save_synthesis(ticket, content)
  local context_dir = utils.get_context_dir()
  local path = context_dir .. ticket .. "_synthesis.md"
  local f = io.open(path, "w")
  if not f then
    vim.notify("No se pudo guardar síntesis en: " .. path, vim.log.levels.ERROR)
    return
  end
  f:write(content)
  f:close()
end

function M.get_ticket_context(ticket)
  local context_dir = utils.get_context_dir()
  local synth_path = context_dir .. ticket .. "_synthesis.md"
  local f = io.open(synth_path, "r")
  if f then
    local content = f:read("*a") or ""
    f:close()
    if content ~= "" then
      return content
    end
  end
  return nil
end

-- Main ticket synthesis command
function M.ticket_context_prompt()
  local branch = M.get_current_branch()
  local ticket = M.extract_ticket_name()
  if not ticket then
    vim.notify("No se pudo identificar el ticket (rama: " .. (branch or "?") .. ")", vim.log.levels.ERROR)
    return
  end

  local existing = M.get_ticket_context(ticket)
  if existing then
    CopilotChat.open()
    CopilotChat.ask(existing)
    vim.notify("Contexto del ticket cargado (reutilizado).")
    return
  end

  local requirement = M.get_or_ask_requirement(ticket)
  if not requirement then
    -- User must paste requirement first
    return
  end

  local diff = M.get_diff_for_ticket()
  local global_context = M.get_global_context()
  if not global_context or global_context == "" then
    vim.notify("Esperando generación de contexto global. Reintenta luego.", vim.log.levels.WARN)
    return
  end

  local jira_link = M.get_jira_link(ticket)

  local synthesis = string.format([[
%s

# Ticket: %s

- **Rama:** %s
- **Requerimiento:** %s
- **Enlace a Jira:** %s

## Cambios en esta rama

%s

---

Es importante que definas una lista de tareas para ordenar el trabajo del ticket e ir registrando avances.
Cada vez que avances, indica qué tareas se cerraron. Si envías nuevamente la lista, se actualizará.
Mantén las tareas como lista con checks, número, título y breve descripción.

Este contexto se mantendrá abierto hasta que la rama sea mergeada a main.
Responde exclusivamente en español a menos que el usuario pida explícitamente otro idioma.
]], global_context, ticket, branch or "?", requirement, jira_link, diff ~= "" and diff or "(Sin cambios detectados)")

  M.save_synthesis(ticket, synthesis)
  vim.notify("Síntesis de ticket guardada.")
  CopilotChat.open()
  CopilotChat.ask(synthesis)
end

function M.get_diff_for_ticket()
  -- Return a concise name-status diff; fallback to main if origin/main unavailable
  local cmd = "git diff --name-status origin/main..HEAD 2>/dev/null"
  local handle = io.popen(cmd)
  if not handle then return "" end
  local diff = handle:read("*a") or ""
  handle:close()
  return diff
end

function M.enrich_and_save_prompt(ticket, req_path, synth_path, extra_info)
  local f = io.open(req_path, "r")
  local requirement = f and (f:read("*a") or "") or ""
  if f then f:close() end

  local branch = M.get_current_branch()
  local jira_link = M.get_jira_link(ticket)
  local global_context = M.get_global_context() or ""
  local diff = M.get_diff_for_ticket()

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
(Esta síntesis se actualizará; mantén la lista de tareas numerada con checks.)
]], global_context, ticket, branch or "?", jira_link, requirement ~= "" and requirement or "(Pendiente)", diff, extra_info.tasks or "", extra_info.issues or "")

  local f2 = io.open(synth_path, "w")
  if f2 then
    f2:write(prompt)
    f2:close()
  else
    vim.notify("No se pudo escribir síntesis enriquecida.", vim.log.levels.ERROR)
  end
end

function M.on_buf_leave(args)
  local ticket = M.extract_ticket_name()
  local context_dir = utils.get_context_dir()
  local req_path = context_dir .. ticket .. "_requirement.txt"
  local synth_path = context_dir .. ticket .. "_synthesis.md"
  local buf = args.buf
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  vim.ui.select(
    { "Sí", "No" },
    { prompt = "¿Sintetizar y guardar requerimiento/ticket?" },
    function(choice)
      if choice == "Sí" then
        M.enrich_and_save_prompt(ticket, req_path, synth_path, { tasks = "", issues = "" })
        vim.notify("Prompt enriquecido guardado para " .. ticket)
      end
    end
  )
end

return M
