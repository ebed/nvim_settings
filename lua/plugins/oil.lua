return {
	'stevearc/oil.nvim',
	---@module 'oil'
	---@diagnostic disable-next-line
	---@type oil.SetupOpts
	opts = {
		-- Keymaps in oil buffer
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-v>"] = "actions.select_vsplit",
			["<C-x>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["q"] = "actions.close",  -- Added: q to close oil (easier)
			["<Esc>"] = "actions.close",  -- Added: Esc to close oil in normal mode
			["<C-r>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		-- Set to false to disable all of the above keymaps
		use_default_keymaps = true,
		view_options = {
			-- Show files and directories that start with "."
			show_hidden = false,
			-- This function defines what is considered a "hidden" file
			is_hidden_file = function(name, bufnr)
				return vim.startswith(name, ".")
			end,
			-- Sort file names in a more intuitive order for humans
			natural_order = true,
			sort = {
				-- sort order: directories first, then files
				{ "type", "asc" },
				{ "name", "asc" },
			},
		},
	},
	-- Optional dependencies
	dependencies = { { "nvim-mini/mini.icons", opts = {} } },
	-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
	-- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
	lazy = false,
	keys = {
		{ "-", "<cmd>Oil<cr>", desc = "Open parent directory (Oil)" },
		{ "<leader>-", function()
			-- Open Oil in current working directory (useful from explorer)
			require("oil").open(vim.fn.getcwd())
		end, desc = "Open Oil in cwd" },
	},
	config = function(_, opts)
		require("oil").setup(opts)

		-- Create command to open Oil in current working directory
		vim.api.nvim_create_user_command("OilHere", function()
			require("oil").open(vim.fn.getcwd())
		end, { desc = "Open Oil in current working directory" })

		-- Create command to open Oil in specific path
		vim.api.nvim_create_user_command("OilOpen", function(args)
			require("oil").open(args.args)
		end, { nargs = 1, complete = "dir", desc = "Open Oil in specific directory" })
	end,
}
