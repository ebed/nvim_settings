-- =============================================================================
-- MARKDOWN KEYMAPS
-- =============================================================================
-- Keymaps específicos para navegación en archivos markdown

-- Solo cargar en buffers markdown
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "markdown", "md" },
	callback = function()
		local map = vim.keymap.set
		local opts = { buffer = true, silent = true }
		local nav = require("config.markdown_navigation")

		-- Navegación de enlaces
		map("n", "gf", nav.follow_markdown_link, vim.tbl_extend("force", opts, {
			desc = "Follow markdown link",
		}))

		map("n", "<CR>", function()
			-- Si está sobre un enlace, seguirlo
			-- Si no, comportamiento normal de Enter
			local line = vim.api.nvim_get_current_line()
			if line:match("%[.-%]%((.-)%)") or line:match("%[%[(.-)%]%]") then
				nav.follow_markdown_link()
			else
				-- Comportamiento normal de Enter (nueva línea)
				vim.cmd("normal! o")
			end
		end, vim.tbl_extend("force", opts, {
			desc = "Follow link or new line",
		}))

		-- Listar todos los enlaces
		map("n", "<leader>ml", nav.list_links, vim.tbl_extend("force", opts, {
			desc = "List all links in file",
		}))

		-- Navegación adicional (ya configurado en obsidian.lua para vaults)
		-- <leader>ol ya existe para ObsidianFollowLink en vaults
	end,
})
