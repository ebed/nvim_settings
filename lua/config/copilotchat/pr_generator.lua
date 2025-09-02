local M = {}
local CopilotChat = require("CopilotChat")
local split_buf = nil
local split_win = nil

-- Show logs or info in a reusable bottom split window
function M.show_in_bottom_split(lines, bufname)
  bufname = bufname or "CopilotChatLog"
  -- Create or reuse buffer
  if not split_buf or not vim.api.nvim_buf_is_valid(split_buf) then
    split_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(split_buf, bufname) 
    vim.bo[split_buf].filetype = "copilotchatlog"
    vim.bo[split_buf].buftype = "nofile"
    vim.bo[split_buf].bufhidden = "wipe"
    vim.bo[split_buf].swapfile = false
  end
  vim.api.nvim_buf_set_lines(split_buf, 0, -1, false, lines)
  -- Create or reuse window
  if not split_win or not vim.api.nvim_win_is_valid(split_win) then
    vim.cmd("botright split")
    split_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(split_win, split_buf)
  else
    vim.api.nvim_win_set_buf(split_win, split_buf)
  end
end

-- Close the split window if open
function M.close_split()
  if split_win and vim.api.nvim_win_is_valid(split_win) then
    vim.api.nvim_win_close(split_win, true)
    split_win = nil
  end
end

-- Run a shell command and show its output in a reusable bottom split, close on exit
function M.run_cmd_in_split(cmd, args, bufname, on_exit)
  bufname = bufname or "CopilotChatCmd"
  local lines = {}
  local function on_output(_, data, _)
    if data then
      for _, line in ipairs(data) do
        if line ~= "" then
          table.insert(lines, line)
        end
      end
      M.show_in_bottom_split(lines, bufname)
    end
  end

  local job_id = vim.fn.jobstart({cmd, unpack(args or {})}, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = on_output,
    on_stderr = on_output,
    on_exit = function(_, code, _)
      -- Close split after command finishes
      vim.schedule(function()
        M.close_split()
        if on_exit then on_exit(code) end
      end)
    end,
  })
  return job_id
end

-- Example: Show a log message
function M.log_message(msg)
  M.show_in_bottom_split(vim.split(msg, "\n"), "CopilotChatLog")
end

-- Get PR description if exists
function M.get_pr_description()
  local handle = io.popen('gh pr view --json body --jq .body 2>/dev/null')
  local desc = handle:read("*a")
  handle:close()
  if desc == "" or desc:match("not found") then
    return nil
  end
  return desc
end

function M.get_default_branch()
  local handle = io.popen("git remote show origin | grep 'HEAD branch' | awk '{print $3}'")
  local branch = handle:read("*a")
  handle:close()
  branch = branch and branch:gsub("%s+", "")
  if branch == "" then
    branch = "main" -- fallback
  end
  return branch
end
-- Get diff with origin/main
function M.get_diff()

  local base = M.get_default_branch()
  print(base)
  local diff_cmd = string.format("git diff origin/%s...HEAD", base)
  local handle = io.popen(diff_cmd)
  local diff = handle:read("*a")
  handle:close()
  return diff or ""
end

-- Generate a PR title using CopilotChat, including ticket if present, max 60 chars, no extra text
function M.generate_pr_title(callback)
  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  local ticket = branch:match("([A-Z]+%-%d+)")
  local diff = M.get_diff()
  local prompt = "Generate a concise, clear Pull Request title (max 60 characters, no extra text, no headings, just the title itself)."
  if ticket then
    prompt = prompt .. " The branch is associated with ticket " .. ticket .. ". Include the ticket in the title like TICKET - name"
  end
  prompt = prompt .. "\n\nDiff:\n" .. diff

  vim.notify("Generating PR title with CopilotChat...", vim.log.levels.INFO)
  CopilotChat.ask(prompt, {
    headless = true,
    callback = function(response)
      local title = response.content or response
      vim.notify("PR title generated.", vim.log.levels.INFO)
      if callback then
        callback(title)
      end
    end
  })
end

