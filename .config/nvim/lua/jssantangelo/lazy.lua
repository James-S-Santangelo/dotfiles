-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Configure plugins
require("lazy").setup({
    rocks = { enabled = false },
    -- Treesitter (load first, before Telescope)
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            require('nvim-treesitter').setup({
                ensure_installed = { 'python', 'r', 'c', 'cpp', 'yaml', 'lua', 'vim', 'vimdoc', 'snakemake' },
                highlight = { enable = true },
            })
        end,
    },

    -- Telescope fuzzy finder (loads after Treesitter)
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

    -- Harpoon for quick file navigation
    'ThePrimeagen/harpoon',

    -- Comment plugin
    'numToStr/Comment.nvim',

    -- Undo tree
    'mbbill/undotree',

    -- Lualine 
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup {
                options = {
                    theme = 'auto',  -- Will automatically use your current colorscheme
                    -- You can also set a specific theme like:
                    -- theme = 'catppuccin'
                }
            }
        end,
    },

    -- Auto pairs
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        config = function()
            require('nvim-autopairs').setup {
                check_ts = true,  -- Enable treesitter integration
                disable_filetype = { "TelescopePrompt" },
            }
        end,
    },

    -- Clipboard support on Linux servers
    { 'ojroques/nvim-osc52', lazy = false },
})
