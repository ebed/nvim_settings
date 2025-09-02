local home = os.getenv("HOME")
local jdk21 = home .. "/.asdf/installs/java/zulu-21.42.19"
local lombok_jar = home .. "/workspaces/utils/lombok.jar"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local config_dir = home .. "/.cache/jdtls/config"
local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
-- local lombok_jar = home .. "/workspaces/utils/lombok.jar"
return {
  'nvim-java/nvim-java',
  config = function()
require('java').setup({
  log_level = "DEBUG", -- o "INFO", "WARN", "ERROR"
 
  spring_boot_tools = {
    enable = true,
    version = '1.59.0',
  },

  jdk = {
    -- install jdk using mason.nvim
    auto_install = false,
    version = '21.0.7',
  },
  jvm_args = {
        '-Djava.home=/Users/ralbertomerinocolipe/.asdf/installs/java/zulu-21.42.19/zulu-21.jdk/Contents/Home',
        "-Declipse.application=org.eclipse.jdt.ls.core.id1",
        "-Dosgi.bundles.defaultStartLevel=4",
        "-Declipse.product=org.eclipse.jdt.ls.core.product",
        "-Dlog.protocol=false",
        "-Dlog.level=ERROR",
        "-Xms1g",
        "-Xmx2g",
        "--add-modules=ALL-SYSTEM",
        "--add-opens", "java.base/java.util=ALL-UNNAMED",
        "--add-opens", "java.base/java.lang=ALL-UNNAMED",
        "-javaagent:" .. lombok_jar,
        "-configuration", config_dir,
        "-data", workspace_dir,
  },

  notifications = {
    -- enable 'Configuring DAP' & 'DAP configured' messages on start up
    dap = true,
  },
    java = {
      configuration = {
        autobuild = { enabled = false },
        referencesCodeLens = { enabled = false },
        implementationsCodeLens = { enabled = false },
        checkstyle = { enabled = false },
        signatureHelp = { enabled = true },
        format = { enabled = false },
        project = {
          importOnFirstTime = "automatic"
        },
        contentProvider = { preferred = "fernflower" },
          runtimes = {
            {
              name = "JavaSE-21",
              path = jdk21,
              default = true,
            }
          }
        }
    },
  --
  -- We do multiple verifications to make sure things are in place to run this
  -- plugin
  verification = {
    -- nvim-java checks for the order of execution of following
    -- * require('java').setup()
    -- * require('lspconfig').jdtls.setup()
    -- IF they are not executed in the correct order, you will see a error
    -- notification.
    -- Set following to false to disable the notification if you know what you
    -- are doing
    invalid_order = true,

    -- nvim-java checks if the require('java').setup() is called multiple
    -- times.
    -- IF there are multiple setup calls are executed, an error will be shown
    -- Set following property value to false to disable the notification if
    -- you know what you are doing
    duplicate_setup_calls = true,

    -- nvim-java checks if nvim-java/mason-registry is added correctly to
    -- mason.nvim plugin.
    -- IF it's not registered correctly, an error will be thrown and nvim-java
    -- will stop setup
    invalid_mason_registry = true,
  },

  mason = {
    -- These mason registries will be prepended to the existing mason
    registries = {
      'github:nvim-java/mason-registry',
    },
  }, 
      log_path = "/tmp/nvim-java.log", -- ruta donde quieres el log
})

vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = function()
    vim.cmd("LspStop jdtls")
  end,
})
  end
}
