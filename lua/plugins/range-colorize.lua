return {
    "winston0410/range-highlight.nvim",
    event = { "CmdlineEnter" },
    opts = {},
    config = function()
        -- Verifica si el buffer tiene un archivo asociado y si el filetype no es "http"
        if vim.api.nvim_buf_get_name(0) ~= "" and vim.bo.filetype ~= "http" then
            require("range-highlight").setup({
                -- Configuración normal
            })
        end
    end,
}
