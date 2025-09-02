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


function M.get_multiline_input(prompt)
  -- Create a new scratch buffer
  local buf = vim.api.nvim_create_buf(false, true)
  -- Set buffer lines with prompt
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, { prompt, "", "-- Write your requirement below. Close buffer when done. --" })
  -- Open floating window
  local width = math.floor(vim.o.columns * 0.6)
  local height = 8
  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
  })
  -- Wait for user to close the window
  vim.cmd("startinsert")
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":bd!<CR>", { noremap = true, silent = true })
  -- Block until buffer is closed
  vim.wait(100000, function()
    return not vim.api.nvim_win_is_valid(win)
  end)
  -- Get lines (excluding prompt and instructions)
  local lines = vim.api.nvim_buf_get_lines(buf, 1, -1, false)
  return table.concat(lines, "\n")
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

function M.get_git_diff_main_head()
  local handle = io.popen("git diff main..HEAD")
  local diff = handle:read("*a")
  handle:close()
  return diff
end

function M.load_template(filename)
  local path = vim.fn.stdpath("config") .. "/lua/config/copilotchat/templates/" .. filename
  local file = io.open(path, "r")
  if not file then return "" end
  local content = file:read("*a")
  file:close()
  return content
end


function M.git_add_commit_push(message)
  local log = {}

  -- Run git add
  local handle_add = io.popen("git add . 2>&1")
  table.insert(log, "=== git add . ===")
  table.insert(log, handle_add:read("*a"))
  handle_add:close()

  -- Run git commit
  local handle_commit = io.popen(string.format("git commit -m %q 2>&1", message))
  table.insert(log, "=== git commit ===")
  table.insert(log, handle_commit:read("*a"))
  handle_commit:close()

  -- Run git push
  local handle_push = io.popen("git push 2>&1")
  table.insert(log, "=== git push ===")
  table.insert(log, handle_push:read("*a"))
  handle_push:close()

  -- Show all logs in panel
  M.show_log_in_panel(table.concat(log, "\n"))
end

function M.create_pull_request(message)
  local log = {}

  -- Run gh pr create
  local cmd = string.format("gh pr create --title 'Auto PR' --body %q 2>&1", message)
  local handle_pr = io.popen(cmd)
  table.insert(log, "=== gh pr create ===")
  table.insert(log, handle_pr:read("*a"))
  handle_pr:close()

  -- Show PR creation log in panel
  M.show_log_in_panel(table.concat(log, "\n"))
end


function M.show_log_in_panel(log_text)
  -- Create or reuse a buffer for the log panel
  local buf_name = "CopilotChatLog"
  local buf = nil
  -- Try to find existing buffer
  for _, b in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_get_name(b) == buf_name then
      buf = b
      break
    end
  end
  -- If not found, create new buffer
  if not buf then
    buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(buf, buf_name)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.api.nvim_buf_set_option(buf, "readonly", true)
  end
  -- Set log text
  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(log_text, "\n"))
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  -- Open split below and set buffer
  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":close<CR>", { noremap = true, silent = true })
  vim.cmd("resize 15")
end


return M

