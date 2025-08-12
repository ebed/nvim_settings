-- Context-related functions for CopilotChat
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

return M

