-- =============================================================================
-- MARKDOWN NAVIGATION - Funciones personalizadas
-- =============================================================================
-- Navegación de enlaces en archivos markdown fuera de Obsidian vaults

local M = {}

-- Función para seguir enlaces markdown [texto](url)
function M.follow_markdown_link()
	local line = vim.api.nvim_get_current_line()
	local col = vim.api.nvim_win_get_cursor(0)[2] + 1

	-- Patrón para enlaces markdown: [texto](url)
	local link_pattern = "%[.-%]%((.-)%)"

	-- Buscar todos los enlaces en la línea
	for url in line:gmatch(link_pattern) do
		local start_pos = line:find("%[.-%]%(" .. vim.patsub(url, "([%(%)%[%]%.])", "%%%1") .. "%)", 1, false)
		if start_pos and col >= start_pos and col <= start_pos + #url + 10 then
			M.open_link(url)
			return
		end
	end

	-- Si no encuentra, intentar con wiki links [[archivo]]
	local wiki_pattern = "%[%[(.-)%]%]"
	for link in line:gmatch(wiki_pattern) do
		local start_pos = line:find("%[%[" .. vim.patsub(link, "([%[%]])", "%%%1") .. "%]%]", 1, false)
		if start_pos and col >= start_pos and col <= start_pos + #link + 4 then
			M.open_wiki_link(link)
			return
		end
	end

	-- Fallback: intentar con gx si está disponible
	vim.notify("No se encontró ningún enlace bajo el cursor", vim.log.levels.WARN)
end

-- Abrir diferentes tipos de enlaces
function M.open_link(url)
	-- Eliminar espacios
	url = vim.trim(url)

	if url:match("^https?://") or url:match("^www%.") then
		-- URL web - abrir en navegador
		vim.fn.jobstart({ "open", url }, { detach = true })
		vim.notify("Abriendo URL: " .. url, vim.log.levels.INFO)
	elseif url:match("^/") or url:match("^%.%.?/") or url:match("^~") then
		-- Ruta absoluta o relativa - abrir archivo
		M.open_file(url)
	else
		-- Asumir que es un archivo relativo
		M.open_file(url)
	end
end

-- Abrir archivo local
function M.open_file(filepath)
	-- Expandir ~ y rutas relativas
	local expanded = vim.fn.expand(filepath)

	-- Si es relativo, buscar desde el directorio del archivo actual
	if not expanded:match("^/") then
		local current_dir = vim.fn.expand("%:p:h")
		expanded = current_dir .. "/" .. expanded
	end

	-- Normalizar la ruta
	expanded = vim.fn.fnamemodify(expanded, ":p")

	if vim.fn.filereadable(expanded) == 1 then
		vim.cmd("edit " .. vim.fn.fnameescape(expanded))
		vim.notify("Abriendo archivo: " .. expanded, vim.log.levels.INFO)
	elseif vim.fn.isdirectory(expanded) == 1 then
		-- Si es directorio, abrirlo con Oil o explorador
		if pcall(require, "oil") then
			require("oil").open(expanded)
		else
			vim.cmd("edit " .. vim.fn.fnameescape(expanded))
		end
	else
		vim.notify("Archivo no encontrado: " .. expanded, vim.log.levels.ERROR)
	end
end

-- Abrir enlaces estilo wiki [[archivo]]
function M.open_wiki_link(link)
	-- Separar archivo y ancla si existe: [[archivo#sección]]
	local file, anchor = link:match("^(.-)#(.+)$")
	if not file then
		file = link
	end

	-- Buscar el archivo (puede tener o no extensión .md)
	local candidates = {
		file,
		file .. ".md",
		file .. ".markdown",
	}

	for _, candidate in ipairs(candidates) do
		M.open_file(candidate)
		return
	end
end

-- Buscar todos los enlaces en el buffer actual
function M.list_links()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local links = {}

	for i, line in ipairs(lines) do
		-- Enlaces markdown [texto](url)
		for text, url in line:gmatch("%[(.-)%]%((.-)%)") do
			table.insert(links, {
				line = i,
				type = "markdown",
				text = text,
				url = url,
			})
		end

		-- Enlaces wiki [[archivo]]
		for link in line:gmatch("%[%[(.-)%]%]") do
			table.insert(links, {
				line = i,
				type = "wiki",
				text = link,
				url = link,
			})
		end
	end

	if #links == 0 then
		vim.notify("No se encontraron enlaces en el archivo", vim.log.levels.INFO)
		return
	end

	-- Mostrar con telescope si está disponible
	if pcall(require, "telescope.pickers") then
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		pickers
			.new({}, {
				prompt_title = "Enlaces en el archivo",
				finder = finders.new_table({
					results = links,
					entry_maker = function(entry)
						return {
							value = entry,
							display = string.format("[%d] %s → %s", entry.line, entry.text, entry.url),
							ordinal = entry.text .. " " .. entry.url,
							lnum = entry.line,
						}
					end,
				}),
				sorter = conf.generic_sorter({}),
				attach_mappings = function(prompt_bufnr, map)
					actions.select_default:replace(function()
						local selection = action_state.get_selected_entry()
						actions.close(prompt_bufnr)
						-- Ir a la línea del enlace
						vim.api.nvim_win_set_cursor(0, { selection.value.line, 0 })
						-- Abrir el enlace
						M.open_link(selection.value.url)
					end)
					return true
				end,
			})
			:find()
	else
		-- Fallback: mostrar en quickfix
		local qf_list = {}
		for _, link in ipairs(links) do
			table.insert(qf_list, {
				bufnr = vim.api.nvim_get_current_buf(),
				lnum = link.line,
				text = string.format("[%s] %s → %s", link.type, link.text, link.url),
			})
		end
		vim.fn.setqflist(qf_list)
		vim.cmd("copen")
	end
end

return M
