-- JDTLS - Solución ultra específica para exit code 13
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Versión básica de cmd con solo opciones críticas - todo directo para evitar problemas
local cmd = {
    java_binary,
    -- Sin opciones de módulos que pueden causar problemas
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Xms256m",
    "-Xmx512m",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir
}

return {
    'mfussenegger/nvim-jdtls',
    lazy = false, -- Cargar inmediatamente
    priority = 1000, -- Alta prioridad
    config = function()
        -- Intentar registrar comandos inmediatamente
        vim.api.nvim_create_user_command("JdtSolucionar", function()
            -- Eliminar workspace antiguo
            vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
            vim.notify("Workspace eliminado", vim.log.levels.INFO)

            -- Detener clientes existentes
            vim.lsp.stop_client(vim.lsp.get_clients({name = "jdtls"}))
            vim.notify("Clientes JDTLS detenidos", vim.log.levels.INFO)

            -- Comando directo sin usar API de Neovim
            local command_str = java_binary ..
                " -Declipse.application=org.eclipse.jdt.ls.core.id1" ..
                " -Dosgi.bundles.defaultStartLevel=4" ..
                " -Declipse.product=org.eclipse.jdt.ls.core.product" ..
                " -Xms256m -Xmx512m" ..
                " -jar " .. vim.fn.shellescape(launcher_jar) ..
                " -configuration " .. vim.fn.shellescape(config_dir) ..
                " -data " .. vim.fn.shellescape(workspace_dir) ..
                " > /tmp/jdtls_test.log 2>&1 &"

            -- Ejecutar comando directamente para probar si funciona
            vim.fn.system(command_str)
            vim.notify("Comando Java ejecutado directamente para prueba - revisar /tmp/jdtls_test.log", vim.log.levels.INFO)

            -- Recargar JDTLS
            vim.cmd("Lazy reload nvim-jdtls")
            vim.notify("Plugin JDTLS recargado, abra un archivo Java", vim.log.levels.INFO)
        end, {})

        -- Registrar solo para archivos Java
        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                -- Verificar que sea un archivo Java
                if not vim.bo.filetype == "java" then
                    return
                end

                -- Cargar JDTLS
                local status, jdtls = pcall(require, 'jdtls')
                if not status then
                    vim.notify("No se pudo cargar jdtls", vim.log.levels.ERROR)
                    return
                end

                -- Configuración ultra básica
                local config = {
                    cmd = cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle', '.git'}),
                    settings = {
                        java = {
                            configuration = {
                                updateBuildConfiguration = "automatic",
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                    default = true
                                }}
                            }
                        }
                    },
                    filetypes = {"java"}
                }

                -- Iniciar servidor
                jdtls.start_or_attach(config)
            end
        })
    end,
}