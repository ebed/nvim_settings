return {
  dir = "~/workspaces/personal/nvim/resting_nvim", -- Ruta local al plugin
  name = "resting_nvim",
  config = function()
    require("resting_nvim").setup({
      response_location = "bottom", -- Cambia a "right" o "bottom" según prefieras
    })
    vim.api.nvim_create_user_command("RestExample", function()
      require("resting_nvim").example()
    end, {})
  end,
}
