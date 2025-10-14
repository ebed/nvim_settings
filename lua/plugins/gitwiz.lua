return {
	"creaccion/GitWiz", -- Corregido el nombre del plugin
	-- branch = "stage1",
	dir = "/Users/ralbertomerinocolipe/workspaces/personal/nvim/GitWizV2",
	cmd = { "GitWiz", "GitWizClose", "GitWizGraphSVG", "GitWizGraphSVGOpen", "GitWizGraphSVGOptions" },
	config = function()
		require("gitwiz").setup({
			log = { level = "DEBUG" },
			diff = {
				mode = "side_by_side",
				highlight_full_line = true,
				extmarks_bg = true,
				wrap_long_lines = true,
				wrap_auto = true,
				wrap_total_width = 120, -- used if wrap_auto = false
				wrap_side_padding = 2,
				wrap_min_side = 20,
				wrap_margin = 0,
				wrap_window_margin = 2,
				max_line_len = 240,
				enhanced_headers = true,
				show_file_headers = true,
				header_split_filename_path = true,
				header_compact_same_file = true,
				header_icons = { file = "󰈔", hunk = "" },
				header_labels = { file = "FILE", path = "PATH", date = "FECHA", hunk = "HUNK" },
			},
		})
	end,
}
