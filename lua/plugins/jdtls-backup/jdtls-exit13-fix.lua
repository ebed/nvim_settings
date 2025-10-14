-- JDTLS configuración para resolver exit code 13
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME")

if not java_home or java_home == "" then
    vim.notify("JAVA_HOME no está configurado", vim.log.levels.ERROR)
    return {}
end

local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"

-- Buscar launcher jar
local launcher_glob = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
local launcher_jar = vim.fn.glob(launcher_glob, true)

-- Java command con opciones específicas para exit code 13
local java_cmd = {
    java_binary,
    -- Módulos Java necesarios para evitar exit code 13
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    -- Reducir warnings de incubator modules
    "-XX:+UnlockDiagnosticVMOptions",
    "-XX:+IgnoreUnrecognizedVMOptions",
    "-Djdk.module.showModuleResolution=false",
    -- Configuración estándar de JDTLS
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    -- Memoria optimizada
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

                -- Configuración optimizada para exit code 13
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
                            -- Configuración básica
                            errors = {
                                incompleteClasspath = { severity = "ignore" }
                            },
                            trace = { server = "verbose" }
                        }
                    },
                    init_options = {
                        bundles = {}
                    }
                }

                -- Iniciar servidor
                jdtls.start_or_attach(config)
                vim.notify("JDTLS iniciado con configuración para resolver exit code 13", vim.log.levels.INFO)
            end
        })

        -- Comando para verificar estado JDTLS
        vim.api.nvim_create_user_command("JdtExitInfo", function()
            -- Verificar si hay clientes JDTLS activos
            local clients = vim.lsp.get_clients({name = "jdtls"})
            if #clients > 0 then
                vim.notify("✅ JDTLS está activo", vim.log.levels.INFO)
            else
                vim.notify("❌ JDTLS no está activo actualmente", vim.log.levels.ERROR)
            end

            -- Verificar logs recientes
            local lsp_log = vim.fn.stdpath('state') .. '/lsp.log'
            if vim.fn.filereadable(lsp_log) == 1 then
                local handle = io.popen("tail -n 20 " .. lsp_log)
                if handle then
                    local result = handle:read("*a")
                    handle:close()
                    vim.notify("Últimas entradas del log: \n" .. result, vim.log.levels.INFO)
                end
            end
        end, {})

        -- Comando para añadir Lombok después de verificar estabilidad
        vim.api.nvim_create_user_command("JdtAddLombok", function()
            if vim.fn.filereadable(lombok_jar) ~= 1 then
                vim.notify("❌ Lombok JAR no encontrado: " .. lombok_jar, vim.log.levels.ERROR)
                return
            end

            -- Detener JDTLS actual
            pcall(function() vim.cmd("LspStop jdtls") end)
            vim.notify("JDTLS detenido para reconfigurarlo con Lombok", vim.log.levels.INFO)

            -- Modificar java_cmd para incluir Lombok
            table.insert(java_cmd, 3, "-javaagent:" .. lombok_jar)

            -- Reiniciar con la nueva configuración
            vim.notify("Por favor abre un archivo Java para iniciar JDTLS con soporte de Lombok", vim.log.levels.INFO)
        end, {})
    end
}