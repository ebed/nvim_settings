return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  ft = { "http", "rest" }, -- Support both .http and .rest files
  config = function()
    vim.opt.splitright = true  -- Abre splits verticales a la derecha
    vim.opt.splitbelow = true  -- Abre splits horizontales abajo

    -- Force the installation of the HTTP parser - this is crucial
    pcall(function()
      vim.cmd("TSInstall! http")
      vim.notify("Installing HTTP parser for rest.nvim", vim.log.levels.INFO)
    end)

    -- Configuración básica del plugin

    -- Initialize rest-nvim with graceful error handling
    local ok, rest_nvim = pcall(require, "rest-nvim")
    if not ok then
      vim.notify("Failed to load rest-nvim: " .. tostring(rest_nvim), vim.log.levels.ERROR)
      return
    end

    -- Use pcall for setup to catch any initialization errors
    local ok_setup, err = pcall(function()
      rest_nvim.setup({
      -- Nivel de log como texto
      log_level = "info",
      -- Configuración de ventanas - esto es menos importante ahora
      -- porque usaremos los modificadores de comandos
      result_split_horizontal = false,
      result_split_in_place = false,
      -- Resto de la configuración
      skip_ssl_verification = false,
      encode_url = true,
      highlight = {
        enabled = true,
        timeout = 150,
      },
      result = {
        show_url = true,
        show_curl_command = false,
        show_http_info = true,
        show_headers = true,
        formatters = {
          json = "jq",
          html = function(body)
            return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
          end,
        },
      },
      jump_to_request = false,
      env_file = ".env",
      custom_dynamic_variables = {},
      yank_dry_run = true,
    })

    end)

    if not ok_setup then
      vim.notify("Failed to setup rest-nvim: " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    -- Keymaps are now handled in the ftplugin/http.lua file
  end,
}
