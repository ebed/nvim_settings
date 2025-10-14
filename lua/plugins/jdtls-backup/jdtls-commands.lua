-- Comandos de mantenimiento JDTLS independientes de la carga del plugin
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local lombok_jar = home .. "/workspaces/utils/lombok.jar"

-- Define comandos globales independientes
vim.api.nvim_create_user_command("JdtFix", function()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
    local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name

    -- Detener todos los clientes LSP relacionados con Java
    for _, client in ipairs(vim.lsp.get_clients()) do
        if client.name == "jdtls" then
            vim.lsp.stop_client(client.id)
            vim.notify("Cliente JDTLS detenido", vim.log.levels.INFO)
        end
    end

    -- Eliminar workspace
    if vim.fn.isdirectory(workspace_dir) == 1 then
        local cmd = "rm -rf " .. vim.fn.shellescape(workspace_dir)
        os.execute(cmd)
        vim.notify("Workspace eliminado: " .. workspace_dir, vim.log.levels.INFO)
    end

    -- Limpiar logs
    local lsp_log = vim.fn.stdpath('state') .. '/lsp.log'
    if vim.fn.filereadable(lsp_log) == 1 then
        os.execute("echo '' > " .. vim.fn.shellescape(lsp_log))
        vim.notify("Log LSP limpiado", vim.log.levels.INFO)
    end

    -- Verificar archivos críticos
    if vim.fn.executable(java_binary) == 1 then
        vim.notify("✅ Java binary exists: " .. java_binary, vim.log.levels.INFO)
    else
        vim.notify("❌ Java binary not found: " .. java_binary, vim.log.levels.ERROR)
    end

    -- Verificar plugin jdtls
    local plugin_status, _ = pcall(require, 'jdtls')
    if plugin_status then
        vim.notify("✅ Plugin jdtls está disponible", vim.log.levels.INFO)
    else
        vim.notify("❌ Plugin jdtls no está disponible", vim.log.levels.ERROR)
        vim.notify("Verifique que el plugin esté instalado en Lazy", vim.log.levels.ERROR)
    end

    -- Mensaje final
    vim.notify("Por favor reinicie Neovim y abra un archivo .java", vim.log.levels.INFO)
end, {})

-- Comando para diagnosticar la configuración
vim.api.nvim_create_user_command("JdtDiag", function()
    -- Verificar JAVA_HOME
    local java_home_env = os.getenv("JAVA_HOME") or "no definido"
    vim.notify("JAVA_HOME: " .. java_home_env, vim.log.levels.INFO)

    -- Verificar archivos críticos
    local launcher_glob = jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"
    local launcher_jar = vim.fn.glob(launcher_glob, true)

    if vim.fn.filereadable(launcher_jar) == 1 then
        vim.notify("✅ Launcher jar exists: " .. launcher_jar, vim.log.levels.INFO)
    else
        vim.notify("❌ Launcher jar not found at: " .. launcher_glob, vim.log.levels.ERROR)
    end

    if vim.fn.filereadable(lombok_jar) == 1 then
        vim.notify("✅ Lombok jar exists: " .. lombok_jar, vim.log.levels.INFO)
    else
        vim.notify("❌ Lombok jar not found at: " .. lombok_jar, vim.log.levels.ERROR)
    end

    -- Verificar carga de plugins
    local lazy_status, lazy = pcall(require, 'lazy')
    if lazy_status then
        vim.notify("✅ Plugin manager Lazy está disponible", vim.log.levels.INFO)

        -- Intentar obtener estado del plugin jdtls
        vim.cmd("Lazy load nvim-jdtls")
        vim.notify("Intentando cargar plugin jdtls explícitamente", vim.log.levels.INFO)
    else
        vim.notify("❌ Plugin manager Lazy no está disponible", vim.log.levels.ERROR)
    end

    -- Verificar si hay clientes LSP activos
    local clients = vim.lsp.get_clients()
    local client_names = {}
    for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
    end

    if #client_names > 0 then
        vim.notify("Clientes LSP activos: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
    else
        vim.notify("No hay clientes LSP activos", vim.log.levels.WARN)
    end

    -- Comprobar si el archivo jdtls.lua existe y está bien
    local jdtls_config_path = home .. "/.config/nvim/lua/plugins/jdtls.lua"
    if vim.fn.filereadable(jdtls_config_path) == 1 then
        vim.notify("✅ Archivo de configuración jdtls.lua existe", vim.log.levels.INFO)
    else
        vim.notify("❌ Archivo de configuración jdtls.lua no existe", vim.log.levels.ERROR)
    end
end, {})

vim.api.nvim_create_user_command("JdtLimpio", function()
    vim.cmd("JdtFix")
end, {})

-- Notificar que se han cargado los comandos
vim.notify("Comandos de JDTLS registrados: JdtFix, JdtDiag, JdtLimpio", vim.log.levels.INFO)

return {
    "mfussenegger/nvim-jdtls",
    lazy = true, -- Solo cargar cuando sea necesario
}