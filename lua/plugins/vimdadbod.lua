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
        name = 'local postgres',
        url = 'postgres://ralbertomerinocolipe@localhost:5432/discuss_dev',
      },
      {
        name = 'local fos',
        url = 'mysql://root@127.0.0.1:3306/flex_service_dev'
      },
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
      {
        name = 'FOS Obj Serv App LT',
        url = function()
          return os.getenv("FLEX_OBJ_SERV_LT_DB_URL")
        end
      },
    }
   vim.g.db_ui_auto_execute_table_helpers = 1 
  end,
}
