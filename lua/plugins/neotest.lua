return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"jfpedroza/neotest-elixir",
		"rcasia/neotest-java",
		"mfussenegger/nvim-jdtls",
		"theHamsta/nvim-dap-virtual-text",
		-- Ensure elixir-tools is loaded before neotest to register the DAP adapter
		"elixir-tools/elixir-tools.nvim",
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-java")({
					runner = "gradle",
					gradle = { wrapper = true },
					junit = { use_console_launcher = false },
				}),
				require("neotest-elixir")({
					umbrella = true,
					dap_adapter = "mix_task",
					args = { "--trace" }, -- only valid arguments for mix test
					test_file_pattern = "_test.exs$",
					-- filter out any accidental "apps" argument passed to mix
					post_process_command = function(cmd)
						local filtered = {}
						for _, s in ipairs(cmd) do
							if s ~= "apps" then
								table.insert(filtered, s)
							end
						end
						return filtered
					end,
				}),
			},
		})
	end
}
