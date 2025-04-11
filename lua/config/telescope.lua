local telescope = require("telescope")
local telescope_ag = require("telescope-ag")

telescope.setup({
  defaults = {
    mappings = {
      i = {
        ["<C-u>"] = false,
        ["<C-d>"] = false,
      },
    },
  },
})

telescope_ag.setup({
    cmd = telescope_ag.cmds.rg, -- defaults to telescope_ag.cmds.ag
})

