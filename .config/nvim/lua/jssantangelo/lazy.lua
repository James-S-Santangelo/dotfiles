local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup(
    {
        -- Treesitter
        {
            'nvim-treesitter/nvim-treesitter',
            lazy = false,
            build = ':TSUpdate',
            config = function()
                -- New API: call install() directly instead of ensure_installed
                require('nvim-treesitter').install({
                    'python', 'r', 'cpp', 'yaml', 'snakemake',
                })
                -- Enable highlighting via Neovim's built-in treesitter
                vim.api.nvim_create_autocmd('FileType', {
                    pattern = '*',
                    callback = function(event)
                        pcall(vim.treesitter.start, event.buf)
                    end,
                })
            end,
        },

        -- Telescope
        {
            'nvim-telescope/telescope.nvim',
            branch = 'master',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-treesitter/nvim-treesitter',
            },
            config = function()
                require('telescope').setup{}
            end,
        },

        -- Color scheme
        {
            "catppuccin/nvim",
            name = "catppuccin",
            priority = 1000,
        },

        'ThePrimeagen/harpoon',
        'numToStr/Comment.nvim',
        'mbbill/undotree',

        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require('lualine').setup { options = { theme = 'auto' } }
            end,
        },

        {
            'windwp/nvim-autopairs',
            event = "InsertEnter",
            config = function()
                require('nvim-autopairs').setup {
                    check_ts = true,
                    disable_filetype = { "TelescopePrompt" },
                }
            end,
        },

        { 'ojroques/nvim-osc52', lazy = false },

        --LSP
        { 'neovim/nvim-lspconfig' },

        --Auto-completion for LSP
        {
            'saghen/blink.cmp',
            version = '1.*',
        },
    },
    {
        -- Options go here, separate from plugin specs
        rocks = { enabled = false },
    }
)
