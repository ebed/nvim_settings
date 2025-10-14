-- JDTLS configuración ultra mínima - versión final para resolver exit code 13
-- Sin filtros, sin Lombok, sin nada extra

local home = os.getenv("HOME")
local java_home = os.getenv("JAVA_HOME") or "/Library/Java/JavaVirtualMachines/zulu-21.jdk/Contents/Home"
local jdtls_path = home .. "/workspaces/utils/jdt-language-server-1.52.0-202510230337"
local config_dir = jdtls_path .. "/config_mac"
local launcher_jar = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar", true)

-- Esto es LO MÁS MÍNIMO posible
return {
    'mfussenegger/nvim-jdtls',
    config = function()
        vim.api.nvim_create_autocmd({"FileType"}, {
            pattern = {"java"},
            callback = function()
                -- Solo continuar si el archivo termina en .java
                local filename = vim.api.nvim_buf_get_name(0)
                if not filename:match("%.java$") then
                    return
                end

                -- Establecer un workspace por archivo para evitar problemas
                local file_basename = vim.fn.fnamemodify(filename, ":t:r")
                local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace-' .. file_basename

                -- Limpiar y crear workspace
                vim.fn.system("rm -rf " .. vim.fn.shellescape(workspace_dir))
                vim.fn.system("mkdir -p " .. vim.fn.shellescape(workspace_dir))

                -- Cargar jdtls
                require('jdtls').start_or_attach({
                    cmd = {
                        java_home .. "/bin/java",
                        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
                        "-Dosgi.bundles.defaultStartLevel=4",
                        "-Declipse.product=org.eclipse.jdt.ls.core.product",
                        "-Xms256m",
                        "-Xmx512m",
                        "-jar", launcher_jar,
                        "-configuration", config_dir,
                        "-data", workspace_dir
                    },
                    root_dir = vim.fn.getcwd(),
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
                })

                vim.notify("JDTLS ultra mínimo iniciado para: " .. file_basename, vim.log.levels.INFO)
            end
        })
    end
}