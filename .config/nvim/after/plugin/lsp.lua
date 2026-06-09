-- Extend pylsp to also attach to snakemake files.
-- No dedicated Snakemake LSP exists; pylsp covers the Python
-- portions of .smk files which is the majority of what's useful.
vim.lsp.config('pylsp', {
    filetypes = { 'python', 'snakemake' },
    settings = {
        pylsp = {
            plugins = {
                pycodestyle     = { enabled = false },
                flake8          = { enabled = false },
                pyflakes        = { enabled = false },
                pylint          = { enabled = false },
                ruff            = { enabled = true },
                rope_autoimport = { enabled = true },
            },
        },
    },
})

vim.lsp.enable({ 'pylsp', 'bashls', 'r_language_server' })

vim.diagnostic.config({
    virtual_text = true,   -- show message inline after the line
    signs = true,
    underline = true,
    update_in_insert = false,
    float = {
        border = 'rounded',
        source = true,     -- show which linter/server raised it
    },
})

-- Keymaps on LSP attach. Neovim 0.11+ already provides grn (rename),
-- gra (code action), and grr (references) by default.
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gd',         vim.lsp.buf.definition,    opts)
        vim.keymap.set('n', 'K',          vim.lsp.buf.hover,         opts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename,        opts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action,   opts)
        vim.keymap.set('n', '<leader>f',  vim.lsp.buf.format,        opts)
        vim.keymap.set('n', '[d',         vim.diagnostic.goto_prev,  opts)
        vim.keymap.set('n', ']d',         vim.diagnostic.goto_next,  opts)
        vim.keymap.set('n', '<leader>d',  vim.diagnostic.open_float, opts)
    end,
})
