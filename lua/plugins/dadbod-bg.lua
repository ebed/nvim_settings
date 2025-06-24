return {
    'napisani/nvim-dadbod-bg',
    build = './install.sh',
    -- (optional) the default port is 4546
    -- (optional) the log file will be created in the system's temp directory 
    config = function()
      vim.cmd([[
        let g:nvim_dadbod_bg_port = '4546'
        let g:nvim_dadbod_bg_log_file = '/tmp/nvim-dadbod-bg.log'
      ]])
    end
}
