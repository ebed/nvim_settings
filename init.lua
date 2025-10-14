require("config.base_settings")
require("utils.folding")
vim.cmd("colorscheme desert")
vim.opt.shell = "bash"
vim.opt.shellcmdflag = "-c"
vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
vim.g.loaded_perl_provider = 0
-- vim.opt.autoindent = true
-- vim.opt.smartindent = true
require("config.lazy")
require("config.basics")
require("config.cmp")
require("config.dap")
require("config.gitsigns")
require("config.telescope")
require("config.mappings")
-- require('config.kafka.kafka')
-- require("jdtls_config_simple")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json" },
	callback = function()
		vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
	end,
})

-- vim.api.nvim_create_autocmd("VimEnter", {
--   once = true,
--   callback = function()
--     vim.cmd("CopilotTicket")
--   end,
-- })
-- vim.cmd("colorscheme kanagawa-wave")
require("config.lspconfig")
-- require("autocmds.neotreecmds")
