return {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = {
    { "tpope/vim-dadbod", lazy = true },
    { "pbogut/vim-dadbod-ssh", lazy = true },
    { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
  },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  init = function()
    vim.keymap.set("n", "<leader>DB", ":DBUI<CR>", {})
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_execute_on_save = 0
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_save_location = "~/workspaces/queries"
    vim.g.db_ui_winwidth = 30
    vim.g.dbs = {
      { name = "local postgres", url = "postgres://ralbertomerinocolipe@localhost:5432/discuss_dev" },
      { name = "local fos", url = "mysql://root@127.0.0.1:3306/flex_service_dev" },
      { name = "local sms", url = "mysql://root:root@127.0.0.1:3308/shift_management_service" },
      { name = "local sms standalone", url = "mysql://root:root@127.0.0.1:3306/shift_management_service" },
      {
        name = "sms staging",
        url = "mysql://root:u%28xI5he%5D4mo%236D%25Wa%2Bu%7DqS%5B8qHTpG7i%3D@127.0.0.1:13306/shift_management_service",
      },
    }
    -- -- MySQL: salida expandida por defecto
    -- vim.g["db#adapter#mysql#cli_options"] = "-E"
  end,
}
