return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "main",
    dependencies = {
      "github/copilot.vim",
      { "nvim-lua/plenary.nvim", branch = "master" },
    },
    api = {
      host = "api.githubcopilot.com",
      -- Path to a file containing your personal access token
      -- Generate token at https://github.com/settings/tokens?type=beta
      -- Should have Copilot access (will display Copilot next to the token name in your token list)
      token_path = vim.fn.expand("~/.config/github_copilot_token"),
      model = "gpt-4o", -- Configuración para usar GPT-4o
    },
    build = "make tiktoken",
    opts = {
      context_window = 10,         -- Keep this many lines of context
      disable_deduplication = false, -- Repetitive prompts sometimes mitigate hallucinations  
      selection_mode = "whole",    -- Can be "exact" to include just the selection or "whole" to include the whole buffer
      debug = false,
      disable_extra_info = false,  -- Disable sending of extra information (like project type) to Copilot
      request_timeout = 60, -- segundos
      retry_attempts = 3,
      retry_delay = 1000, -- milisegundos
      system_prompt = 'COPILOT_INSTRUCTIONS',
      context_window = 5,
      token_path = vim.fn.expand("~/.config/github_copilot_token"),
      -- model = "claude-3.7-sonnet-thought",
      -- model = 'gpt-4o',
      temperature = 0.1,
      question_header = '# User ',
      answer_header = '# Copilot ',
      error_header = '# Error ',
      separator = '───',
      window = {
        layout = 'float',
        width = 0.8,
        height = 0.4,
        relative = 'editor',
        border = 'single',
        row = vim.o.lines - 15,
        col = math.floor(vim.o.columns * 0.1),
        title = 'Copilot Chat',
        footer = nil,
        zindex = 50,
        -- mappings = {
        --   ["<Tab>"] = {
        --     callback = function()
        --       local ok, result = pcall(vim.fn["copilot#Accept"], "")
        --       if not ok or result ~= 1 then
        --         vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, false, true), "n", true)
        --       end
        --     end,
        --     mode = "i",
        --   },
        -- },
      },
      contexts = {
        buffer = {
          description = "Contenido del buffer actual",
          prompt = "Por favor considera el código del archivo actual:",
        },
        buffers = {
          description = "Contenido de todos los buffers abiertos",
          prompt = "Por favor considera el contenido de todos estos archivos:",
        },
        file = {
          description = "Especifica un archivo por ruta",
          prompt = "Por favor considera el contenido de este archivo específico:",
          only_workspace = true,
        },
        files = {
          description = "Varios archivos por patrón glob",
          prompt = "Por favor considera estos archivos relacionados:",
          only_workspace = true,
          filter = "*.{js,ts,jsx,tsx,py,lua,rb,c,cpp,h,hpp,rs,go}"
        },
        git = {
          description = "Cambios de git (staged, unstaged, o commit específico)",
          prompt = "Por favor analiza estos cambios de git:",
          only_workspace = true,
        },
        url = {
          description = "Contenido de una URL específica",
          prompt = "Por favor considera esta información de la URL proporcionada:",
        },
        register = {
          description = "Contenido de un registro de Neovim",
          prompt = "Por favor considera este texto del registro:",
          default_register = "+",
        },
        quickfix = {
          description = "Lista de errores/advertencias",
          prompt = "Analiza los siguientes errores o advertencias:",
        },
        system = {
          description = "Resultado de comando del sistema",
          prompt = "Por favor analiza la salida de este comando del sistema:",
          only_workspace = false,
          show_cmd = true,
        }
      },

      prompts = {
          Explain = {
              prompt = table.concat({
                  "Hola! puedes  ayudarme en Explicar detalladamente cómo funciona este código:\n",
                  "#buffer\n",
                  "Incluye el propósito de cada sección, patrones utilizados y lógica subyacente."
              }),
          },
          Tests = {
              prompt = function()
                  return table.concat({
                      "Hola! puedes  ayudarme en Generar los tests unitarios completos para este código:\n",
                      "#buffer\n",
                      "Usa las mejores prácticas de testing para ", vim.bo.filetype, 
                      " y asegúrate de cubrir casos límite y excepciones."
                  })
              end,
          },
          Review = {
              prompt = table.concat({
                  "Hola! puedes  ayudarme en Realizar una revisión de código exhaustiva:\n",
                  "#buffer\n",
                  "Identifica problemas de seguridad, rendimiento, mantenibilidad y sugiere mejoras concretas."
              }),
          },
          Fix = {
              prompt = table.concat({
                  "Hola! puedes  ayudarme en Identificar y corrigir los problemas en este código:\n",
                  "#buffer\n",
                  "Explica cada corrección y por qué es necesaria."
              }),
          },
          Optimize = {
              prompt = table.concat({
                  "Hola! puedes  ayudarme en Optimizar este código manteniendo su funcionalidad:\n",
                  "#buffer\n",
                  "Enfócate en mejorar rendimiento, reducir complejidad y usar patrones modernos."
              }),
          },
          Docs = {
              prompt = table.concat({
                  "Hola! puedes  ayudarme en Generar documentación clara y completa para este código:\n",
                  "#buffer\n",
                  "Incluye descripción de propósito, parámetros, valores de retorno, excepciones y ejemplos de uso."
              }),
          },
          Debugging = {
              prompt = table.concat({
                  "Hola!, puedes Analizar este código para encontrar errores o bugs potenciales:\n",
                  "#buffer\n",
                  "Explica la causa raíz de cada problema y sugiere soluciones específicas."
              })
          },
          ReviewBranch = {
              prompt = function()
                  return table.concat({
                  "Hola!!. Puedes Revisar los cambios en mi branch actual comparado con main y proporciona un análisis completo:\n",
                  "Para cada cambio:\n",
                  "1. Evalúa si sigue buenas prácticas de programación\n",
                  "2. Identifica posibles bugs, problemas de rendimiento o seguridad\n",
                  "3. Sugiere mejoras específicas de código cuando sea apropiado\n",
                  "4. Comenta sobre la estructura y organización general\n",
                  "Si no hay cambios en absoluto, indícalo y pregunta si quieres revisar otra cosa."
                  })
              end,
          },
          Refactoring = {
              prompt = table.concat({
                  "Analiza este código e identifica oportunidades de refactorización:\n",
                  "#buffer\n",
                  "Enfócate en mejorar legibilidad, mantenibilidad y rendimiento sin cambiar el comportamiento."
              }),
          },
          PRDescription = {
              prompt = table.concat({
              prompt = "Hola! Por favor analiza los cambios en mi código y genera una descripción completa de pull request.",
                      "Utiliza toda la información de contexto disponible.\n\nPor favor, genera una descripción completa de pull request,",
                      " una versión en inglés y otra en español con los siguientes apartados:\n\n",
                      "## Description\n",
                      "- Resumen conciso de los cambios implementados\n",
                      "- Objetivo y contexto de estos cambios\n",
                      "- Cambios principales y características implementadas\n\n",
                      "## Risks\n",
                      "- Potenciales puntos de fallo o riesgos técnicos\n",
                      "- Áreas que podrían verse afectadas por estos cambios\n",
                      "- Consideraciones de seguridad o rendimiento\n\n",
                      "## Testing\n",
                      "- Pruebas realizadas o necesarias\n",
                      "- Escenarios de prueba recomendados\n",
                      "- Instrucciones para verificar el funcionamiento\n\n",
                      "## Rollout and Rollback Plan\n",
                      "- Pasos para implementar estos cambios\n",
                      "- Estrategia para revertir en caso de problemas\n",
                      "- Consideraciones especiales para la implementación\n\n",
                  " Puedes listarme los cambios en el código entre main y mi rama, luego,",
                  "si no encuentras cambios significativos, indícalo y ofrece algunas sugerencias sobre qué información necesitarías para generar una descripción completa."
              }),
          },
          ProjectContext = {
              prompt = function()
                  return table.concat({
                      "Estoy trabajando en un proyecto con esta estructura:\n",
                      vim.fn.system("find . -type f -not -path '*/\\.*' | sort"),
                      "\nAnaliza el código actual en el contexto del proyecto completo:\n#buffer"
                  })
              end,
          },
      }
    },
    keys = {
      { "<leader>cf", "<cmd>CopilotChatToggle file<cr>", desc = "Toggle Copilot Chat with file context" },
      { "<leader>cw", "<cmd>CopilotChatToggle workspace<cr>", desc = "Toggle Copilot Chat with workspace context" },
      { "<leader>cn", "<cmd>CopilotChatToggle none<cr>", desc = "Toggle Copilot Chat without context" },
      { "<leader>cg", "<cmd>CopilotChatReviewBranch<cr>", desc = "Copilot Chat - Review git branch changes" },
      { "<leader>cc", "<cmd>CopilotChatToggleClean<cr>", desc = "Toggle Clean Copilot Chat" },
      { "<leader>cr", "<cmd>CopilotChatReset<cr>", desc = "Reset Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Copilot Chat - Explain code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Copilot Chat - Generate tests" },
      { "<leader>cr", "<cmd>CopilotChatReview<cr>", desc = "Copilot Chat - Review code" },
      { "<leader>cF", "<cmd>CopilotChatFix<cr>", desc = "Copilot Chat - Fix code" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Copilot Chat - Optimize code" },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Copilot Chat - Add documentation" },
      { "<leader>cp", "<cmd>CopilotChatProblem<cr>", desc = "Copilot Chat - Analyze problem" },
      { "<leader>cpr", "<cmd>CopilotChatPRDescription<cr>", desc = "Copilot Chat - Generate PR Description" },
      -- { "<leader>cb", "<cmd>CopilotChatBufferToggle<cr>", desc = "Copilot Chat - Buffer Toggle" },
      { "<leader>cWq", "<cmd>CopilotChatWq<cr>", desc = "Copilot Chat - Save and exit Buffer" },
      { "<leader>cq", "<cmd>CopilotChatCloseOthers<cr>", desc = "Copilot Chat - Close Other Buffers" },
      { "<leader>cP", "<cmd>CopilotChatCloseOthers<cr>", desc = "Copilot Chat - Close Other Buffers" },
      { "<leader>cb", "<cmd>CopilotChatToggle buffers<cr>", desc = "Toggle Copilot Chat with all open buffers context" },
    },
    cmd = {
      "CopilotChat", "CopilotChatToggle", "CopilotChatExplain", 
      "CopilotChatTests", "CopilotChatReview", "CopilotChatFix",
      "CopilotChatOptimize", "CopilotChatDocs", "CopilotChatReset",
      "CopilotChatProblem", "CopilotChatReviewBranch", "CopilotChatPRDescription", 
      "CopilotChatBufferToggle", "CopilotChatWq", "CopilotChatCloseOthers"
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      
      -- Initialize global state
      _G.copilot_chat_initialized = _G.copilot_chat_initialized or false
      _G.copilot_chat_source_buffer = _G.copilot_chat_source_buffer or nil
      
      -- Language mapping for better display names
      local language_map = {
        javascriptreact = "JavaScript React (JSX)",
        typescriptreact = "TypeScript React (TSX)",
        ["javascript.jsx"] = "JavaScript React (JSX)",
        ["typescript.tsx"] = "TypeScript React (TSX)",
        cs = "C#",
        py = "Python",
        rb = "Ruby",
        js = "JavaScript",
        ts = "TypeScript",
        cpp = "C++",
        ex = "Elixir",
        exs = "Elixir",
      }
      
      -- Helper functions
      local function is_copilot_chat_buffer(buf_name)
        return buf_name:match("CopilotChat") ~= nil
      end
      
      local function find_copilot_chat_buffer()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if is_copilot_chat_buffer(buf_name) and vim.api.nvim_buf_is_loaded(buf) then
            return buf
          end
        end
        return nil
      end
      
      local function get_language_display_name(filetype)
        return language_map[filetype] or filetype
      end
      
      local function close_copilot_chat_windows()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          local buf_name = vim.api.nvim_buf_get_name(buf)
          if is_copilot_chat_buffer(buf_name) and vim.api.nvim_buf_is_loaded(buf) then
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              if vim.api.nvim_win_get_buf(win) == buf then
                vim.api.nvim_win_close(win, true)
              end
            end
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end
      end
      
      -- Command definitions
vim.api.nvim_create_user_command("CopilotChatToggle", function(opts)
  local copilot_chat = require("CopilotChat")
  
  -- Check if we're in a CopilotChat buffer
  local current_buf_name = vim.api.nvim_buf_get_name(0)
  if is_copilot_chat_buffer(current_buf_name) then
    vim.cmd("close")
    return
  end
  
  -- Save current buffer as source
  _G.copilot_chat_source_buffer = vim.api.nvim_get_current_buf()
  
  -- Check if CopilotChat buffer already exists
  local chat_buffer_exists = find_copilot_chat_buffer() ~= nil
  
  -- If chat exists or was initialized, just open it
  if chat_buffer_exists or _G.copilot_chat_initialized then
    copilot_chat.open()
    _G.copilot_chat_initialized = true
    return
  end

  -- Determine context and prompt based on user input
  local context = opts.args or "file"
  local prompt = ""

  if context == "workspace" then
    -- Asynchronous workspace context loading
    local plenary_job = require("plenary.job")
    local excluded_dirs = { ".git", ".github", ".elixir-tools", ".elixir_ls", ".build", ".cache", ".node_modules", ".tmp" }

  local find_args = {} -- Inicializa la tabla antes de usarla
  for _, dir in ipairs(excluded_dirs) do
  table.insert(find_args, "-path")
    for _, dir in ipairs(excluded_dirs) do
      table.insert(find_args, "-path")
      table.insert(find_args, "./" .. dir)
      table.insert(find_args, "-prune")
      table.insert(find_args, "-o")
    end
          end
    table.insert(find_args, "-print") -- Ensure files are printed after exclusions

    local filtered_files = {}

plenary_job:new({
  command = "find",
  args = find_args,
  cwd = vim.fn.getcwd(),
  on_stdout = function(_, file)
    table.insert(filtered_files, file)
  end,
  on_exit = function()
    vim.schedule(function()
      prompt = table.concat({
        "Hola!, necesito tu ayuda como un experto en programación, arquitectura y seguridad. \n",
        "Estoy trabajando en todo el proyecto. Por favor, proporciona insights y sugerencias considerando el contexto completo del workspace.",
        "\n\nLos siguientes archivos están incluidos en el análisis:\n",
        table.concat(filtered_files, "\n"),
        "\n\nEstas son las pautas que debes seguir en todas nuestras interacciones:\n",
        "1. Explica conceptos con ejemplos prácticos\n",
        "2. Sugiere mejores prácticas y patrones modernos\n",
        "3. Cuando detectes errores, explica la causa raíz\n",
        "4. Proporciona soluciones completas pero concisas\n",
        "5. Interactuemos en español pero todo el código y comentarios en inglés\n\n",
        "Si necesitas algo extra para comprender el proyecto, solo solicítalo."
      })
      copilot_chat.ask(prompt)
      _G.copilot_chat_initialized = true
    end)
  end,
}):start()
  elseif context == "file" then
      local filetype = vim.bo[_G.copilot_chat_source_buffer].filetype
      local language = get_language_display_name(filetype)
      local filepath = vim.fn.expand('%:p')
      local filename = vim.fn.expand('%:t')

      prompt = table.concat({
        "Hola!, necesito tu ayuca como un experto en ", language,
        " en lo relacionado a programación, arquitectura y seguridad. \n",
        "Estoy trabajando con ", 
        " en el archivo '", filename, "' ubicado en '", filepath, "'.",
        "\n\nAquí está el contenido del archivo:\n#buffer\n\n",
        "Estas son las pautas que debes seguir en todas nuestras interacciones:\n",
        "1. Explica conceptos con ejemplos prácticos\n",
        "2. Sugiere mejores prácticas y patrones modernos\n",
        "3. Cuando detectes errores, explica la causa raíz\n",
        "4. Proporciona soluciones completas pero concisas\n",
        "5. Interactuemos en español pero todo el código y comentarios en inglés\n\n",
        "Si necesitas algo extra para comprender el archivo, solo solicítalo."
      })
copilot_chat.ask(prompt)
      _G.copilot_chat_initialized = true
  elseif context == "buffers" then
      -- Recopilar todos los buffers abiertos
      local buffers = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
              local buf_name = vim.api.nvim_buf_get_name(buf)
              if buf_name ~= "" and not is_copilot_chat_buffer(buf_name) then
                  local filetype = vim.bo[buf].filetype
                  local language = get_language_display_name(filetype)
                  local content = table.concat(vim.api.nvim_buf_get_lines(buf, 0, -1, false), "\n")
                  table.insert(buffers, {
                      name = buf_name,
                      filetype = filetype,
                      language = language,
                      content = content
                  })
              end
          end
      end
      -- Construir el prompt con la información de todos los buffers
      prompt = table.concat({
          "Hola!, necesito tu ayuda como un experto en programación, arquitectura y seguridad. \n",
          "Estoy trabajando con múltiples archivos simultáneamente. Por favor, proporciona insights considerando el contexto de todos estos archivos abiertos.\n\n"
      })
      
      -- Añadir cada buffer al prompt
      for _, buf in ipairs(buffers) do
          prompt = prompt .. "Archivo: " .. vim.fn.fnamemodify(buf.name, ":t") .. " (" .. buf.language .. ")\n"
          prompt = prompt .. "Ruta: " .. buf.name .. "\n"
          prompt = prompt .. "Contenido:\n```" .. buf.filetype .. "\n" .. buf.content .. "\n```\n\n"
      end
      
      prompt = prompt .. table.concat({
          "Estas son las pautas que debes seguir en todas nuestras interacciones:\n",
          "1. Explica conceptos con ejemplos prácticos\n",
          "2. Sugiere mejores prácticas y patrones modernos\n",
          "3. Cuando detectes errores, explica la causa raíz\n",
          "4. Proporciona soluciones completas pero concisas\n",
          "5. Interactuemos en español pero todo el código y comentarios en inglés\n\n",
          "Si necesitas algo extra para comprender los archivos, solo solicítalo."
      })
      
      copilot_chat.ask(prompt)
      _G.copilot_chat_initialized = true
  else
    prompt = "No se proporcionó un contexto específico. Por favor, asiste de manera general."
    copilot_chat.ask(prompt)
    _G.copilot_chat_initialized = true
  end
end, {
  desc = "Toggle Copilot Chat with optional context",
  nargs = "?",
})
        -- Create commands for predefined prompts
        local function create_prompt_command(name, prompt_key)
          vim.api.nvim_create_user_command("CopilotChat" .. name, function()
            local prompt = opts.prompts[prompt_key].prompt
            if type(prompt) == "function" then
              prompt = prompt()
            end
            require("CopilotChat").ask( prompt )
          end, {})
        end
        
        create_prompt_command("Explain", "Explain")
        create_prompt_command("Tests", "Tests")
        create_prompt_command("Review", "Review")
        create_prompt_command("Fix", "Fix")
        create_prompt_command("Optimize", "Optimize")
        create_prompt_command("Docs", "Docs")
        create_prompt_command("ReviewBranch", "ReviewBranch")
        create_prompt_command("PRDescription", "PRDescription")
        
        -- Define a new command to open a clean toggle
        vim.api.nvim_create_user_command('CopilotChatToggleClean', function(opts)
          vim.cmd('enew')
          vim.bo.buflisted = false
          vim.bo.filetype = opts.args ~= '' and opts.args or 'plaintext'
        end, {
          desc = 'Abre un Copilot toggle con el contexto de Git',
          nargs = '?',
        })
        -- Define a new command to open a clean toggle
        vim.api.nvim_create_user_command('CopilotChatToggleClean', function(opts)
          vim.cmd('enew')
          vim.bo.buflisted = false
          vim.bo.filetype = opts.args ~= '' and opts.args or 'plaintext'
        end, {
          desc = 'Open a clean toggle with optional filetype',
          nargs = '?',
        })

        vim.api.nvim_create_user_command("CopilotChatProblem", function()
          local copilot_chat = require("CopilotChat")
          _G.copilot_chat_source_buffer = vim.api.nvim_get_current_buf()
          local filetype = vim.bo[_G.copilot_chat_source_buffer].filetype
          local language = get_language_display_name(filetype)
          local start_line, end_line
          local mode = vim.api.nvim_get_mode().mode
          if mode:match("[vV]") then
            start_line = vim.fn.line("v")
            end_line = vim.fn.line(".")
          else
            start_line = 1
            end_line = vim.fn.line("$")
          end
        local prompt = "Hola! puedes  ayudarme? Estoy enfrentando un problema con este código en " .. language .. ":\n" ..
                      "#buffer:" .. start_line .. "-" .. end_line .. "\n\n" ..
                      "Analiza detalladamente el código para:\n" ..
                      "1. Identificar problemas, bugs o ineficiencias\n" ..
                      "2. Explicar la causa raíz de cada problema\n" ..
                      "3. Proponer soluciones concretas con ejemplos\n" ..
                      "4. Sugerir mejoras de estilo, rendimiento o seguridad"
        copilot_chat.ask(prompt)
      end, {})

      vim.api.nvim_create_user_command("CopilotChatReset", function()
        _G.copilot_chat_initialized = false
        close_copilot_chat_windows()
        vim.cmd("CopilotChatToggle")
      end, {})

      vim.api.nvim_create_user_command('CopilotChatBufferToggle', function()
        vim.cmd('b#')
      end, { desc = 'Toggle between the last two buffers' })

      vim.api.nvim_create_user_command('CopilotChatWq', function()
        vim.cmd('w')
        vim.cmd('bd')
      end, { desc = 'Save and close the current buffer' })

      vim.api.nvim_create_autocmd("FileType", {
          pattern = "copilot",
          callback = function()
              vim.api.nvim_buf_set_keymap(0, "i", "<Tab>", 'copilot#Accept("<Tab>")', { silent = true, expr = true })
          end,
      })
      vim.api.nvim_create_user_command('CopilotChatCloseOthers', function()
        local current = vim.api.nvim_get_current_buf()
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if buf ~= current and vim.api.nvim_buf_is_loaded(buf) then
            vim.cmd('bd ' .. buf)
          end
        end
      end, { desc = 'Close all buffers except the current one' })

      -- local function disable_completion_for_copilotchat()
      --   -- Primera estrategia: usar FileType
      --   vim.api.nvim_create_autocmd("FileType", {
      --     pattern = {"copilotchat", "CopilotChat"},
      --     callback = function()
      --       -- Disable cmp for this buffer
      --       require("cmp").setup.buffer({ enabled = false })
      --     end,
      --   })
      --
      --   -- Segunda estrategia: detectar por nombre de buffer
      --   vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter", "BufNew"}, {
      --     callback = function(ev)
      --       local buf_name = vim.api.nvim_buf_get_name(ev.buf)
      --       if buf_name:match("CopilotChat") then
      --         require("cmp").setup.buffer({ enabled = false })
      --       end
      --     end,
      --   })
      -- end
      --
      -- disable_completion_for_copilotchat()

      local function patch_blink_cmp()
        local ok, window = pcall(require, "blink.cmp.lib.window")
        if not ok then return end
        
        -- Guarda la función original
        local original_get_cursor_screen_position = window.get_cursor_screen_position
        
        -- Sobreescribe la función
        window.get_cursor_screen_position = function(...)
          local buf_name = vim.api.nvim_buf_get_name(0)
          if buf_name:match("CopilotChat") then
            -- Devuelve posiciones falsas pero válidas para evitar errores
            return {row = 1, col = 1, screenrow = 1, screencol = 1}
          end
          
          -- Llama a la función original para otros buffers
          local ok, result = pcall(original_get_cursor_screen_position, ...)
          if not ok then
            -- Si falla, devuelve valores por defecto seguros
            return {row = 1, col = 1, screenrow = 1, screencol = 1}
          end
          return result
        end
        
        -- También parchear get_vertical_direction_and_height si es accesible
        if window.get_vertical_direction_and_height then
          local original_get_vertical = window.get_vertical_direction_and_height
          window.get_vertical_direction_and_height = function(...)
            local buf_name = vim.api.nvim_buf_get_name(0)
            if buf_name:match("CopilotChat") then
              -- Valores predeterminados seguros
              return "bottom", 10, { height = 10, width = 40, row = 1, col = 1 }
            end
            
            local ok, direction, height, info = pcall(original_get_vertical, ...)
            if not ok or not height or (info and not info.height) then
              return "bottom", 10, { height = 10, width = 40, row = 1, col = 1 }
            end
            
            -- Asegurar que info tiene todos los campos necesarios
            if info then
              info.height = info.height or 10
              info.width = info.width or 40
              info.row = info.row or 1
              info.col = info.col or 1
            end
            
            return direction, height, info
          end
        end
      end
      
      local ok, blink_cmp = pcall(require, "blink.cmp")
      if ok then
        -- Prevenir que blink.cmp se active en buffers de CopilotChat
        local original_setup = blink_cmp.setup
        blink_cmp.setup = function(opts)
          local original_on_attach = opts.on_attach
          
          opts.on_attach = function(bufnr)
            local buf_name = vim.api.nvim_buf_get_name(bufnr)
            if buf_name:match("CopilotChat") then
              return false -- No adjuntar cmp a buffers de CopilotChat
            end
            
            if original_on_attach then
              return original_on_attach(bufnr)
            end
            
            return true
          end
          
          return original_setup(opts)
        end
      end
      
      -- Ejecuta el parche
      patch_blink_cmp()


      local function patch_blink_menu()
        -- Intentar acceder directamente al módulo menu.lua que tiene el error
        local ok, menu_module = pcall(require, "blink.cmp.completion.windows.menu")
        if not ok then return end
        
        -- Guardar la función original
        local original_update_position = menu_module.update_position
        
        -- Reemplazar con nuestra versión protegida
        menu_module.update_position = function(self, ...)
          -- Verificar si estamos en un buffer CopilotChat
          local buf_name = vim.api.nvim_buf_get_name(0)
          if buf_name:match("CopilotChat") then
            return -- No hacer nada para CopilotChat
          end
          
          -- Verificar si tenemos todas las propiedades necesarias
          if not self or not self.info or not self.info.height then
            -- Establecer valores predeterminados para evitar errores
            if self and self.info then
              self.info.height = 10
              self.info.width = 40
              self.info.row = 1
              self.info.col = 1
            end
            return -- Evitar errores si falta info
          end
          
          -- Llamar a la función original con protección
          pcall(original_update_position, self, ...)
        end
      end

      -- Ejecutar el parche del menú
      patch_blink_menu()
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        callback = function()
          local buf_name = vim.api.nvim_buf_get_name(0)
          if buf_name:match("CopilotChat") then
            -- Desactiva blink.cmp temporalmente
            pcall(function()
              -- Guarda el estado actual si no está guardado
              if not _G._blink_cmp_disabled then
                _G._blink_cmp_disabled = true
                _G._blink_cmp_original_enabled = require("blink.cmp").enabled
                require("blink.cmp").enabled = false
              end
            end)
          else
            -- Restaura blink.cmp si fue desactivado
            pcall(function()
              if _G._blink_cmp_disabled then
                require("blink.cmp").enabled = _G._blink_cmp_original_enabled
                _G._blink_cmp_disabled = false
              end
            end)
          end
        end
      })
    end,
  }
}
