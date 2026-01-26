-- Mappings initialization
-- Loads all keymap modules in a structured way

-- Load all mapping modules
require("config.mappings.general")    -- Basic vim operations, navigation, save, quit
require("config.mappings.telescope")  -- File and content search
require("config.mappings.git")        -- Git integration
require("config.mappings.lsp")        -- Language Server Protocol
require("config.mappings.dap")        -- Debug Adapter Protocol
require("config.mappings.plugins")    -- Plugin-specific keymaps
require("config.mappings.java")       -- JDTLS Java-specific
require("config.mappings.testing")    -- Testing frameworks
