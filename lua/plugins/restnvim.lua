return {
  "rest-nvim/rest.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      table.insert(opts.ensure_installed, "http")
    end,
  },
  config = function()
    vim.opt.splitright = true  -- Abre splits verticales a la derecha
    vim.opt.splitbelow = true  -- Abre splits horizontales abajo
    -- Configuración básica del plugin
    require("rest-nvim").setup({
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
        show_headers = false,
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
      result_split_in_place = false,
    })

    -- Configurar keymaps que usan los modificadores de comandos
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "http",
      callback = function()
        -- Ejecutar petición y abrir resultados en split vertical (derecha)
        vim.keymap.set("n", "<leader>re", ":vert Rest run<CR>", { buffer = true, desc = "Execute request" })
        -- Previsualizar petición
        vim.keymap.set("n", "<leader>rp", ":Rest curl yank<CR>", { buffer = true, desc = "Preview request" })
        -- Re-ejecutar última petición en split vertical (derecha)
        vim.keymap.set("n", "<leader>rl", ":vert Rest last<CR>", { buffer = true, desc = "Re-run last request" })
      end,
    })
  end,
}
