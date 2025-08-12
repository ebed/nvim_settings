-- Options table for CopilotChat plugin
return {
      -- Prompt del sistema: define el comportamiento del asistente
      system_prompt = [[
        Eres un asistente experto en desarrollo de software, sistemas y DevOps.

        - Proporciona mejores prácticas, optimiza código y explica cada paso de forma clara y concisa.
        - Si falta información, pregunta antes de continuar.
        - Da ejemplos concretos y breves.
        - Si detectas mejoras en los prompts, indícalo.
        - Si no entiendes algo, solicita aclaración antes de continuar.
        - Si un diagrama ayuda, genera ASCII Art o visualizaciones en texto.
        - Si se solicita un gráfico DOT, muestra primero el gráfico en texto y luego el código fuente DOT.
        - Responde siempre en español, de forma clara y sin redundancias.
        - Para análisis de contexto, utiliza los archivos del proyecto y el branch actual para dar un resumen detallado.
        - Todo código generado, incluidos los comentarios, debe estar en inglés.
      ]],
      model = 'gpt-4.1',
      temperature = 0.1,
      resource_processing = true,
      headless = false,
      remember_as_sticky = true,
      window = {
        layout = "float",
        width = 100,
        height = 80,
        border = "rounded",
        title = "🤖 AI Assistant",
        zindex = 100,
      },
      show_help = true,
      show_folds = true,
      highlight_selection = true,
      highlight_headers = true,
      auto_follow_cursor = true,
      auto_insert_mode = true,
      insert_at_end = true,
      clear_chat_on_new_prompt = false,
      debug = false,
      log_level = 'info',
      proxy = nil,
      allow_insecure = false,
      chat_autocomplete = true,
      log_path = vim.fn.stdpath('state') .. '/CopilotChat.log',
      history_path = vim.fn.stdpath('data') .. '/copilotchat_history',
      headers = {
        user = "👤 Usuario: ",
        assistant = "🤖 Copilot: ",
        tool = "🔧 Tool: ",
      },

      integrations = {
        telescope = true,
      },
      -- Función personalizada para ejecutar comandos de shell
      functions = {
        shell = {
          description = "Ejecuta un comando de shell y retorna el resultado",
          uri = "shell://{cmd}",
          schema = {
            type = 'object',
            required = { 'cmd' },
            properties = {
              cmd = {
                type = 'string',
                description = "Comando de shell a ejecutar",
              },
            },
          },
          resolve = function(input)
            local plenary_job = require("plenary.job")
            local result = plenary_job:new({
              command = "sh",
              args = { "-c", input.cmd },
            }):sync()
            -- Notifica el resultado para depuración
            vim.notify("Resultado: " .. vim.inspect(result))
            -- Si no hay resultado, retorna mensaje de error
            if not result or #result == 0 then
              return {{
                uri = 'shell://' .. input.cmd,
                mimetype = 'text/plain',
                data = "Sin salida o error al ejecutar el comando.",
              }}
            end
            return {{
              uri = 'shell://' .. input.cmd,
              mimetype = 'text/plain',
              data = "```sh\n" .. table.concat(result, "\n") .. "\n```",
            }}
          end,
        },
      },
      prompts = {
        generaDiagrama = {
          prompt = [[
Genera un diagrama ASCII o DOT que represente la arquitectura de la configuración del proyecto actual. Incluye:

- Módulos principales
- Plugins clave
- Integraciones externas (por ejemplo: Kafka, Copilot)

Si el diagrama es DOT, muestra primero el gráfico en texto y luego el código fuente DOT.

Usa los siguientes archivos como referencia: #glob:**/*

El diagrama debe ser autocontenible y fácil de entender para nuevos desarrolladores.
]],
      mapping = '<leader>Cgd',
      description = 'Genera diagramas',
        }
      },
      -- Mapeos de teclas personalizables
      mappings = {
        explain = "<leader>Ce",
        tests = "<leader>Ct",
        review = "<leader>Cr",
        fix = "<leader>Cf",
        optimize = "<leader>Co",
        docs = "<leader>Cd",
        debugging = "<leader>Cb",
        reviewbranch = "<leader>Cv",
        refactoring = "<leader>Ca",
        prdescription = "<leader>Cp",
        projectcontext = "<leader>Cc",
        complete = {
          normal = "<Tab>",
          insert = "<C-d>",
        },
      },
}
