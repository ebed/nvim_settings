return {
       "creaccion/CopilotChatAssist" ,
	dependencies = {
	"creaccion/CopilotFiles"
    },
	config = function()
		require("copilotfiles").setup()
	end,
}
