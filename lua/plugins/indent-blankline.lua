return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	---@module "ibl"
	---@type ibl.config
	opts = {},
	config = function()
		require("ibl").setup(
			{
				debounce = 100,
				indent = {
					char = "│",  -- Línea más bonita que "|"
					smart_indent_cap = true,
					repeat_linebreak = false,
				},
				whitespace = {
					highlight = { "Whitespace", "NonText" },
					remove_blankline_trail = true,
				},
				scope = {
					exclude = {},
					enabled = true,
					show_start = true,
					show_end = true,
					-- injected_languages = true,
					highlight = { "Function", "Label" },
					priority = 500,
				}
			}
		)
	end
}
