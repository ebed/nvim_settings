-- JDTLS configuración ultra simple basada en diagnóstico
local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local java_binary = java_home .. "/bin/java"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Ultra simple command
local cmd = {
    java_binary,
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Xms256m",
    "-Xmx512m",
    "-jar", launcher_jar,
    "-configuration", config_dir,
    "-data", workspace_dir
}

return {
    'mfussenegger/nvim-jdtls',
    config = function()
        -- Ensure workspace exists
        os.execute("mkdir -p " .. workspace_dir)

        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                local jdtls = require('jdtls')
                local config = {
                    cmd = cmd,
                    root_dir = require('jdtls.setup').find_root({'pom.xml', 'build.gradle', '.git'}),
                    settings = {
                        java = {
                            configuration = {
                                runtimes = {{
                                    name = "JavaSE-21",
                                    path = java_home,
                                }}
                            }
                        }
                    }
                }
                jdtls.start_or_attach(config)
            end
        })
    end,
}
