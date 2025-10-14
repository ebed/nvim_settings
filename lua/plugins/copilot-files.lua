return {
	"creaccion/CopilotChatAssist",
      -- branch = 'code_review_assist',
	-- dir = "/Users/ralbertomerinocolipe/workspaces/personal/nvim/CopilotChatAssist",
	config = function()
		require("copilotchatassist").setup({
			log_level = vim.log.levels.INFO,
			-- log_level = vim.log.levels.DEBUG,
			language = "spanish",
			code_review_window_orientation = "vertical",
			silent_mode = false,
			code_review_keep_window_open = true,
			code_language = "english",
			context_dir = vim.fn.expand("~/.copilot_context")
		})
	end,
}
