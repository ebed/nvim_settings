return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",

		-- Test adapters for different languages
		"olimorris/neotest-rspec", -- Ruby RSpec
		"zidhuss/neotest-minitest", -- Ruby Minitest
		"jfpedroza/neotest-elixir", -- Elixir ExUnit
		"rcasia/neotest-java", -- Java (Gradle/Maven)

		-- Required for JDTLS
		"mfussenegger/nvim-jdtls",
		"theHamsta/nvim-dap-virtual-text",
	},
	config = function()
		-- Safe adapter loader with error handling
		local function load_adapter(adapter_name, config)
			local ok, adapter = pcall(require, adapter_name)
			if ok then
				if config then
					return adapter(config)
				else
					return adapter
				end
			else
				vim.notify(
					string.format("Neotest adapter '%s' not found. Install it with :Lazy sync", adapter_name),
					vim.log.levels.WARN
				)
				return nil
			end
		end

		local adapters = {}

		-- Ruby RSpec adapter
		local rspec = load_adapter("neotest-rspec", {
			rspec_cmd = function()
				return vim.tbl_flatten({
					"bundle",
					"exec",
					"rspec",
				})
			end,
			transform_spec_path = function(path)
				local prefix = require("neotest-rspec").root(path)
				return string.sub(path, string.len(prefix) + 2, -1)
			end,
			results_path = "tmp/rspec.output",
		})
		if rspec then table.insert(adapters, rspec) end

		-- Ruby Minitest adapter
		local minitest = load_adapter("neotest-minitest")
		if minitest then table.insert(adapters, minitest) end

		-- Elixir ExUnit adapter
		local elixir = load_adapter("neotest-elixir", {
			umbrella = true,
			dap_adapter = "mix_task",
			args = { "--trace" },
			test_file_pattern = "_test.exs$",
			post_process_command = function(cmd)
				local filtered = {}
				for _, s in ipairs(cmd) do
					if s ~= "apps" then
						table.insert(filtered, s)
					end
				end
				return filtered
			end,
		})
		if elixir then table.insert(adapters, elixir) end

		-- Java adapter
		local java = load_adapter("neotest-java", {
			runner = "gradle",
			gradle = { wrapper = true },
			junit = { use_console_launcher = false },
		})
		if java then table.insert(adapters, java) end

		-- Setup neotest with loaded adapters
		require("neotest").setup({
			adapters = adapters,
			discovery = {
				enabled = true,
				concurrent = 8,
			},
			running = {
				concurrent = true,
			},
			summary = {
				enabled = true,
				animated = true,
				follow = true,
				expand_errors = true,
			},
			output = {
				enabled = true,
				open_on_run = false,
			},
			diagnostic = {
				enabled = true,
				severity = vim.diagnostic.severity.ERROR,
			},
			status = {
				enabled = true,
				virtual_text = true,
				signs = true,
			},
			icons = {
				passed = "✓",
				running = "●",
				failed = "✗",
				skipped = "○",
				unknown = "?",
				non_collapsible = "─",
				collapsed = "─",
				expanded = "╮",
				child_prefix = "├",
				final_child_prefix = "╰",
				child_indent = "│",
				final_child_indent = " ",
			},
		})
	end,
}