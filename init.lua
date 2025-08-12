require("config.base_settings")
require("config.basics")
require("config.lazy")
require("config.cmp")
require("config.dap")
require("config.gitsigns")
require("config.lspconfig")
require("config.telescope")
require("config.mappings")
require("config.copilotchat")
-- require('config.kafka.kafka')

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
vim.g.loaded_perl_provider = 0


vim.api.nvim_create_autocmd("FileType",  {
      pattern = { "json" },
      callback = function()
        vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
      end,
})

