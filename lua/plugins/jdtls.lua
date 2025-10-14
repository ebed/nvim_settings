-- JDTLS: Configuración con variables de entorno integradas y soporte para Lombok
-- Evitando problemas de comunicación LSP

local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local lsp_env_script = home .. "/.config/nvim/java_env_lsp.sh"
local diagnostic_script = home .. "/.config/nvim/java_env.sh"
local lombok_enabled = vim.fn.filereadable(lombok_jar) == 1

-- Configuración del plugin
return {
    'mfussenegger/nvim-jdtls',
    config = function()
        -- Definir comando de diagnóstico
        vim.api.nvim_create_user_command("JavaInfo", function()
            vim.notify("JAVA_HOME: " .. java_home, vim.log.levels.INFO)
            vim.notify("Java bin: " .. java_binary, vim.log.levels.INFO)
            vim.notify("JDTLS path: " .. jdtls_path, vim.log.levels.INFO)
            vim.notify("Config dir: " .. config_dir, vim.log.levels.INFO)
            vim.notify("Launcher: " .. launcher_jar, vim.log.levels.INFO)
            vim.notify("Lombok: " .. (lombok_enabled and "✅ Habilitado - " .. lombok_jar or "❌ No encontrado"), vim.log.levels.INFO)

            -- Verificar si hay clientes activos
            local clients = vim.lsp.get_clients({name = "jdtls"})
            vim.notify("Clientes JDTLS activos: " .. #clients, vim.log.levels.INFO)

            -- Ejecutar script de diagnóstico
            local handle = io.popen(diagnostic_script)
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Diagnóstico de entorno: \n" .. result, vim.log.levels.INFO)
            end
        end, {})

        -- Comando para limpiar workspace
        vim.api.nvim_create_user_command("JavaClean", function()
            -- Detener cualquier cliente existente
            vim.lsp.stop_client(vim.lsp.get_clients({name = "jdtls"}))
            vim.notify("Clientes JDTLS detenidos", vim.log.levels.INFO)

            -- Limpiar todo el directorio de workspace
            local cmd = "rm -rf " .. vim.fn.stdpath('data') .. '/jdtls-workspace-*'
            vim.fn.system(cmd)
            vim.notify("Workspace limpiado. Reinicie Neovim.", vim.log.levels.INFO)
        end, {})

        -- Comando para probar Java directamente con script de entorno
        vim.api.nvim_create_user_command("JavaTest", function()
            -- Ejecutar java directamente con script de entorno
            local test_cmd = diagnostic_script .. " " .. java_home .. "/bin/java -version"
            local handle = io.popen(test_cmd .. " 2>&1")
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Test Java con script de entorno: \n" .. result, vim.log.levels.INFO)
            end
        end, {})

        -- Registrar solo para archivos Java
        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                -- Verificar que sea un archivo Java
                local filename = vim.api.nvim_buf_get_name(0)
                if not filename:match("%.java$") then
                    return
                end

                -- Crear un workspace único por archivo
                local file_basename = vim.fn.fnamemodify(filename, ":t:r")
                local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace-' .. file_basename

                -- Asegurarse que existe el workspace
                vim.fn.system("mkdir -p " .. vim.fn.shellescape(workspace_dir))

                -- Preparar comando base
                local cmd_parts = {
                    java_binary,
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Djava.library.path=" .. java_home .. "/lib:" .. java_home .. "/lib/server",
                }

                -- Añadir soporte Lombok si está disponible
                if lombok_enabled then
                    table.insert(cmd_parts, "-javaagent:" .. lombok_jar)
                end

                -- Continuar con el resto de opciones
                table.insert(cmd_parts, "-Xms256m")
                table.insert(cmd_parts, "-Xmx512m")
                table.insert(cmd_parts, "-jar")
                table.insert(cmd_parts, launcher_jar)
                table.insert(cmd_parts, "-configuration")
                table.insert(cmd_parts, config_dir)
                table.insert(cmd_parts, "-data")
                table.insert(cmd_parts, workspace_dir)

                -- Comando con script de entorno SILENCIOSO
                local cmd = {
                    lsp_env_script,
                    unpack(cmd_parts)
                }

                -- Cargar jdtls y configurar
                local status, jdtls = pcall(require, 'jdtls')
                if not status then
                    vim.notify("No se pudo cargar jdtls", vim.log.levels.ERROR)
                    return
                end

                -- Configuración con variables directas
                local config = {
                    cmd = cmd,
                    root_dir = vim.fn.getcwd(),
                    settings = {
                        java = {
                            configuration = {
                                updateBuildConfiguration = "automatic",
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home
                                }}
                            },
                            -- Habilitar Lombok en la configuración Java
                            compiler = {
                                lombokEnabled = lombok_enabled
                            },
                            -- Configuración adicional recomendada
                            maven = {
                                downloadSources = true,
                            },
                            implementationsCodeLens = {
                                enabled = true,
                            },
                            referencesCodeLens = {
                                enabled = true,
                            },
                            -- Ignorar warnings de classpath incompleto
                            errors = {
                                incompleteClasspath = { severity = "ignore" }
                            }
                        }
                    },
                    init_options = {
                        bundles = {}
                    }
                }

                -- Iniciar servidor
                jdtls.start_or_attach(config)
                vim.notify("JDTLS iniciado " .. (lombok_enabled and "con" or "sin") .. " soporte para Lombok", vim.log.levels.INFO)
            end
        })

        -- Comando específico para verificar Lombok
        vim.api.nvim_create_user_command("LombokStatus", function()
            if not lombok_enabled then
                vim.notify("❌ Lombok JAR no encontrado en: " .. lombok_jar, vim.log.levels.ERROR)
                vim.notify("Las anotaciones de Lombok como @Getter, @Setter, @RequiredArgsConstructor no funcionarán", vim.log.levels.ERROR)
                vim.notify("Instala Lombok descargándolo de https://projectlombok.org/download", vim.log.levels.INFO)
                vim.notify("Colócalo en " .. lombok_jar, vim.log.levels.INFO)
                return
            end

            vim.notify("✅ Lombok está configurado con JAR: " .. lombok_jar, vim.log.levels.INFO)
            vim.notify("Soporte para anotaciones como @Getter, @Setter, @RequiredArgsConstructor", vim.log.levels.INFO)

            -- Verificar si JDTLS está activo
            local clients = vim.lsp.get_clients({name = "jdtls"})
            if #clients == 0 then
                vim.notify("⚠️ JDTLS no está activo actualmente, Lombok no funcionará", vim.log.levels.WARN)
                vim.notify("Abra un archivo Java para iniciar JDTLS con soporte para Lombok", vim.log.levels.INFO)
            else
                vim.notify("✅ JDTLS está activo - Lombok debería estar funcionando", vim.log.levels.INFO)
            end

            vim.notify("Si las anotaciones siguen sin funcionar, ejecute JavaClean y reinicie Neovim", vim.log.levels.INFO)
        end, {})

        -- Mensaje inicial
        if lombok_enabled then
            vim.notify("Configuración JDTLS con soporte para Lombok. Comandos: JavaInfo, JavaClean, JavaTest, LombokStatus", vim.log.levels.INFO)
        else
            vim.notify("Configuración JDTLS sin soporte para Lombok (JAR no encontrado). Comandos: JavaInfo, JavaClean, JavaTest", vim.log.levels.WARN)
        end
    end
}