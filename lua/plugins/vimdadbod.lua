return {
  'kristijanhusak/vim-dadbod-ui',
  dependencies = {
    { 'tpope/vim-dadbod', lazy = true },
    { 'pbogut/vim-dadbod-ssh', lazy = true },
    { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
  },
  cmd = {
    'DBUI',
    'DBUIToggle',
    'DBUIAddConnection',
    'DBUIFindBuffer',
  },
  init = function()
    -- Your DBUI configuration
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_winwidth = 30
    vim.g.dbs = {
      { 
        name = 'LES STG',
        url = os.getenv("LES_STG_DB_8_URL")
      },
      { name = 'LES LT',
        url = function()
            return os.getenv("LES_LT_DB_8_URL")
        end
      },
      {
        name = 'LES EUPROD 8 LES CREATOR',
        url = os.getenv("LES_EUPROD_DB_8_URL")
      },
    }
    
  end,
}
