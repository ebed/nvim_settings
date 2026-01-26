-- JDTLS: Configuración unificada que integra todos los componentes
-- Incluye: Debugging, refactoring, snippets, formateo y más

local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local lombok_enabled = vim.fn.filereadable(lombok_jar) == 1

return {
    'mfussenegger/nvim-jdtls',
    dependencies = {
        'mfussenegger/nvim-dap',              -- Para debugging
        'rcarriga/nvim-dap-ui',               -- UI para DAP
        'theHamsta/nvim-dap-virtual-text',    -- Texto virtual para DAP
    },
    config = function()
        -- Función integrada para manejar el entorno de Java, reemplazando la necesidad de scripts externos
        local function setup_java_env()
            -- Configuración crucial para JNI en macOS
            vim.env.DYLD_LIBRARY_PATH = java_home .. "/lib:" .. java_home .. "/lib/server:" .. (vim.env.DYLD_LIBRARY_PATH or "")
            vim.env.LD_LIBRARY_PATH = java_home .. "/lib:" .. java_home .. "/lib/server:" .. (vim.env.LD_LIBRARY_PATH or "")
            vim.env.PATH = java_home .. "/bin:" .. (vim.env.PATH or "")
            vim.env.JAVA_LIBRARY_PATH = java_home .. "/lib:" .. java_home .. "/lib/server"
        end

        -- Llamar a la función para configurar el entorno
        setup_java_env()

        -- Función para buscar plugins de Debugging - versión segura y robusta
        local function find_bundles()
            local bundles = {}

            -- Buscar bundles locales primero
            local debug_path = home .. "/workspaces/utils/java-debug"
            local test_path = home .. "/workspaces/utils/vscode-java-test"

            -- Si existe un directorio de depuración Java local
            if vim.fn.isdirectory(debug_path) == 1 then
                local debug_bundle = vim.fn.glob(debug_path .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", true)
                if debug_bundle ~= "" then
                    vim.list_extend(bundles, vim.split(debug_bundle, "\n"))
                end
            end

            -- Si existe un directorio de testing Java local
            if vim.fn.isdirectory(test_path) == 1 then
                local test_bundles = vim.fn.glob(test_path .. "/server/*.jar", true)
                if test_bundles ~= "" then
                    vim.list_extend(bundles, vim.split(test_bundles, "\n"))
                end
            end

            -- Intentar cargar bundle desde Mason
            local has_mason, mason_registry = pcall(require, "mason-registry")

            if has_mason then
                -- Método seguro para obtener paquete sin errores
                local function safe_get_package_path(package_name)
                    if mason_registry and type(mason_registry.get_package) == "function" then
                        local ok, package = pcall(mason_registry.get_package, package_name)
                        if ok and package and type(package.get_install_path) == "function" then
                            local path_ok, path = pcall(package.get_install_path, package)
                            if path_ok and path then
                                return path
                            end
                        end
                    end
                    return nil
                end

                -- Intentar obtener java-debug-adapter
                local debug_adapter_path = safe_get_package_path("java-debug-adapter")
                if debug_adapter_path then
                    local debug_bundles = vim.fn.glob(debug_adapter_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
                    if debug_bundles ~= "" then
                        vim.list_extend(bundles, vim.split(debug_bundles, "\n"))
                    end
                end

                -- Intentar obtener java-test
                local java_test_path = safe_get_package_path("java-test")
                if java_test_path then
                    local test_bundles = vim.fn.glob(java_test_path .. "/extension/server/*.jar", true)
                    if test_bundles ~= "" then
                        vim.list_extend(bundles, vim.split(test_bundles, "\n"))
                    end
                end
            end

            -- Buscar en ubicaciones estándar de Mason como fallback
            local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
            if vim.fn.isdirectory(mason_path) == 1 then
                -- Buscar java-debug-adapter
                local debug_path = mason_path .. "/java-debug-adapter"
                if vim.fn.isdirectory(debug_path) == 1 then
                    local debug_bundles = vim.fn.glob(debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
                    if debug_bundles ~= "" then
                        vim.list_extend(bundles, vim.split(debug_bundles, "\n"))
                    end
                end

                -- Buscar java-test
                local test_path = mason_path .. "/java-test"
                if vim.fn.isdirectory(test_path) == 1 then
                    local test_bundles = vim.fn.glob(test_path .. "/extension/server/*.jar", true)
                    if test_bundles ~= "" then
                        vim.list_extend(bundles, vim.split(test_bundles, "\n"))
                    end
                end
            end

            return bundles
        end

        -- Crear los directorios necesarios para el proyecto
        local function setup_project_directories(project_root)
            local dirs = {
                project_root .. "/src/main/java",
                project_root .. "/src/main/resources",
                project_root .. "/src/test/java",
                project_root .. "/src/test/resources",
            }
            for _, dir in ipairs(dirs) do
                if vim.fn.isdirectory(dir) == 0 then
                    vim.fn.system("mkdir -p " .. vim.fn.shellescape(dir))
                end
            end
        end

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

            local bundles = find_bundles()
            vim.notify("Bundles de Debugging encontrados: " .. #bundles, vim.log.levels.INFO)

            -- Verificar bibliotecas nativas esenciales
            local libraries = {
                java_home .. "/lib/libjli.dylib",
                java_home .. "/lib/server/libjvm.dylib",
                java_home .. "/lib/libzip.dylib"
            }

            for _, lib in ipairs(libraries) do
                local exists = vim.fn.filereadable(lib) == 1
                vim.notify((exists and "✅ " or "❌ ") .. lib, vim.log.levels.INFO)
            end

            -- Mostrar versión de Java
            local handle = io.popen(java_binary .. " -version 2>&1")
            if handle then
                local result = handle:read("*a")
                handle:close()
                vim.notify("Versión de Java: " .. result, vim.log.levels.INFO)
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

        -- Comando para reiniciar JDTLS
        vim.api.nvim_create_user_command("JavaRestart", function()
            -- Detener cualquier cliente existente
            local clients = vim.lsp.get_clients({name = "jdtls"})
            if #clients > 0 then
                vim.lsp.stop_client(clients)
                vim.notify("Servidor JDTLS detenido", vim.log.levels.INFO)
            end

            -- Reiniciar el servidor automáticamente si estamos en un archivo Java
            if vim.bo.filetype == "java" then
                vim.cmd("edit") -- Recargar el buffer actual
                vim.notify("JDTLS reiniciado para el buffer actual", vim.log.levels.INFO)
            else
                vim.notify("No estás en un archivo Java. Abre un archivo .java para iniciar JDTLS", vim.log.levels.WARN)
            end
        end, {})

        -- Comando para crear un nuevo proyecto Java
        vim.api.nvim_create_user_command("JavaNewProject", function(opts)
            local project_name = opts.args
            if project_name == "" then
                vim.notify("Por favor especifique un nombre de proyecto", vim.log.levels.ERROR)
                return
            end

            local project_root = vim.fn.getcwd() .. "/" .. project_name
            if vim.fn.isdirectory(project_root) == 1 then
                vim.notify("El proyecto ya existe: " .. project_root, vim.log.levels.WARN)
                return
            end

            vim.fn.system("mkdir -p " .. vim.fn.shellescape(project_root))
            setup_project_directories(project_root)

            -- Crear pom.xml básico
            local pom_content = [[
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.example</groupId>
    <artifactId>]] .. project_name .. [[</artifactId>
    <version>1.0-SNAPSHOT</version>

    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>

    <dependencies>
        <!-- Add your dependencies here -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.8.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
</project>
]]
            local pom_file = io.open(project_root .. "/pom.xml", "w")
            if pom_file then
                pom_file:write(pom_content)
                pom_file:close()
                vim.notify("Creado nuevo proyecto Maven: " .. project_root, vim.log.levels.INFO)
            end

            -- Crear clase principal
            local main_content = [[
package com.example;

public class Main {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]]
            local main_dir = project_root .. "/src/main/java/com/example"
            vim.fn.system("mkdir -p " .. vim.fn.shellescape(main_dir))
            local main_file = io.open(main_dir .. "/Main.java", "w")
            if main_file then
                main_file:write(main_content)
                main_file:close()
                vim.notify("Creada clase principal: Main.java", vim.log.levels.INFO)
            end

            vim.cmd("cd " .. vim.fn.shellescape(project_root))
            vim.notify("Cambiado al directorio del proyecto: " .. project_root, vim.log.levels.INFO)
        end, {nargs = 1})

        -- Registrar para archivos Java
        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                -- Verificar que sea un archivo Java
                local filename = vim.api.nvim_buf_get_name(0)
                if not filename:match("%.java$") then
                    return
                end

                -- Crear un workspace basado en el proyecto
                local bufnr = vim.api.nvim_get_current_buf()
                local root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle', '.git', 'mvnw', 'gradlew'})
                local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ':t')
                local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace-' .. project_name

                -- Asegurarse que existe el workspace
                vim.fn.system("mkdir -p " .. vim.fn.shellescape(workspace_dir))

                -- Preparar comando
                local cmd = {
                    java_binary,
                    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                    "-Dosgi.bundles.defaultStartLevel=4",
                    "-Declipse.product=org.eclipse.jdt.ls.core.product",
                    "-Djava.library.path=" .. java_home .. "/lib:" .. java_home .. "/lib/server",
                }

                -- Añadir soporte Lombok si está disponible
                if lombok_enabled then
                    table.insert(cmd, "-javaagent:" .. lombok_jar)
                end

                -- Continuar con el resto de opciones
                table.insert(cmd, "-Xms256m")
                table.insert(cmd, "-Xmx1G") -- Más memoria para proyectos grandes
                table.insert(cmd, "-jar")
                table.insert(cmd, launcher_jar)
                table.insert(cmd, "-configuration")
                table.insert(cmd, config_dir)
                table.insert(cmd, "-data")
                table.insert(cmd, workspace_dir)

                -- Cargar jdtls y configurar
                local status, jdtls = pcall(require, 'jdtls')
                if not status then
                    vim.notify("No se pudo cargar jdtls", vim.log.levels.ERROR)
                    return
                end

                -- Intentar cargar los bundles para debugging
                local bundles = find_bundles()

                -- Configuración avanzada
                local config = {
                    cmd = cmd,
                    root_dir = root_dir,
                    settings = {
                        java = {
                            -- Opciones avanzadas de compilador
                            configuration = {
                                updateBuildConfiguration = "automatic",
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                    default = true
                                }}
                            },
                            -- Habilitar Lombok en la configuración Java
                            compiler = {
                                lombokEnabled = lombok_enabled
                            },
                            -- Formateo y organización de código
                            format = {
                                enabled = true,
                                settings = {
                                    url = jdtls_path .. "/formatter.xml",
                                    profile = "GoogleStyle",
                                },
                            },
                            -- Preferencias de importación
                            import = {
                                gradle = { enabled = true },
                                maven = { enabled = true },
                                exclusions = {
                                    "**/node_modules/**",
                                    "**/.metadata/**",
                                    "**/archetype-resources/**",
                                    "**/META-INF/maven/**",
                                },
                            },
                            -- Maven
                            maven = {
                                downloadSources = true,
                            },
                            -- Opciones de completado
                            completion = {
                                favoriteStaticMembers = {
                                    "org.junit.Assert.*",
                                    "org.junit.Assume.*",
                                    "org.junit.jupiter.api.Assertions.*",
                                    "org.junit.jupiter.api.Assumptions.*",
                                    "org.junit.jupiter.api.DynamicContainer.*",
                                    "org.junit.jupiter.api.DynamicTest.*",
                                    "org.mockito.Mockito.*",
                                    "org.mockito.ArgumentMatchers.*",
                                },
                                filteredTypes = {
                                    "com.sun.*",
                                    "io.micrometer.shaded.*",
                                    "java.awt.*",
                                    "jdk.*",
                                    "sun.*",
                                },
                                importOrder = {
                                    "java",
                                    "javax",
                                    "com",
                                    "org"
                                },
                            },
                            -- Opciones de code lens
                            implementationsCodeLens = { enabled = true },
                            referencesCodeLens = { enabled = true },
                            -- Ignorar warnings de classpath incompleto
                            errors = {
                                incompleteClasspath = { severity = "ignore" }
                            },
                        }
                    },
                    init_options = {
                        bundles = bundles,
                        extendedClientCapabilities = jdtls.extendedClientCapabilities
                    }
                }

                -- Handler para suprimir notificaciones excesivas de JDTLS
                config.handlers = {
                    -- Filtrar mensajes de progreso repetitivos
                    ["$/progress"] = function(_, result, ctx)
                        -- Suprimir mensajes de building/validating repetitivos
                        if result.value and result.value.message then
                            local msg = result.value.message
                            if msg:match("^Building") or
                               msg:match("^Validate documents") or
                               msg:match("^Publish Diagnostics") then
                                return -- Suprimir estos mensajes
                            end
                        end
                        -- Permitir otros mensajes de progreso
                        vim.lsp.handlers["$/progress"](_, result, ctx)
                    end,
                }

                -- Iniciar servidor
                jdtls.start_or_attach(config)

                -- Configurar keymaps específicos de Java
                local function nnoremap(rhs, lhs, bufopts, desc)
                    bufopts.desc = desc
                    vim.keymap.set("n", rhs, lhs, bufopts)
                end

                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                -- Keybindings Java-específicos
                if type(jdtls.organize_imports) == "function" then
                    nnoremap("<leader>jo", jdtls.organize_imports, bufopts, "Organizar imports")
                end

                if type(jdtls.extract_variable) == "function" then
                    nnoremap("<leader>jv", jdtls.extract_variable, bufopts, "Extraer variable")
                end

                if type(jdtls.extract_constant) == "function" then
                    nnoremap("<leader>jc", jdtls.extract_constant, bufopts, "Extraer constante")
                end

                if type(jdtls.extract_method) == "function" then
                    nnoremap("<leader>jm", jdtls.extract_method, bufopts, "Extraer método")
                end

                if type(jdtls.test_nearest_method) == "function" then
                    nnoremap("<leader>jt", jdtls.test_nearest_method, bufopts, "Test método más cercano")
                end

                if type(jdtls.test_class) == "function" then
                    nnoremap("<leader>jT", jdtls.test_class, bufopts, "Test clase")
                end

                -- Formato automático al guardar (DESACTIVADO)
                -- Para formatear manualmente usa: <leader>f o :lua vim.lsp.buf.format()
                -- vim.api.nvim_create_autocmd("BufWritePre", {
                --     buffer = bufnr,
                --     callback = function()
                --         vim.lsp.buf.format({ bufnr = bufnr })
                --     end,
                -- })

                -- Configurar DAP si está disponible
                local has_dap, dap = pcall(require, 'dap')
                if has_dap and #bundles > 0 then
                    -- Verificar que no existan configuraciones previas
                    if not dap.configurations.java then
                        dap.configurations.java = {
                            {
                                type = 'java';
                                request = 'attach';
                                name = "Debug (Attach) - Remote";
                                hostName = "127.0.0.1";
                                port = 5005;
                            },
                            {
                                type = 'java';
                                request = 'launch';
                                name = "Debug (Launch) - Current File";
                                mainClass = "${file}";
                                projectName = project_name;
                            }
                        }
                    end

                    -- Debugging keybindings
                    nnoremap("<leader>jb", dap.toggle_breakpoint, bufopts, "Toggle breakpoint")
                    nnoremap("<leader>jB", function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, bufopts, "Conditional breakpoint")
                    nnoremap("<leader>jd", dap.continue, bufopts, "Debug continuar")
                    nnoremap("<leader>jn", dap.step_over, bufopts, "Debug step over")
                    nnoremap("<leader>ji", dap.step_into, bufopts, "Debug step into")
                    nnoremap("<leader>jo", dap.step_out, bufopts, "Debug step out")

                    -- Configuración avanzada para DAP si nvim-dap-ui está disponible
                    local has_dapui, dapui = pcall(require, "dapui")
                    if has_dapui then
                        -- Configurar solo si no está ya configurado
                        if not dap.listeners.after.event_initialized["dapui_config"] then
                            dap.listeners.after.event_initialized["dapui_config"] = function()
                                dapui.open()
                            end
                            dap.listeners.before.event_terminated["dapui_config"] = function()
                                dapui.close()
                            end
                            dap.listeners.before.event_exited["dapui_config"] = function()
                                dapui.close()
                            end
                        end

                        nnoremap("<leader>ju", dapui.toggle, bufopts, "Toggle DAP UI")
                    end

                    -- Configurar DAP con JDTLS
                    if type(jdtls.setup_dap) == "function" then
                        jdtls.setup_dap({ hotcodereplace = 'auto' })
                    end
                end

                vim.notify("JDTLS iniciado " .. (lombok_enabled and "con" or "sin") .. " soporte para Lombok" .. (#bundles > 0 and " y debugging" or ""), vim.log.levels.INFO)
            end
        })

        -- Comando para organizar imports manualmente
        vim.api.nvim_create_user_command("JavaOrganizeImports", function()
            if vim.bo.filetype ~= "java" then
                vim.notify("Este comando solo funciona en archivos Java", vim.log.levels.ERROR)
                return
            end

            local clients = vim.lsp.get_clients({name = "jdtls", bufnr = 0})
            if #clients == 0 then
                vim.notify("JDTLS no está activo para este buffer", vim.log.levels.ERROR)
                return
            end

            local _, jdtls = pcall(require, 'jdtls')
            if type(jdtls.organize_imports) == "function" then
                jdtls.organize_imports()
                vim.notify("Imports organizados", vim.log.levels.INFO)
            else
                vim.notify("La función organize_imports no está disponible", vim.log.levels.ERROR)
            end
        end, {})

        -- Mensaje inicial
        if lombok_enabled then
            vim.notify("Configuración JDTLS unificada con soporte para Lombok", vim.log.levels.INFO)
        else
            vim.notify("Configuración JDTLS unificada sin soporte para Lombok (JAR no encontrado)", vim.log.levels.WARN)
        end

        vim.notify("Comandos disponibles: JavaInfo, JavaClean, JavaRestart, JavaNewProject, JavaOrganizeImports", vim.log.levels.INFO)
    end
}