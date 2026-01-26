return {
  { "neovim/nvim-lspconfig" },
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  { "williamboman/mason-lspconfig.nvim" },

  -- Autocompletado y Snippets
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
  },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  -- Treesitter para mejor sintaxis
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- { 'akinsho/toggleterm.nvim'},
  -- Telescope para búsqueda fuzzy
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Integración de Git
  { "lewis6991/gitsigns.nvim" },
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" },
  -- { "mfussenegger/nvim-jdtls" },
}
