return {
	'm4xshen/autoclose.nvim',
	config = function()
		require("autoclose").setup({
			options = {
				disabled_filetypes = { "text", "markdown", "copilot-chat" },
			},
			keys = {
				["("] = { escape = false, close = true, pair = "()" },
				["["] = { escape = false, close = true, pair = "[]" },
				["{"] = { escape = false, close = true, pair = "{}" },

				[">"] = { escape = true, close = false, pair = "<>" },
				[")"] = { escape = true, close = false, pair = "()" },
				["]"] = { escape = true, close = false, pair = "[]" },
				["}"] = { escape = true, close = false, pair = "{}" },
				["do"] = { escape = true, close = false, pailr = "do end"},

				['"'] = { escape = true, close = true, pair = '""' },
				["'"] = { escape = true, close = true, pair = "''" },
				["`"] = { escape = true, close = true, pair = "``" },
			},
		})
	end
}
