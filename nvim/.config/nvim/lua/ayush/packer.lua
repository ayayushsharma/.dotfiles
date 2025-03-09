-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.8',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use({
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    })
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-treesitter/playground')
    use('theprimeagen/harpoon')
    use('mbbill/undotree')
    use('tpope/vim-fugitive')
    use { 'VonHeikemen/lsp-zero.nvim',
        branch = 'v3.x',
        requires = {
            --- Uncomment the two plugins below if you want to manage the language servers from neovim
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            { 'neovim/nvim-lspconfig' },
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'L3MON4D3/LuaSnip' },
        }
    }
    use 'm4xshen/autoclose.nvim'
    use 'numToStr/Comment.nvim'
    use 'lewis6991/gitsigns.nvim'
    use 'windwp/nvim-ts-autotag'
    use "folke/neodev.nvim"
    use "norcalli/nvim-colorizer.lua"
    use "vhyrro/luarocks.nvim"
    use {
        "nvim-neorg/neorg",
        requires = {
            { "nvim-neorg/lua-utils.nvim" },
            { "nvim-neotest/nvim-nio" },
            { "MunifTanjim/nui.nvim" },
            { "nvim-lua/plenary.nvim" },
            { "pysan3/pathlib.nvim" }
        },
        tag = "*" -- Pin Neorg to the latest stable release
    }
    use {
        'xeluxee/competitest.nvim',
        requires = 'MunifTanjim/nui.nvim',
    }
    use "meznaric/key-analyzer.nvim"
end)
