-- JDTLS JVM diagnostic configuration
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

-- Java command con opciones de diagnóstico JVM
local java_cmd = {
    java_binary,
    -- Modo diagnóstico JVM
    "-XX:+ShowCodeDetailsInExceptionMessages",
    "-XX:+TraceExceptions",
    "-XX:ErrorFile=jvm_error_%p.log",
    -- Debug options
    "-Xlog:jni+resolve=debug",
    "-Xcheck:jni",
    -- Solo lo esencial para JDTLS
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    -- Debug logs
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
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

                -- Configuración diagnóstico
                local config = {
                    cmd = java_cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle'}),
                    init_options = {
                        bundles = {}
                    },
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

                -- Iniciar servidor en modo diagnóstico
                jdtls.start_or_attach(config)
                vim.notify("JDTLS iniciado en modo diagnóstico. Revisar logs para detalles.", vim.log.levels.INFO)
            end
        })

        -- Comando para verificar JVM detalladamente
        vim.api.nvim_create_user_command("JdtJvmDiag", function()
            -- Verificar JAVA_HOME
            vim.notify("JAVA_HOME: " .. (java_home or "no configurado"), vim.log.levels.INFO)

            -- Verificar versión de Java con información detallada
            local handle = io.popen(java_binary .. " -XshowSettings:properties -version 2>&1")
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Java settings: \n" .. result, vim.log.levels.INFO)
            else
                vim.notify("No se pudo ejecutar Java", vim.log.levels.ERROR)
            end

            -- Verificar el classpath actual
            handle = io.popen(java_binary .. " -XshowSettings:system -version 2>&1")
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Java system settings: \n" .. result, vim.log.levels.INFO)
            end

            -- Intentar ejecutar un programa Java simple para verificar JVM
            local test_file = os.tmpname() .. ".java"
            local file = io.open(test_file, "w")
            if file then
                file:write([[
public class JvmTest {
    public static void main(String[] args) {
        System.out.println("JVM test successful");
        System.out.println("Java version: " + System.getProperty("java.version"));
        System.out.println("Java home: " + System.getProperty("java.home"));
        System.out.println("JVM name: " + System.getProperty("java.vm.name"));
    }
}
                ]])
                file:close()

                -- Compilar y ejecutar
                local cmd = "cd " .. vim.fn.fnamemodify(test_file, ":h") .. " && "
                          .. java_binary:gsub("/bin/java", "/bin/javac") .. " " .. vim.fn.fnamemodify(test_file, ":t")
                          .. " && " .. java_binary .. " -cp " .. vim.fn.fnamemodify(test_file, ":h") .. " JvmTest"

                handle = io.popen(cmd)
                if handle then
                    local result = handle:read("*a")
                    handle:close()
                    vim.notify("JVM test: \n" .. result, vim.log.levels.INFO)
                end

                -- Limpiar archivos temporales
                os.execute("rm -f " .. test_file .. " " .. vim.fn.fnamemodify(test_file, ":r") .. ".class")
            end
        end, {})

        -- Comandos para verificar logs
        vim.api.nvim_create_user_command("JdtVerLogs", function()
            local lsp_log = vim.fn.stdpath('state') .. '/lsp.log'
            if vim.fn.filereadable(lsp_log) == 1 then
                -- Buscar errores específicos en logs
                local handle = io.popen("grep -i 'exit code 13\\|exit code 1\\|error\\|exception\\|failed' " .. lsp_log)
                if handle then
                    local result = handle:read("*a")
                    handle:close()

                    if result and result ~= "" then
                        vim.notify("Errores encontrados en logs: \n" .. result, vim.log.levels.ERROR)
                    else
                        vim.notify("No se encontraron errores específicos en los logs", vim.log.levels.INFO)
                    end
                end

                -- Verificar archivos de error JVM
                handle = io.popen("find " .. home .. " -name 'jvm_error_*.log' -mtime -1")
                if handle then
                    local result = handle:read("*a")
                    handle:close()

                    if result and result ~= "" then
                        vim.notify("Archivos de error JVM encontrados: \n" .. result, vim.log.levels.ERROR)

                        -- Leer el primer archivo de error
                        local error_files = {}
                        for file in result:gmatch("[^\r\n]+") do
                            table.insert(error_files, file)
                        end

                        if #error_files > 0 then
                            local error_handle = io.open(error_files[1], "r")
                            if error_handle then
                                local error_content = error_handle:read("*a")
                                error_handle:close()
                                vim.notify("Contenido del archivo de error: \n" .. error_content, vim.log.levels.ERROR)
                            end
                        end
                    else
                        vim.notify("No se encontraron archivos de error JVM recientes", vim.log.levels.INFO)
                    end
                end
            else
                vim.notify("Archivo de log LSP no encontrado", vim.log.levels.WARNING)
            end
        end, {})
    end
}