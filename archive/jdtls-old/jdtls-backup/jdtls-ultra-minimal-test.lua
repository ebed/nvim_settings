-- JDTLS ultra minimal configuration - testing without Lombok
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME")

if not java_home or java_home == "" then
    vim.notify("JAVA_HOME no está configurado", vim.log.levels.ERROR)
    return {}
end

local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"

-- Buscar launcher jar
local launcher_glob = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
local launcher_jar = vim.fn.glob(launcher_glob, true)

-- Java command con opciones absolutamente mínimas - sin Lombok
local java_cmd = {
    java_binary,
    -- Solo lo esencial para JDTLS
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    -- Memoria mínima
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

                -- Configuración ultra simple para evitar problemas
                local config = {
                    cmd = java_cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle'}),
                    settings = {
                        java = {
                            configuration = {
                                updateBuildConfiguration = "automatic",
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                    default = true
                                }},
                            }
                        }
                    }
                }

                -- Iniciar servidor
                jdtls.start_or_attach(config)
                vim.notify("JDTLS iniciado con configuración ultra mínima", vim.log.levels.INFO)
            end
        })

        -- Comando para verificar versión de Java
        vim.api.nvim_create_user_command("JavaVerificar", function()
            -- Verificar JAVA_HOME
            vim.notify("JAVA_HOME: " .. (java_home or "no configurado"), vim.log.levels.INFO)

            -- Verificar versión de Java
            local cmd = java_binary .. " -version 2>&1"
            local handle = io.popen(cmd)
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Java version: " .. result, vim.log.levels.INFO)
            else
                vim.notify("No se pudo ejecutar Java", vim.log.levels.ERROR)
            end

            -- Verificar JDTLS path
            vim.notify("JDTLS path: " .. jdtls_path, vim.log.levels.INFO)
            if vim.fn.isdirectory(jdtls_path) == 1 then
                vim.notify("✅ JDTLS directory exists", vim.log.levels.INFO)
            else
                vim.notify("❌ JDTLS directory does not exist", vim.log.levels.ERROR)
            end

            -- Verificar launcher jar
            vim.notify("Launcher jar: " .. launcher_jar, vim.log.levels.INFO)
            if vim.fn.filereadable(launcher_jar) == 1 then
                vim.notify("✅ Launcher jar exists", vim.log.levels.INFO)
            else
                vim.notify("❌ Launcher jar not found", vim.log.levels.ERROR)
            end

            -- Verificar workspace directory
            vim.notify("Workspace dir: " .. workspace_dir, vim.log.levels.INFO)
        end, {})
    end
}