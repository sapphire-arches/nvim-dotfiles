-- Bootstrap packer
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git', 'clone', '--depth', '1',
    'https://github.com/wbthomason/packer.nvim', install_path
  })
end

require('packer').startup(function(use)
  -- Don't let packer nuke itself
  use 'wbthomason/packer.nvim'

  -- Colorschemes
  use 'rebelot/kanagawa.nvim'

  -- LuaLine
  use {
    'nvim-lualine/lualine.nvim',
    requires='kyazdani42/nvim-web-devicons'
  }

  -- Pappy Pope's Plugins
  use 'tpope/vim-surround'
  use 'tpope/vim-repeat'
  use 'tpope/vim-fugitive'

  -- FZF but better?
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      {'nvim-lua/plenary.nvim'},
      {'nvim-treesitter/nvim-treesitter'},
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'nix-shell --command make -E "with import <nixpkgs> {}; runCommandCC \\"telescope-fzf-native\\" {} \\"\\""'
      }
    }
  }

  -- Neovim LSP support packages
  use { 'neovim/nvim-lspconfig' }
  use { 'simrat39/rust-tools.nvim' }

  -- Autocomplete via CSP
  use { 'hrsh7th/nvim-cmp' } -- Autocompletion plugin
  use { 'hrsh7th/cmp-path' } -- Path backend for cmp
  use { 'hrsh7th/cmp-nvim-lsp' } -- LSP source for nvim-cmp
  use { 'saadparwaiz1/cmp_luasnip' } -- Snippets source for nvim-cmp
  use { 'L3MON4D3/LuaSnip' } -- Snippets plugin (required as a component of cmp

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)

