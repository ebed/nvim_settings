-- JDTLS con carga de variables de entorno desde zsh
local home = os.getenv("HOME")
local env_loader = home .. "/.config/nvim/load_env.sh"

-- Cargar variables de entorno desde zsh
local function load_shell_env()
    local env_vars = {}
    local handle = io.popen(env_loader)

    if handle then
        local output = handle:read("*a")
        handle:close()

        for line in output:gmatch("[^\r\n]+") do
            local name, value = line:match("^([^=]+)=(.+)$")
            if name and value then
                env_vars[name] = value
            end
        end

        return env_vars
    end

    return {}
end

-- Cargar variables de entorno
local env = load_shell_env()

-- Usar JAVA_HOME cargado o caer en valor por defecto
local java_home = env.JAVA_HOME or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"

-- Paths básicos
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"

-- Buscar launcher jar
local launcher_glob = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
local launcher_jar = vim.fn.glob(launcher_glob, true)

-- Java command con variables de entorno cargadas
local java_cmd = {
    java_binary,
    -- JNI y natives - usar valores de env
    "-Djava.library.path=" .. java_home .. "/lib:" .. java_home .. "/lib/server",
    -- Habilitar mensajes detallados de errores
    "-XX:+ShowCodeDetailsInExceptionMessages",
    -- Módulos Java para permisos
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    -- Lombok
    "-javaagent:" .. lombok_jar,
    -- JDTLS esencial
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    -- Memoria
    "-Xms256m",
    "-Xmx512m",
    -- Archivo JAR, configuración y datos
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir
}

return {
    'mfussenegger/nvim-jdtls',
    config = function()
        -- Verificar variables cargadas
        if not env.PATH then
            vim.notify("⚠️ No se pudieron cargar las variables de entorno desde shell", vim.log.levels.WARN)
            vim.notify("Asegúrate de que " .. env_loader .. " tenga permisos de ejecución", vim.log.levels.WARN)
        else
            vim.notify("✅ Variables de entorno cargadas correctamente desde shell", vim.log.levels.INFO)
            vim.notify("JAVA_HOME: " .. java_home, vim.log.levels.INFO)
        end

        -- Limpiar workspace al inicio
        local ws_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
        if vim.fn.isdirectory(ws_dir) == 1 then
            local cmd = "rm -rf " .. vim.fn.shellescape(ws_dir)
            os.execute(cmd)
            vim.notify("Workspace limpiado automáticamente en inicio", vim.log.levels.INFO)
        end

        -- Limpiar logs antiguos
        local lsp_log = vim.fn.stdpath('state') .. '/lsp.log'
        if vim.fn.filereadable(lsp_log) == 1 then
            os.execute("echo '' > " .. vim.fn.shellescape(lsp_log))
            vim.notify("Log LSP limpiado", vim.log.levels.INFO)
        end

        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                -- Solo para archivos Java
                local filename = vim.api.nvim_buf_get_name(0)
                if not filename:match("%.java$") then
                    return
                end

                -- Intentar iniciar JDTLS
                local status, jdtls = pcall(require, 'jdtls')
                if not status then
                    vim.notify("No se pudo cargar jdtls", vim.log.levels.ERROR)
                    return
                end

                -- Configuración con variables de entorno del shell
                local config = {
                    cmd = java_cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle', '.git'}),
                    settings = {
                        java = {
                            configuration = {
                                updateBuildConfiguration = "automatic",
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                    default = true
                                }},
                            },
                            compiler = {
                                lombokEnabled = true
                            }
                        }
                    },
                    init_options = {
                        bundles = {}
                    },
                    -- Usar las variables cargadas de zsh
                    cmd_env = env
                }

                -- Iniciar servidor con entorno zsh
                jdtls.start_or_attach(config)
                vim.notify("JDTLS iniciado con variables de entorno de zsh", vim.log.levels.INFO)
            end
        })

        -- Comando para mostrar todas las variables cargadas
        vim.api.nvim_create_user_command("JdtZshEnv", function()
            local count = 0
            local variables = ""

            for name, value in pairs(env) do
                count = count + 1
                if count <= 20 then -- Mostrar solo las primeras 20 para no saturar
                    variables = variables .. name .. "=" .. value .. "\n"
                end
            end

            vim.notify("Variables de entorno cargadas desde zsh (" .. count .. " en total):", vim.log.levels.INFO)
            vim.notify(variables, vim.log.levels.INFO)

            -- Verificar archivos críticos
            if vim.fn.executable(java_binary) == 1 then
                vim.notify("✅ Java binary exists: " .. java_binary, vim.log.levels.INFO)
            else
                vim.notify("❌ Java binary not found: " .. java_binary, vim.log.levels.ERROR)
            end

            if vim.fn.filereadable(launcher_jar) == 1 then
                vim.notify("✅ Launcher jar exists: " .. launcher_jar, vim.log.levels.INFO)
            else
                vim.notify("❌ Launcher jar not found: " .. launcher_jar, vim.log.levels.ERROR)
            end

            if vim.fn.filereadable(lombok_jar) == 1 then
                vim.notify("✅ Lombok jar exists: " .. lombok_jar, vim.log.levels.INFO)
            else
                vim.notify("❌ Lombok jar not found: " .. lombok_jar, vim.log.levels.ERROR)
            end
        end, {})
    end
}