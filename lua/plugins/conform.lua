return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  opts = {},
  keys = {
    {
      -- Formateador con filtro de tipo de archivo
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = "",
      desc = "Formatear buffer",
    },
  },
  config = function()
    local conform = require("conform")

    -- Definir formateadores por tipo de archivo
    conform.setup({
      -- Configurar eventos de formato
      -- format_on_save = {
      --   timeout_ms = 500,
      --   lsp_fallback = true,
      -- },

      -- Configurar formateadores por tipo de archivo
      formatters_by_ft = {
        -- Ruby
        ruby = { "rubocop" },
        eruby = { "erb_formatter" },

        -- Python
        python = { "black", "isort" },

        -- Lua
        lua = { "stylua" },

        -- Elixir
        elixir = { "mix" },
        heex = { "mix_format" },
        eex = { "mix_format" },

        -- Java
        java = { "google_java_format" },

        -- YAML (Kubernetes)
        yaml = { "yamlfmt" },

        -- Terraform
        terraform = { "terraform_fmt" },
        tf = { "terraform_fmt" },

        -- Bash/Shell
        sh = { "shfmt" },
        bash = { "shfmt" },

        -- Docker
        dockerfile = { "dockerfile_lint" },

        -- Fallbacks para múltiples lenguajes
        ["*"] = { "trim_whitespace", "end_with_newline" },
      },

      -- Configuración específica de formateadores
      formatters = {
        -- Ruby/Rails
        rubocop = {
          -- Función para manejar el formateo con RuboCop
          format = function(self, params)
            -- Obtener la ruta del archivo actual
            local bufnr = params.bufnr or vim.api.nvim_get_current_buf()
            local file_path = vim.api.nvim_buf_get_name(bufnr)
            local file_dir = vim.fn.fnamemodify(file_path, ":h")

            -- Determinar el directorio raíz del proyecto con RuboCop
            local root_dir = vim.fs.root(file_dir, { ".rubocop.yml", ".rubocop_todo.yml", ".git" })
            if not root_dir then
              root_dir = vim.fn.getcwd()
            end

            -- Comando base
            local cmd
            local args

            -- Comprobar si estamos en un proyecto con Gemfile
            local gemfile_exists = vim.fn.filereadable(vim.fn.fnamemodify(root_dir .. "/Gemfile", ":p")) == 1

            -- Usar opciones más simples para reducir la carga de trabajo y evitar timeouts
            if gemfile_exists then
              cmd = "bundle"
              args = { "exec", "rubocop", "--autocorrect", "--stdin", file_path, "--format", "files", "--safe" }
            else
              cmd = "rubocop"
              args = { "--autocorrect", "--stdin", file_path, "--format", "files", "--safe" }
            end

            -- Ejecutar el comando con un timeout más largo
            local result = vim
              .system({ cmd, unpack(args) }, {
                stdin = params.content,
                cwd = root_dir,
                timeout = 10000, -- 10 segundos de timeout
              })
              :wait()

            -- Verificar errores, timeouts u otros problemas
            if result.code == nil or (result.code ~= 0 and result.code ~= 1) then
              -- Si ocurre un timeout o error, ejecutar el método alternativo con vim.fn.jobstart
              vim.notify("Usando método alternativo para formatear con RuboCop", vim.log.levels.INFO)

              -- Guardar el contenido en un archivo temporal
              local tmp_file = os.tmpname()
              local f = io.open(tmp_file, "w")
              if f then
                f:write(params.content)
                f:close()

                -- Ejecutar rubocop directamente sobre el archivo temporal
                local alt_cmd
                if gemfile_exists then
                  alt_cmd = "cd "
                    .. vim.fn.shellescape(root_dir)
                    .. " && bundle exec rubocop --safe --autocorrect "
                    .. tmp_file
                else
                  alt_cmd = "rubocop --safe --autocorrect " .. tmp_file
                end

                vim.fn.system(alt_cmd)

                -- Leer el contenido formateado
                local formatted = io.open(tmp_file, "r")
                if formatted then
                  local content = formatted:read("*all")
                  formatted:close()
                  os.remove(tmp_file)
                  return content
                end
                os.remove(tmp_file)
              end

              -- En caso de error, devolver el contenido original
              return params.content
            end

            -- Devolver el contenido formateado
            if result.stdout and result.stdout ~= "" and not string.match(result.stdout, "^Inspecting") then
              return result.stdout
            end

            -- Si no hay cambios, devolver el contenido original
            return params.content
          end,

          -- Configuración necesaria para que conform.nvim detecte que usamos una implementación personalizada
          meta = {
            url = "https://github.com/rubocop/rubocop",
            description = "Ruby static code analyzer and formatter",
          },
        },

        -- Python
        black = {
          prepend_args = { "--fast" },
        },
        isort = {
          args = { "--profile", "black", "--filter-files", "--quiet", "-" },
        },

        -- Lua
        stylua = {
          -- Priorizar configuración local
          args = function()
            local has_stylua_config = vim.fs.find({ "stylua.toml", ".stylua.toml" }, {
              upward = true,
              path = vim.fn.getcwd(),
            })[1]

            if has_stylua_config then
              return { "--search-parent-directories", "-" }
            else
              -- Configuración por defecto
              return {
                "--indent-type",
                "Spaces",
                "--indent-width",
                "2",
                "--column-width",
                "120",
                "-",
              }
            end
          end,
        },

        -- Elixir
        mix = {
          -- Solo funciona en proyectos Elixir
          condition = function()
            return vim.fn.filereadable("mix.exs") == 1
          end,
          command = "mix",
          args = { "format", "-" },
        },

        -- Java
        google_java_format = {
          command = "google-java-format",
          stdin = true,
        },

        -- Shell
        shfmt = {
          args = { "-i", "2", "-ci" },
        },

        -- YAML (Kubernetes)
        yamlfmt = {
          args = { "-in", "-", "-formatter", "retain_line_breaks=true", "-formatter", "include_document_start=true" },
        },
      },
    })

    -- Función para formatear Ruby directamente
    local function format_ruby_direct()
      -- Verificar si estamos en un archivo Ruby
      if vim.bo.filetype ~= "ruby" then
        vim.notify("Este comando solo funciona en archivos Ruby", vim.log.levels.WARN)
        return
      end

      -- Verificar si rubocop está instalado
      if vim.fn.executable("rubocop") == 0 then
        vim.notify("RuboCop no está instalado. Intenta: gem install rubocop", vim.log.levels.WARN)
        return
      end

      -- Guardar el archivo actual si hay cambios
      if vim.bo.modified then
        vim.cmd("write")
      end

      -- Obtener el path del archivo
      local file_path = vim.fn.expand("%:p")
      local cmd = ""

      -- Determinar si debemos usar bundle exec
      if vim.fn.filereadable("Gemfile") == 1 and vim.fn.executable("bundle") == 1 then
        cmd = "bundle exec rubocop --autocorrect " .. vim.fn.shellescape(file_path)
      else
        cmd = "rubocop --autocorrect " .. vim.fn.shellescape(file_path)
      end

      -- Ejecutar el comando
      vim.notify("Formateando: " .. cmd, vim.log.levels.INFO)
      vim.fn.jobstart(cmd, {
        on_exit = function(_, code)
          if code == 0 or code == 1 then
            -- Recargar el buffer
            vim.cmd("e!")
            vim.notify("Formateo completado con RuboCop", vim.log.levels.INFO)
          else
            vim.notify("Error al formatear con RuboCop (código " .. code .. ")", vim.log.levels.ERROR)
          end
        end,
      })
    end

    -- Comandos útiles
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.fn.line("'<")
        local start_line = vim.fn.line("'>")
        range = {
          start = { start_line, 0 },
          ["end"] = { end_line, 0 },
        }
      end
      conform.format({ async = true, lsp_fallback = true, range = range })
    end, { range = true })

    -- Comando específico para Ruby
    vim.api.nvim_create_user_command("RubyFormat", function()
      format_ruby_direct()
    end, {})

    -- Verificar disponibilidad de formateadores y mostrar advertencias
    vim.defer_fn(function()
      local formatters_to_check = {
        { cmd = "rubocop", name = "rubocop", install = "gem install rubocop" },
        { cmd = "black", name = "black", install = "pip install black" },
        { cmd = "stylua", name = "stylua", install = "cargo install stylua" },
        { cmd = "shfmt", name = "shfmt", install = "brew install shfmt" },
      }

      for _, formatter in ipairs(formatters_to_check) do
        if vim.fn.executable(formatter.cmd) == 0 then
          vim.notify(
            "Formateador '" .. formatter.name .. "' no encontrado. " .. "Instálalo con: " .. formatter.install,
            vim.log.levels.WARN
          )
        end
      end
    end, 3000)

    -- Mapeo de teclas para Ruby
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "ruby", "eruby" },
      callback = function()
        vim.api.nvim_buf_set_keymap(
          0,
          "n",
          "<leader>rf",
          "<cmd>RubyFormat<CR>",
          { noremap = true, desc = "Ruby: Formatear con RuboCop" }
        )
      end,
    })

    vim.notify("conform.nvim configurado para múltiples lenguajes", vim.log.levels.INFO)

    local organize_imports = function()
      local params = {
        command = "java.edit.organizeImports",
        arguments = { vim.uri_from_bufnr(0) },
      }
      -- Ejecuta la acción sin bloquear
      vim.lsp.buf.execute_command(params)
    end
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.java",
      callback = function()
        -- 1) Organiza imports (equivalente a importOrder + removeUnusedImports)
        organize_imports()
        -- -- 2) Formatea con conform (google-java-format + trims)
        -- require("conform").format({ bufnr = 0 })
      end,
    })
  end,
}

