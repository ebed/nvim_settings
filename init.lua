require("config.base_settings")
vim.cmd("colorscheme desert")
vim.opt.shell = "bash"
vim.opt.shellcmdflag = "-c"
vim.cmd("autocmd User TelescopePreviewerLoaded setlocal number")
vim.g.loaded_perl_provider = 0
require("config.lazy")
-- Fix markdown colors (remove red backgrounds)
-- Temporarily disabled to debug crashes
-- require("config.markdown_colors").setup()
require("config.basics")
require("config.cmp")
require("config.dap")
require("config.gitsigns")
require("config.telescope")
require("config.mappings")
-- require('config.kafka.kafka')
-- require("jdtls_config_simple")
require("config.lspconfig")
-- JDTLS fixes: suppress noisy messages and Copilot errors
require("config.jdtls_fixes")
-- Sistema de mantenimiento de caché para evitar errores ENOSPC
require("utils.cache_maintenance").setup()

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json" },
  callback = function()
    vim.api.nvim_set_option_value("formatprg", "jq", { scope = "local" })
  end,
})
-- require("utils.db_sql_maps")
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "elixir", "heex", "eex" },
  callback = function(ev)
    -- Intenta iniciar treesitter de forma segura
    local status, _ = pcall(vim.treesitter.start, ev.buf)
    if not status then
      print("Error iniciando Tree-sitter en buffer: " .. ev.buf)
    end
  end,
})
