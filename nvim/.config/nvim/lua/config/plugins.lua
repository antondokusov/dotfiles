local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system {
		'git',
		'clone',
		'--depth',
		'1',
		'https://github.com/wbthomason/packer.nvim',
		install_path,
	}
	print 'Installing packer close and reopen Neovim...'
	vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

local packer = require 'packer'

packer.init {
	display = {
		open_fn = function() return require('packer.util').float { border = 'rounded' } end,
	},
}

return packer.startup(function(use)
	-- core
	use 'wbthomason/packer.nvim'
	use 'nvim-lua/popup.nvim'
	use 'nvim-lua/plenary.nvim'
	use 'kyazdani42/nvim-web-devicons'
	use 'folke/neodev.nvim'

	-- cmp
	use 'hrsh7th/nvim-cmp'
	use 'hrsh7th/cmp-nvim-lsp'
	use 'L3MON4D3/LuaSnip'
	use 'saadparwaiz1/cmp_luasnip'
	use 'hrsh7th/cmp-nvim-lsp-signature-help'
	use 'hrsh7th/cmp-buffer'
	use 'hrsh7th/cmp-cmdline'
	use 'hrsh7th/cmp-nvim-lsp-document-symbol'

	-- lsp
	use 'neovim/nvim-lspconfig'
	use 'williamboman/mason.nvim'
	use 'williamboman/mason-lspconfig.nvim'
	use 'jose-elias-alvarez/null-ls.nvim'

	-- git
	use 'lewis6991/gitsigns.nvim'
	use 'ThePrimeagen/git-worktree.nvim'

	-- telescope
	use 'nvim-telescope/telescope.nvim'
	use 'nvim-telescope/telescope-ui-select.nvim'
	use 'nvim-telescope/telescope-file-browser.nvim'
	--[[ use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' } ]]
	use 'natecraddock/telescope-zf-native.nvim'

	-- components
	use 'nvim-lualine/lualine.nvim'
	use 'dnlhc/glance.nvim'
	use 'ibhagwan/fzf-lua'

	-- other
	use 'windwp/nvim-autopairs'
	use 'numToStr/Comment.nvim'
	use 'levouh/tint.nvim'
	use 'b0o/incline.nvim'
	use 'jbyuki/venn.nvim'
	use 'smjonas/inc-rename.nvim'

	-- debug adapter
	use 'mfussenegger/nvim-dap'
	use 'rcarriga/nvim-dap-ui'
	use 'theHamsta/nvim-dap-virtual-text'
	use {
		'nvim-neotest/neotest',
		requires = {
			'antoinemadec/FixCursorHold.nvim',
			'sidlatau/neotest-dart',
		},
	}

	-- navigation
	use 'folke/which-key.nvim'
	use 'anuvyklack/keymap-layer.nvim'
	use 'anuvyklack/hydra.nvim'
	use { 'kevinhwang91/nvim-ufo', requires = 'kevinhwang91/promise-async' }
	use 'theprimeagen/harpoon'
	use {
		'SmiteshP/nvim-navbuddy',
		requires = {
			'SmiteshP/nvim-navic',
			'MunifTanjim/nui.nvim',
		},
	}

	use {
		'harrisoncramer/gitlab.nvim',
		requires = {
			'MunifTanjim/nui.nvim',
			'nvim-lua/plenary.nvim',
			'sindrets/diffview.nvim',
		},
		run = function() require('gitlab.server').build(true) end,
	}

	-- treesitter
	use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
	use 'JoosepAlviste/nvim-ts-context-commentstring'
	use 'nvim-treesitter/nvim-treesitter-context'

	-- lang specific
	--[[ use 'Olical/conjure' ]]
	--[[ use 'guns/vim-sexp' ]]
	--[[ use 'tpope/vim-sexp-mappings-for-regular-people' ]]

	-- colors
	use { 'rose-pine/neovim', as = 'rose-pine' }

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then require('packer').sync() end
end)
