return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		build = "make tiktoken",
		opts = require("config.copilotchat.options"),
		config = function(_, opts)
			local CopilotChat = require("CopilotChat")
			CopilotChat.setup(opts)

			local context = require("config.copilotchat.context")
			local synthesize = require("config.copilotchat.synthesize")
			local pr_enhacement = require("config.copilotchat.pr_generator")

			-- User commands
			vim.api.nvim_create_user_command("CopilotChatSynthesizeAndSave", synthesize.synthesize_and_save_api, {})
			vim.api.nvim_create_user_command("CopilotChatLoadContextPrompt", context.load_context_as_prompt, {})
			vim.api.nvim_create_user_command("CopilotChatProjectContext", context.project_context_prompt, {})
			vim.api.nvim_create_user_command("CopilotTickets", context.ticket_context_prompt, {})
			vim.api.nvim_create_user_command("CopilotEnhancePR", pr_enhacement.enhance_pr_description, {})
			-- Highlight groups
			vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#7C3AED", bold = true })
			vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#374151" })

			-- Autocmd for context synthesis
			local function on_copilot_chat_buf_leave(args)
				pcall(context.on_buf_leave, args)
				-- pcall(synthesize.on_buf_leave, args)
			end

			vim.api.nvim_create_autocmd("BufWinLeave", {
				pattern = "*copilot-chat*",
				callback = on_copilot_chat_buf_leave,
			})
		end,
	},
}
