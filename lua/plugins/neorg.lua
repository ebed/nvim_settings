 return {
      "nvim-neorg/neorg",
      lazy = false,
      version = "*",
      config = function()
        require("neorg").setup {
          load = {
            ["core.defaults"] = {},
            ["core.concealer"] = {},
         ["core.esupports.hop"] ={}, 
            ["core.summary"] = {},
            ["core.dirman"] = {
              config = {
                workspaces = {
                  notes = "~/workspaces/personal/neorg/notes",
                  estudios = "~/workspaces/personal/neorg/estudios/",
                  proyectos = "~/workspaces/personal/neorg/proyectos/",
                },
                default_workspace = "notes",
              },
            },
          },
        }
  
        vim.wo.foldlevel = 99
        vim.wo.conceallevel = 2
      end,
    }
