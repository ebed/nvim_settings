-- Este archivo es una configuración aislada para usar con nvim --cmd
-- Usa esto para probar JDTLS sin cargar tu configuración completa de Neovim
-- Ejecuta:
-- nvim --cmd "set rtp+=/Users/ralbertomerinocolipe/.local/share/nvim/lazy/nvim-jdtls" --cmd "lua require('config-for-lsp-only')"

local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)
local workspace_dir = "/tmp/jdtls-simple-workspace"

-- Configuración mínima de LSP
vim.lsp.set_log_level("debug")
vim.cmd("e /tmp/test.java")

-- Crear un archivo Java de prueba
local file = io.open("/tmp/test.java", "w")
if file then
    file:write([[
public class test {
    public static void main(String[] args) {
        System.out.println("Hello, World!");
    }
}
]])
    file:close()
end

-- Esperar un poco para asegurarse de que el archivo se guardó
vim.defer_fn(function()
    local cmd = {
        java_home .. "/bin/java",
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Xms256m",
        "-Xmx512m",
        "-jar", launcher_jar,
        "-configuration", config_dir,
        "-data", workspace_dir
    }

    local config = {
        cmd = cmd,
        root_dir = "/tmp",
        settings = {
            java = {
                configuration = {
                    runtimes = {
                        {
                            name = "JavaSE-21",
                            path = java_home
                        }
                    }
                }
            }
        }
    }

    vim.notify("Intentando iniciar JDTLS con configuración mínima...", vim.log.levels.INFO)

    -- Iniciar JDTLS con configuración mínima
    vim.lsp.start({
        name = "jdtls",
        cmd = cmd,
        root_dir = "/tmp",
    })

    -- Esperar un poco y mostrar clientes activos
    vim.defer_fn(function()
        local clients = vim.lsp.get_clients()
        if #clients > 0 then
            vim.notify("LSP activo con " .. #clients .. " cliente(s)", vim.log.levels.INFO)
            for _, client in ipairs(clients) do
                vim.notify("Cliente: " .. client.name, vim.log.levels.INFO)
            end
        else
            vim.notify("❌ No hay clientes LSP activos", vim.log.levels.ERROR)
        end
    end, 2000)
end, 1000)

vim.notify("Configuración cargada. Esperando inicio de JDTLS...", vim.log.levels.INFO)