return {
  "catppuccin/nvim",
  as = "catppuccin",
  config = function()
require("catppuccin").setup({
    flavour = "frappe", -- latte, frappe, macchiato, mocha
    background = { -- :h background
        light = "latte",
        dark = "mocha",
    },
    transparent_background = false, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
        enabled = false, -- dims the background color of inactive window
        shade = "dark",
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
        comments = { "italic" }, -- Change the style of comments
        conditionals = { "italic" },
        loops = {},
        functions = {"bold"},
        keywords = { "bold" },
        strings = {},
        variables = {},
        numbers = {},
        booleans = {},
        properties = {},
        types = {},
        operators = {},
        -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    highlight_overrides = {
        mocha = function(C)
          return {
            LineNr = { fg = C.overlay2, style = {} },       -- color para números de línea
            CursorLineNr = { fg = C.peach, style = { "bold" } }, -- número de línea actual en bold y otro color
          }
        end,
                frappe = function(C)
          return {
            LineNr = { fg = C.overlay2, style = {} },       -- color para números de línea
            CursorLineNr = { fg = C.peach, style = { "bold" } }, -- número de línea actual en bold y otro color
          }
        end,
        macchiato = function(C)
          return {
            LineNr = { fg = C.overlay2, style = {} },       -- color para números de línea
            CursorLineNr = { fg = C.peach, style = { "bold" } }, -- número de línea actual en bold y otro color
          }
        end,

      },
    default_integrations = true,
    integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        notify = false,
        mini = {
            enabled = true,
            indentscope_color = "",
        },
        telescope = {
          enabled = true
        }
        -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
})
    vim.cmd("colorscheme catppuccin")
  end
}
