local CopilotChat = require("CopilotChat")

-- Activar/desactivar log
local enable_log = true
local function log(msg)
  if not enable_log then return end
  local f = io.open("/tmp/nvim_doc_changes.log", "a")
  f:write(msg .. "\n")
  f:close()
end

-- Extrae el primer bloque /** ... */ de un string
local function extract_java_docblock(text)
  local docblock = {}
  local in_block = false
  for line in text:gmatch("[^\r\n]+") do
    if not in_block and line:match("^%s*/%*%*") then
      in_block = true
    end
    if in_block then
      table.insert(docblock, line)
      if line:match("%*/") then
        break
      end
    end
  end
  return #docblock > 0 and table.concat(docblock, "\n") or nil
end

-- Reemplaza o inserta el bloque de documentación en el buffer
local function replace_or_insert_doc(bufnr, new_doc)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local start_idx, end_idx = nil, nil

  -- Busca el primer bloque /** ... */
  for i, line in ipairs(lines) do
    if not start_idx and line:match("^%s*/%*%*") then
      start_idx = i
    end
    if start_idx and line:match("%*/") then
      end_idx = i
      break
    end
  end

  if start_idx and end_idx then
    -- Reemplaza el bloque existente
    vim.api.nvim_buf_set_lines(bufnr, start_idx-1, end_idx, false, vim.split(new_doc, "\n"))
  else
    -- Inserta al inicio si no hay bloque
    vim.api.nvim_buf_set_lines(bufnr, 0, 0, false, vim.split(new_doc, "\n"))
  end
end

-- Guarda el archivo asegurando que el buffer esté correctamente cargado y visible
local function update_and_save_file(file, docblock)
  local bufnr = vim.fn.bufnr(file, true)
  if bufnr == -1 then
    log("Buffer not found for file: " .. file)
    return
  end

  -- Abre el archivo en un split temporal
  vim.cmd("botright split " .. file)
  local win = vim.api.nvim_get_current_win()

  replace_or_insert_doc(bufnr, docblock)
  vim.cmd("write")

  -- Cierra el split temporal
  vim.api.nvim_win_close(win, true)
end

-- Serialización de tareas
local function process_files_serially(files, idx)
  idx = idx or 1
  if idx > #files then
    log("All files processed.")
    return
  end
  local file = files[idx]
  local diff_handle = io.popen("git diff origin/main..HEAD " .. file)
  local diff = diff_handle:read("*a")
  diff_handle:close()
  if diff == "" then
    log("No diff for file: " .. file)
    process_files_serially(files, idx + 1)
    return
  end
  -- Detect language and doc style
  local function get_doc_instructions(file)
    local ext = file:match("^.+(%..+)$")
    if ext == ".java" then
      return "Use JavaDoc format (/** ... */) for classes, methods, and functions."
    elseif ext == ".ex" or ext == ".exs" then
      return "Use Elixir @doc or @moduledoc attributes for modules and functions."
    elseif ext == ".rb" then
      return "Use YARD format (# @param, # @return, etc.) as Ruby documentation above methods and classes."
    elseif ext == ".dockerfile" or file:lower():find("dockerfile") then
      return "Use comments (# ...) to document each Docker instruction changed."
    else
      return "Use the standard documentation comment format for this language."
    end
 end
 local doc_instructions = get_doc_instructions(file)
 local prompt = "For the following changes in " .. file .. ":\n" ..
   "- " .. doc_instructions .. "\n" ..
   "- Place the documentation immediately above the class, method, or function definition (never above the package statement).\n" ..
   "- Do not include any code, file paths, or markdown code blocks.\n" ..
   "- Return only the documentation comments, nothing else.\n\n" .. diff
  log("Prompt for file: " .. file)
  log(prompt)
  CopilotChat.ask(prompt, {
    callback = function(response)
      log("CopilotChat callback executed for file: " .. file)
      log("Type of response: " .. type(response))
      log("Response content: " .. vim.inspect(response))
      local doc = response.content or response
      if type(doc) ~= "string" then
        log("ERROR: CopilotChat response is not a string for file: " .. file)
        process_files_serially(files, idx + 1)
        return
      end
      local docblock = extract_java_docblock(doc) or doc
      if not docblock then
        log("No docblock found in CopilotChat response for file: " .. file)
        process_files_serially(files, idx + 1)
        return
      end
      update_and_save_file(file, docblock)
      log("Documentation inserted/replaced and file saved: " .. file)
      -- Procesa el siguiente archivo al terminar este
      process_files_serially(files, idx + 1)
    end
  })
end

local function get_modified_files()
  local handle = io.popen("git diff --name-only origin/main..HEAD")
  if not handle then
    log("Failed to run git diff")
    return {}
  end
  local result = handle:read("*a")
  handle:close()
  local files = {}
  for file in result:gmatch("[^\r\n]+") do
    table.insert(files, file)
  end
  return files
end
-- Para todos los archivos modificados:
local function document_all_modified_files_serial()
  local files = get_modified_files()
  process_files_serially(files, 1)
end

-- Para solo los buffers abiertos:
local function document_modified_buffers_serial()
  local modified_files = {}
  for _, file in ipairs(get_modified_files()) do
    modified_files[file] = true
  end
  local files = {}
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.api.nvim_buf_get_option(bufnr, "buflisted") then
      local abs_path = vim.api.nvim_buf_get_name(bufnr)
      if abs_path ~= "" then
        local rel_path = vim.fn.fnamemodify(abs_path, ":.")
        if modified_files[rel_path] then
          table.insert(files, rel_path)
        end
      end
    end
  end
  process_files_serially(files, 1)
end

vim.api.nvim_create_user_command("CopilotDocAllChangesSerial", document_all_modified_files_serial, {})
vim.api.nvim_create_user_command("CopilotDocBufferChangesSerial", document_modified_buffers_serial, {})

-- Comandos de usuario
-- vim.api.nvim_create_user_command("CopilotDocAllChanges", document_all_modified_files, {})
-- vim.api.nvim_create_user_command("CopilotDocBufferChanges", document_modified_buffers, {})
vim.api.nvim_create_user_command("CopilotDocLogOn", function() enable_log = true end, {})
vim.api.nvim_create_user_command("CopilotDocLogOff", function() enable_log = false end, {})