-- Push branch and show output in split
function M.push_branch(branch, on_exit)
  M.run_cmd_in_split("git", {"push", "-u", "origin", branch}, "GitPushOutput", on_exit)
end

-- Ensure PR exists for the current branch, pushing if needed, and generate title with CopilotChat
function M.ensure_pr_exists_with_ai_title(callback)
  local desc = M.get_pr_description()
  if desc ~= nil then
    if callback then callback(true) end
    return
  end

  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  local remote_check = os.execute("git ls-remote --exit-code --heads origin " .. branch .. " > /dev/null 2>&1")
  local function after_push(push_code)
    if push_code ~= 0 then
      vim.notify("Failed to push branch to remote.", vim.log.levels.ERROR)
      if callback then callback(false) end
      return
    end
    -- Generate PR title with CopilotChat
    M.generate_pr_title(function(title)
      local base = "main"
      M.run_cmd_in_split("gh", {"pr", "create", "--base", base, "--title", title, "--body", "Initial PR"}, "GhPrCreateOutput", function(pr_code)
        if pr_code ~= 0 then
          vim.notify("Failed to create PR", vim.log.levels.ERROR)
          if callback then callback(false) end
          return
        end
        vim.notify("PR created successfully.")
        if callback then callback(true) end
      end)
    end)
  end

  if remote_check ~= 0 then
    M.push_branch(branch, after_push)
  else
    after_push(0)
  end
end

-- Ensure PR exists for the current branch, pushing if needed (manual title)
function M.ensure_pr_exists(callback)
  local desc = M.get_pr_description()
  if desc ~= nil then
    if callback then callback(true) end
    return
  end

  local branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):gsub("%s+", "")
  local remote_check = os.execute("git ls-remote --exit-code --heads origin " .. branch .. " > /dev/null 2>&1")
  local function after_push(push_code)
    if push_code ~= 0 then
      vim.notify("Failed to push branch to remote.", vim.log.levels.ERROR)
      if callback then callback(false) end
      return
    end
    local title = vim.fn.input("Enter PR title: ")
    local base = "main"
    M.run_cmd_in_split("gh", {"pr", "create", "--base", base, "--title", title, "--body", "Initial PR"}, "GhPrCreateOutput", function(pr_code)
      if pr_code ~= 0 then
        vim.notify("Failed to create PR", vim.log.levels.ERROR)
        if callback then callback(false) end
        return
      end
      vim.notify("PR created successfully.")
      if callback then callback(true) end
    end)
  end

  if remote_check ~= 0 then
    M.push_branch(branch, after_push)
  else
    after_push(0)
  end
end

-- Update PR description using gh pr edit and show output in split
function M.update_pr_description(new_desc)
  -- Save the new description to a temp file
  local tmpfile = "/tmp/pr_desc_update.txt"
  local f = io.open(tmpfile, "w")
  f:write(new_desc)
  f:close()
  -- Update the PR using gh
  M.run_cmd_in_split("gh", {"pr", "edit", "--body-file", tmpfile}, "GhPrEditOutput")
end

-- Main flow: enhance PR description with CopilotChat (silent, no window)
function M.enhance_pr_description()
  vim.notify("Enhancing PR description with CopilotChat...", vim.log.levels.INFO)
  M.ensure_pr_exists_with_ai_title(function(success)
    if not success then
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
- Mejora la descripción del PR actual agregando contexto relevante, pero manteniendo lo existente a menos que sea algo que ya no aplica.
- Devuelve el texto completo de la nueva descripción, listo para reemplazar el cuerpo del PR.
- Si hay elementos que no aplican ya en el PR, eliminalos de la descripcion.
No incluyas encabezados ni texto adicional, solo la nueva descripción.

Descripción actual:
]] .. old_desc .. [[

Cambios recientes:
]] .. diff

    CopilotChat.ask(prompt, {
      headless = true,
      callback = function(response)
        local new_desc = response.content or response
        M.update_pr_description(new_desc)
        vim.notify("Descripción del PR actualizada con éxito.", vim.log.levels.INFO)
      end
    })
  end)
end

return M
