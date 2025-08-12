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

function M.get_context_dir()
  return vim.fn.expand("~/.copilotchat-contexts/")
end

function M.get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ':t')
end

function M.get_current_branch()
  local handle = io.popen("git rev-parse --abbrev-ref HEAD")
  local branch = handle:read("*a"):gsub("%s+", "")
  handle:close()
  return branch
end

-- Switch to branch (create if doesn't exist)
function M.switch_or_create_branch(branch_name)
  local current = M.get_current_branch()
  if current == branch_name then return end
  -- Try to checkout, if fails, create
  local checkout = os.execute(string.format("git checkout %q", branch_name))
  if checkout ~= 0 then
    os.execute(string.format("git checkout -b %q", branch_name))
  end
end

function M.get_git_diff()
  -- Get git diff as string
  local handle = io.popen("git diff")
  local result = handle:read("*a")
  handle:close()
  return result
end

function M.load_template(filename)
  local path = vim.fn.stdpath("config") .. "/lua/config/copilotchat/templates/" .. filename
  local file = io.open(path, "r")
  if not file then return "" end
  local content = file:read("*a")
  file:close()
  return content
end

function M.llm_call(prompt)
  -- Aquí deberías implementar la llamada al LLM (OpenAI, CopilotChat, etc.)
  -- Por ahora, solo retorna el prompt para pruebas
  return prompt
end

function M.git_add_commit_push(message)
  -- Ejecuta comandos git (add, commit, push) usando el mensaje
  os.execute("git add .")
  os.execute(string.format("git commit -m %q", message))
  os.execute("git push")
end

function M.create_pull_request(message)
  -- Aquí podrías usar la CLI de GitHub o una integración con la API
  -- Por ejemplo, usando gh CLI:
  os.execute(string.format("gh pr create --title 'Auto PR' --body %q", message))
end




return M

