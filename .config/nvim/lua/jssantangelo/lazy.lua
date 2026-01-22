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
  -- Treesitter (load first, before Telescope)
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
      -- Install parsers on startup
      local ts = require('nvim-treesitter')
      local parsers_to_install = { 'python', 'r', 'c', 'cpp', 'yaml', 'lua', 'vim', 'vimdoc', 'snakemake' }
      
      -- Install each parser (this is a no-op if already installed)
      ts.install(parsers_to_install)
      
      -- Enable syntax highlighting with treesitter for all filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(event)
          pcall(vim.treesitter.start, event.buf)
        end,
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
      -- Workaround for Treesitter API compatibility issues
      local ts_ok, ts_parsers = pcall(require, 'nvim-treesitter.parsers')
      if ts_ok then
        -- Add missing ft_to_lang function
        if not ts_parsers.ft_to_lang then
          ts_parsers.ft_to_lang = function(ft)
            local ft_to_lang_map = {
              python = "python",
              lua = "lua",
              vim = "vim",
              vimdoc = "vimdoc",
              bash = "bash",
              sh = "bash",
              r = "r",
              c = "c",
              cpp = "cpp",
              snakemake = "snakemake",
            }
            return ft_to_lang_map[ft] or ft
          end
        end
        
        -- Add missing is_enabled function
        if not ts_parsers.is_enabled then
          ts_parsers.is_enabled = function(lang, bufnr)
            local parser_available = pcall(vim.treesitter.language.add, lang)
            return parser_available
          end
        end
      end
      
      -- Setup telescope
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
})
