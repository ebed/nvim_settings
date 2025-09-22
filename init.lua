require("config.base_settings")
require("config.basics")
require("config.lazy")
require("config.cmp")
require("config.dap")
require("config.gitsigns")
require("config.lspconfig")
require("config.telescope")
require("config.mappings")
-- require('config.kafka.kafka')

vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number"
vim.g.loaded_perl_provider = 0
vim.opt.autoindent = true
vim.opt.smartindent = true


vim.api.nvim_create_autocmd("FileType",  {
      pattern = { "json" },
      callback = function()
        vim.api.nvim_set_option_value("formatprg", "jq", { scope = 'local' })
      end,
})

-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   callback = function(args)
--     local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")
--     local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
--     -- Only open Neo-tree if this is a real file and snacks is not the only buffer
--     if buftype == "" and filetype ~= "snacks" and #vim.fn.getbufinfo({buflisted = 1}) > 1 then
--       require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
--     end
--   end,
--   once = true,
-- })
--
-- local function is_neotree_open()
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     local bufname = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win))
--     if bufname:match("neo%-tree") then
--       return true
--     end
--   end
--   return false
-- end
--
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   callback = function(args)
--     -- Only trigger for real files, not for snacks buffer
--     local buftype = vim.api.nvim_buf_get_option(args.buf, "buftype")
--     local filetype = vim.api.nvim_buf_get_option(args.buf, "filetype")
--     if buftype == "" and filetype ~= "snacks" and not is_neotree_open() then
--       require("neo-tree.command").execute({ toggle = true, dir = vim.fn.getcwd() })
--     end
--   end,
--   once = true, -- Only run once per session
-- })
