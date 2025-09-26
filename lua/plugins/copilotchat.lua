return {
    "CopilotC-Nvim/CopilotChat.nvim",
    dependencies = {
      { "creaccion/CopilotChatAssist" },
      { "nvim-lua/plenary.nvim" },
    },
  build = "make tiktoken",
  config = function()
    local conf = require("copilotchatassist").get_copilotchat_config()
    -- print("Config recovered: " .. vim.inspect(conf))
    local copilotchat = require("CopilotChat")
    -- print("CopilotChat module:", vim.inspect(copilotchat))
    copilotchat.setup(conf)
  end,
  -- config = function()
  --   -- Aquí NO inicialices CopilotChat, deja que CopilotChatAssist lo haga
  -- end,
}
--
-- local context = require("CopilotChatAssist.copilotchat.context") w
-- local synthesize = require("CopilotChatAssist.copilotchat.synthesize")
-- local pr_enhacement = require("CopilotChatAssist.copilotchat.pr_generator")

-- -- User commands
-- vim.api.nvim_create_user_command("CopilotChatSynthesizeAndSave", synthesize.synth esize_and_save_api, {})
-- vim.api.nvim_create_user_command("CopilotChatLoadContextPrompt", context.load_context_as_prompt, {})
-- vim.api.nvim_create_user_command("CopilotChatProjectContext", context.project_context_prompt, {})
-- vim.api.nvim_create_user_command("CopilotTickets", context.ticket_context_prompt, {})
-- vim.api.nvim_create_user_command("CopilotEnhancePR", pr_enhacement.enhance_pr_description, {})
--
-- -- Debug system prompt
-- vim.api.nvim_create_user_command("CopilotChatDebugSystemPrompt", function()
--   local cfg = require("CopilotChat.config")
--   local sp = cfg.system_prompt or ""
--   print("System prompt length: " .. #sp)
--   -- Open a scratch buffer preview
--   vim.cmd("new")
--   local buf = vim.api.nvim_get_current_buf()
--   vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(sp, "\n"))
--   vim.bo.buftype = "nofile"
--   vim.bo.bufhidden = "wipe"
--   vim.bo.swapfile = false
--   vim.api.nvim_buf_set_name(buf, "CopilotSystemPromptPreview")
-- end, {})
--
-- -- Highlight groups
-- vim.api.nvim_set_hl(0, "CopilotChatHeader", { fg = "#7C3AED", bold = true })
-- vim.api.nvim_set_hl(0, "CopilotChatSeparator", { fg = "#374151" })
--
-- -- Autocmd for context synthesis on leaving chat buffer
-- local function on_copilot_chat_buf_leave(args)
--   pcall(context.on_buf_leave, args)
-- end
-- vim.api.nvim_create_autocmd("BufWinLeave", {
--   pattern = "*copilot-chat*",
--   callback = on_copilot_chat_buf_leave,
-- })
