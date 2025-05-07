return {
  "shellRaining/hlchunk.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("hlchunk").setup({
        chunk = {
            enable = true,
            chars = {
                horizontal_line = "─",
                vertical_line = "│",
                left_top = "┌",
                left_bottom = "└",
                right_arrow = "─",
            },
            style = "#00ffff",
        },
        indent = {
            enable = true
        }
     })
     vim.bo.shiftwidth = 4
  end
}
