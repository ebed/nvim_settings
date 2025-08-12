
local M = {}

function M.get_project_name()
  local cwd = vim.fn.getcwd()
  return vim.fn.fnamemodify(cwd, ':t')
end

function M.load_context_as_prompt()
  local context_dir = vim.fn.expand("~/.copilotchat-contexts/")
  local context_path = context_dir .. get_project_name() .. "_synthesis.md"
  if vim.fn.filereadable(context_path) == 1 then
    local lines = {}
    for line in io.lines(context_path) do
      table.insert(lines, line)
    end
    -- Inserta el contexto como prompt en el buffer de CopilotChat
    vim.api.nvim_put(lines, 'c', true, true)
    print("Contexto de CopilotChat cargado como prompt desde: " .. context_path)
  else
    print("No existe contexto guardado para este proyecto.")
  end
end
-- Prompt de síntesis
--

-- Automatización usando la API de CopilotChat.nvim
local CopilotChat = require("CopilotChat")

function M.synthesize_and_save_api()
  local prompt = [[
Por favor, sintetiza el contexto actual del proyecto, incluyendo:
- Stack tecnológico principal
- Dependencias clave
- Estructura general
- Áreas de mejora y recomendaciones
- Buenas prácticas relevantes
]]
  CopilotChat.ask(prompt, {
    callback = function(response)
      local context_dir = vim.fn.expand("~/.copilotchat-contexts/")
      vim.fn.mkdir(context_dir, "p")
      local context_path = context_dir .. M.get_project_name() .. "_synthesis.md"
      local file, err = io.open(context_path, "w")
      if not file then
        vim.notify("Error al abrir el archivo: " .. err, vim.log.levels.ERROR)
        return
      end
      file:write(response)
      file:close()
      vim.notify("Síntesis de CopilotChat guardada en: " .. context_path, vim.log.levels.INFO)
    end
  })
end

vim.api.nvim_create_autocmd("BufWipeout", {
  pattern = "*copilot-chat*",
  callback = function()
    synthesize_and_save_api()
  end,
})
```

return M
