return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = { "folke/trouble.nvim" },
  config = function()
    local lint = require("lint")

    -- Configuración de los linters por tipo de archivo
    lint.linters_by_ft = {
      -- Ruby/Rails
      ruby = { "rubocop" },
      eruby = { "erb_lint" },

      -- Python
      python = { "flake8", "pylint" },

      -- Lua
      lua = { "luacheck" },

      -- Elixir
      elixir = { "credo" },

      -- Java
      java = { "checkstyle" },

      -- Docker
      dockerfile = { "hadolint" },

      -- Kubernetes
      yaml = { "yamllint", "actionlint" },

      -- Terraform
      terraform = { "tflint" },

      -- Bash
      sh = { "shellcheck" },
      bash = { "shellcheck" },
    }

    -- Configuraciones personalizadas para linters específicos

    -- -- Ruby
    -- local rubocop = lint.linters.rubocop
    -- rubocop.cmd = "bundle"
    -- rubocop.args = {
    --   "exec",
    --   "rubocop",
    --   "--format", "json",
    --   -- "--force-exclusion",
    --   -- "--display-only-fail"
    -- }

    -- Python
    if vim.fn.executable("flake8") == 1 then
      lint.linters.flake8.args = {
        "--format=%(row)d,%(col)d,%(code).1s,%(code)s: %(text)s",
        "--no-show-source",
      }
    end

    -- Lua
    if vim.fn.executable("luacheck") == 1 then
      lint.linters.luacheck.args = {
        "--formatter",
        "plain",
        "--codes",
        "--ranges",
      }
    end

    -- Yamllint para Kubernetes
    if vim.fn.executable("yamllint") == 1 then
      lint.linters.yamllint.args = {
        "-f",
        "parsable",
        "-",
      }
    end

    -- Verificar existencia de linters y mostrar advertencias
    local function check_linter_exists(cmd, name, install_info)
      if vim.fn.executable(cmd) == 0 then
        vim.notify("Linter '" .. name .. "' no encontrado. " .. "Instálalo con: " .. install_info, vim.log.levels.WARN)
      end
    end

    -- Verificar linters comunes
    vim.defer_fn(function()
      check_linter_exists("rubocop", "rubocop", "gem install rubocop")
      check_linter_exists("flake8", "flake8", "pip install flake8")
      check_linter_exists("luacheck", "luacheck", "luarocks install luacheck")
      check_linter_exists("shellcheck", "shellcheck", "brew install shellcheck")
      check_linter_exists("tflint", "tflint", "brew install tflint")
      check_linter_exists("yamllint", "yamllint", "pip install yamllint")
    end, 2000)

    -- Función para ejecutar lint en el buffer actual
    local function lint_file()
      -- Guardar primero si hay cambios
      if vim.bo.modified then
        vim.cmd("silent! write")
      end

      -- Ejecutar el linter
      lint.try_lint()

      -- Mostrar feedback
      vim.notify("Ejecutando linting...", vim.log.levels.INFO)
    end

    -- Función para ejecutar RuboCop directamente sin nvim-lint
    local function run_rubocop_direct()
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
        cmd = "bundle exec rubocop --format simple " .. vim.fn.shellescape(file_path)
      else
        cmd = "rubocop --format simple " .. vim.fn.shellescape(file_path)
      end

      -- Ejecutar el comando
      vim.notify("Ejecutando: " .. cmd, vim.log.levels.INFO)
      vim.fn.jobstart(cmd, {
        on_stdout = function(_, data)
          if data and #data > 1 then
            vim.schedule(function()
              local output = table.concat(data, "\n")

              -- Crear ventana flotante con resultados
              local buf = vim.api.nvim_create_buf(false, true)
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, data)
              vim.api.nvim_buf_set_option(buf, "filetype", "ruby")

              local width = math.min(120, vim.o.columns - 4)
              local height = math.min(20, #data + 1)
              local row = math.floor((vim.o.lines - height) / 2)
              local col = math.floor((vim.o.columns - width) / 2)

              vim.api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded",
                title = "RuboCop Results",
                title_pos = "center",
              })

              -- También intentar con nvim-lint y actualizar los diagnósticos
              lint.try_lint()

              -- Actualizar el buffer para asegurar que los diagnósticos sean visibles
              vim.defer_fn(function()
                vim.cmd("doautocmd User LintPost")
              end, 100)
            end)
          else
            vim.notify("No se encontraron problemas de sintaxis 👍", vim.log.levels.INFO)
          end
        end,
        on_stderr = function(_, data)
          if data and #data > 1 then
            vim.notify("Error en RuboCop: " .. table.concat(data, "\n"), vim.log.levels.ERROR)
          end
        end,
        on_exit = function(_, code)
          if code ~= 0 and code ~= 1 then
            vim.notify("RuboCop terminó con código: " .. code, vim.log.levels.WARN)
          end
        end,
      })
    end

    -- Función para abrir Trouble con los diagnósticos actuales
    local function open_trouble_diagnostics()
      -- Asegurarse de que los diagnósticos están actualizados
      lint.try_lint()

      -- Programar la apertura de Trouble después de que los diagnósticos estén disponibles
      vim.defer_fn(function()
        vim.cmd("Trouble diagnostics")
      end, 100)
    end

    -- Variable para debounce (evitar múltiples llamadas rápidas)
    local lint_timer = nil

    -- Variable para rastrear errores detectados
    local lint_diagnostics_detected = false

    -- Evento personalizado para notificar actualizaciones de diagnósticos
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      callback = function()
        -- Verificar si hay diagnósticos para Ruby
        if vim.bo.filetype == "ruby" then
          local diagnostics = vim.diagnostic.get(0)
          if diagnostics and #diagnostics > 0 then
            lint_diagnostics_detected = true
          end
        end
      end,
    })

    -- Función para lint con debounce
    local function debounced_lint(delay)
      -- Cancelar timer existente
      if lint_timer then
        vim.fn.timer_stop(lint_timer)
        lint_timer = nil
      end

      -- Crear nuevo timer
      lint_timer = vim.fn.timer_start(delay, function()
        lint.try_lint()
        lint_timer = nil
      end)
    end

    -- Autocomandos para ejecutar lint automáticamente
    local lint_augroup = vim.api.nvim_create_augroup("NvimLint", { clear = true })

    -- Lint al guardar
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Lint al abrir archivo
    vim.api.nvim_create_autocmd({ "BufReadPost" }, {
      group = lint_augroup,
      callback = function()
        -- Ejecutar con un pequeño retraso para asegurar que el buffer esté completamente cargado
        vim.defer_fn(function()
          lint.try_lint()
        end, 50)
      end,
    })

    -- Lint al salir del modo insertar
    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    -- Lint mientras se edita (con debounce)
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
      group = lint_augroup,
      callback = function()
        -- Solo para Ruby, ya que puede ser intensivo
        if vim.bo.filetype == "ruby" then
          debounced_lint(800) -- 800ms de debounce
        end
      end,
    })

    -- Lint al cambiar de modo visual a normal
    vim.api.nvim_create_autocmd({ "ModeChanged" }, {
      group = lint_augroup,
      pattern = "v:n", -- del modo visual al normal
      callback = function()
        if vim.bo.filetype == "ruby" then
          debounced_lint(500)
        end
      end,
    })

    -- Comando manual para forzar el linting de Ruby
    vim.api.nvim_create_user_command("RubyLintNow", function()
      run_rubocop_direct()
    end, {})

    -- Comando para mostrar los diagnósticos de RuboCop en Trouble
    vim.api.nvim_create_user_command("RubyTrouble", function()
      -- Ejecutar lint primero para asegurar que los diagnósticos estén actualizados
      if vim.bo.filetype == "ruby" then
        -- Ejecutar RuboCop directamente para asegurar que tenemos diagnósticos
        run_rubocop_direct()
        -- Esperar un momento para que se apliquen los diagnósticos
        vim.defer_fn(function()
          vim.cmd("Trouble diagnostics")
        end, 300)
      else
        vim.notify("Este comando solo funciona con archivos Ruby", vim.log.levels.WARN)
      end
    end, {})

    -- Comando para activar/desactivar el linting en tiempo real
    local live_lint_enabled = false
    vim.api.nvim_create_user_command("ToggleLiveLint", function()
      live_lint_enabled = not live_lint_enabled
      if live_lint_enabled then
        vim.notify("Linting en tiempo real ACTIVADO", vim.log.levels.INFO)
        -- Configurar autocmd para TextChanged con debounce más corto
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
          group = lint_augroup,
          callback = function()
            debounced_lint(300) -- 300ms de debounce cuando está en modo activo
          end,
        })
      else
        vim.notify("Linting en tiempo real DESACTIVADO", vim.log.levels.INFO)
        -- Volver a la configuración normal
        vim.api.nvim_clear_autocmds({ group = lint_augroup, event = { "TextChanged", "TextChangedI" } })
        vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
          group = lint_augroup,
          callback = function()
            if vim.bo.filetype == "ruby" then
              debounced_lint(800) -- 800ms de debounce
            end
          end,
        })
      end
    end, {})

    -- Comandos personalizados
    vim.api.nvim_create_user_command("Lint", function()
      lint_file()
    end, {})

    vim.api.nvim_create_user_command("LintInfo", function()
      local filetype = vim.bo.filetype
      local linters = lint.linters_by_ft[filetype] or {}

      if #linters == 0 then
        vim.notify("No hay linters configurados para el tipo de archivo: " .. filetype, vim.log.levels.INFO)
        return
      end

      local info = { "Linters para " .. filetype .. ":" }
      for _, linter_name in ipairs(linters) do
        local linter = lint.linters[linter_name]
        local cmd = type(linter.cmd) == "function" and linter.cmd() or linter.cmd
        table.insert(info, " - " .. linter_name .. " (" .. cmd .. ")")
      end

      vim.notify(table.concat(info, "\n"), vim.log.levels.INFO)
    end, {})

    -- Mapeo de teclas
    vim.keymap.set("n", "<leader>ll", function()
      lint_file()
    end, { desc = "Lint archivo actual" })

    vim.keymap.set("n", "<leader>lr", function()
      if vim.bo.filetype == "ruby" then
        vim.cmd("RubyLintNow")
      else
        lint_file()
      end
    end, { desc = "Ruby: Lint forzado" })

    -- Atajo para abrir Trouble con diagnósticos de Ruby
    vim.keymap.set("n", "<leader>rt", function()
      vim.cmd("RubyTrouble")
    end, { desc = "Ruby: Ver diagnósticos en Trouble" })

    vim.keymap.set("n", "<leader>lt", "<cmd>ToggleLiveLint<CR>", { desc = "Alternar linting en tiempo real" })

    vim.keymap.set("n", "<leader>li", "<cmd>LintInfo<cr>", { desc = "Mostrar información de linters" })

    vim.notify("nvim-lint configurado para múltiples lenguajes", vim.log.levels.INFO)
  end,
}
