return {
	"nvim-neorg/neorg",
	dependencies = {

		{
			"juniorsundar/neorg-extras",
			-- tag = "*" -- Always a safe bet to track current latest release
		},
		-- FOR Neorg-Roam Features
		--- OPTION 1: Telescope
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim",
		-- OR OPTION 2: Fzf-Lua
		"ibhagwan/fzf-lua",
		-- OR OPTION 3: Snacks
		"folke/snacks.nvim"
	},
	lazy = false,
	version = "*",
	config = function()
		require("neorg").setup {
			load = {
				["external.many-mans"] = {
					config = {
						metadata_fold = true, -- If want @data property ... @end to fold
						code_fold = true, -- If want @code ... @end to fold
					}
				},
				-- OPTIONAL
				["external.agenda"] = {
					config = {
						workspace = nil, -- or set to "tasks_workspace" to limit agenda search to just that workspace
					}
				},
				["external.roam"] = {
					config = {
						fuzzy_finder = "Telescope", -- OR "Fzf" OR "Snacks". Defaults to "Telescope"
						fuzzy_backlinks = false, -- Set to "true" for backlinks in fuzzy finder instead of buffer
						roam_base_directory = "", -- Directory in current workspace to store roam nodes
						node_no_name = false, -- no suffix name in node filename
						node_name_randomiser = false, -- Tokenise node name suffix for more randomisation
						node_name_snake_case = false, -- snake_case the names if node_name_randomiser = false
					}
				},
				["core.defaults"] = {}, -- Load all the default modules
				["core.concealer"] = {}, -- Adds pretty icons to your documents
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						workspaces = {
							notes = "~/workspaces/personal/neorg/notes",
							estudios = "~/workspaces/personal/neorg/estudios",
							proyectos = "~/workspaces/personal/neorg/proyectos",
						},
						default_workspace = "notes",
					},
				},
				["core.keybinds"] = { -- Configure keybinds
					config = {
						default_keybinds = true, -- Enable default keybinds
						neorg_leader = "<Leader>o", -- Set the leader key for Neorg
						hook = function(keybinds)
							-- Map Enter to open links
							keybinds.map("norg", "n", "<CR>", function()
								local neorg = require("neorg")
								local dirman = neorg.modules.get_module("core.dirman")
								local link = vim.fn.expand("<cfile>")

								if link:match("^https?://") then
									-- Open URL
									vim.fn.jobstart({ "open", link },
										{ detach = true })
								elseif dirman and dirman.public.open_file then
									-- Open local file using core.dirman
									dirman.public.open_file(link)
								else
									print("No valid link under cursor")
								end
							end)
						end,
					},
				},
			},
		}

		vim.wo.foldlevel = 99
		vim.wo.conceallevel = 2
	end,
}
