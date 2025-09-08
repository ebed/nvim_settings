return {
	"creaccion/GitWiz",
	dir = "~/workspaces/personal/nvim/GitWizV2",
	config = function()
		require("gitwiz").setup({
			log = { level = "DEBUG", file = "/tmp/gitwiz.log" },
			diff = {
				mode = "side_by_side",
				highlight_full_line = true,
				force_fallback_bg = true,
				extmarks_bg = true,
				colors = {
					add_line = "#184f30",
					del_line = "#6f1f1f",
					change_line = "#6f5a1f",
				}
			}
		})
	end,
}
