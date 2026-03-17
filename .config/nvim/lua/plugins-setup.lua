-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "nvim-lua/plenary.nvim", -- lua functions that many plugins use

  "bluz71/vim-nightfly-guicolors", -- preferred colorscheme

  "christoomey/vim-tmux-navigator", -- tmux & split window navigation

  "szw/vim-maximizer", -- maximizes and restores current window

  -- essential plugins
  "tpope/vim-surround", -- add, delete, change surroundings
  "inkarkat/vim-ReplaceWithRegister", -- replace with register contents using motion (gr + motion)

  -- commenting with gc
  "numToStr/Comment.nvim",

  -- file explorer
  "nvim-tree/nvim-tree.lua",

  -- vs-code like icons
  "nvim-tree/nvim-web-devicons",

  -- statusline
  "nvim-lualine/lualine.nvim",

  -- fuzzy finding w/ telescope
  { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  { "nvim-telescope/telescope.nvim", branch = "0.1.x" },

  -- autocompletion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",

  -- snippets
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
  "rafamadriz/friendly-snippets",

  -- managing & installing lsp servers, linters & formatters
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",

  -- configuring lsp servers
  "neovim/nvim-lspconfig",
  "hrsh7th/cmp-nvim-lsp",
  { "nvimdev/lspsaga.nvim", branch = "main" }, -- enhanced lsp uis
  {
    "pmizio/typescript-tools.nvim", -- typescript server with enhanced features
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  },
  "onsails/lspkind.nvim", -- vs-code like icons for autocompletion
  "nvimtools/none-ls.nvim", -- formatting & linting

  -- treesitter configuration
  {
    "nvim-treesitter/nvim-treesitter",
    build = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  },

  -- auto closing
  "windwp/nvim-autopairs",
  { "windwp/nvim-ts-autotag", dependencies = { "nvim-treesitter/nvim-treesitter" } },

  -- git integration
  "lewis6991/gitsigns.nvim",

  -- java lsp
  "mfussenegger/nvim-jdtls",
})
