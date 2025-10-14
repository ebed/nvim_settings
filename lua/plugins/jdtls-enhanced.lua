-- JDTLS: Configuración avanzada con todas las características
-- Incluye: Debugging, refactoring, snippets, formateo y más

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

-- Función para buscar plugins de Debugging (DAP)
local function find_bundles()
    local bundles = {}
    local has_mason, mason_registry = pcall(require, "mason-registry")

    -- Intentar cargar bundle desde Mason si está disponible
    if has_mason then
        local package = mason_registry.get_package("java-debug-adapter")
        if package then
            local path = package:get_install_path()
            local debug_bundles = vim.fn.glob(path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true)
            if debug_bundles ~= "" then
                vim.list_extend(bundles, vim.split(debug_bundles, "\n"))
            end
        end

        package = mason_registry.get_package("java-test")
        if package then
            local path = package:get_install_path()
            local test_bundles = vim.fn.glob(path .. "/extension/server/*.jar", true)
            if test_bundles ~= "" then
                vim.list_extend(bundles, vim.split(test_bundles, "\n"))
            end
        end
    end

    -- Buscar bundles locales
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

    return bundles
end

-- Crear los directorios necesarios para el proyecto
local function setup_project_directories(project_root)
    -- Crear directorios si no existen
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

return {
    'mfussenegger/nvim-jdtls',
    dependencies = {
        'mfussenegger/nvim-dap',              -- Para debugging
        'rcarriga/nvim-dap-ui',               -- UI para DAP
        'theHamsta/nvim-dap-virtual-text',    -- Texto virtual para DAP
    },
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

            local bundles = find_bundles()
            vim.notify("Bundles de Debugging encontrados: " .. #bundles, vim.log.levels.INFO)

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
                table.insert(cmd_parts, "-Xmx1G") -- Más memoria para proyectos grandes
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
                                gradle = {
                                    enabled = true,
                                },
                                maven = {
                                    enabled = true,
                                },
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
                            implementationsCodeLens = {
                                enabled = true,
                            },
                            referencesCodeLens = {
                                enabled = true,
                            },
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

                -- Iniciar servidor
                jdtls.start_or_attach(config)

                -- Configurar keymaps específicos de Java
                local function nnoremap(rhs, lhs, bufopts, desc)
                    bufopts.desc = desc
                    vim.keymap.set("n", rhs, lhs, bufopts)
                end

                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                -- Keybindings Java-específicos
                nnoremap("<leader>jo", jdtls.organize_imports, bufopts, "Organizar imports")
                nnoremap("<leader>jv", jdtls.extract_variable, bufopts, "Extraer variable")
                nnoremap("<leader>jc", jdtls.extract_constant, bufopts, "Extraer constante")
                nnoremap("<leader>jm", jdtls.extract_method, bufopts, "Extraer método")
                nnoremap("<leader>jt", jdtls.test_nearest_method, bufopts, "Test método más cercano")
                nnoremap("<leader>jT", jdtls.test_class, bufopts, "Test clase")

                -- Formato automático al guardar
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr })
                    end,
                })

                -- Configurar DAP si está disponible
                local has_dap, dap = pcall(require, 'dap')
                if has_dap and #bundles > 0 then
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
                        dap.listeners.after.event_initialized["dapui_config"] = function()
                            dapui.open()
                        end
                        dap.listeners.before.event_terminated["dapui_config"] = function()
                            dapui.close()
                        end
                        dap.listeners.before.event_exited["dapui_config"] = function()
                            dapui.close()
                        end

                        nnoremap("<leader>ju", dapui.toggle, bufopts, "Toggle DAP UI")
                    end

                    -- Configurar DAP con JDTLS
                    jdtls.setup_dap({ hotcodereplace = 'auto' })
                end

                vim.notify("JDTLS iniciado " .. (lombok_enabled and "con" or "sin") .. " soporte para Lombok" .. (#bundles > 0 and " y debugging" or ""), vim.log.levels.INFO)
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
        end, {})

        -- Mensaje inicial
        if lombok_enabled then
            vim.notify("Configuración JDTLS avanzada con soporte para Lombok", vim.log.levels.INFO)
        else
            vim.notify("Configuración JDTLS avanzada sin soporte para Lombok (JAR no encontrado)", vim.log.levels.WARN)
        end

        vim.notify("Comandos disponibles: JavaInfo, JavaClean, LombokStatus, JavaNewProject", vim.log.levels.INFO)
        vim.notify("Keybindings: <leader>jo (organizar imports), <leader>jv (extraer variable), <leader>jc (extraer constante), etc", vim.log.levels.INFO)
    end
}