-- Standard Python files: full ruff linting
vim.lsp.config('pylsp', {
    filetypes = { 'python' },
    settings = {
        pylsp = {
            plugins = {
                pyflakes        = { enabled = false },
                pycodestyle     = { enabled = false },
                flake8          = { enabled = false },
                pylint          = { enabled = false },
                ruff            = { enabled = true },
                rope_autoimport = { enabled = true },
            },
        },
    },
})

-- Snakemake files: same server, but ruff disabled since it
-- can't parse the rule/input/output/conda/shell DSL syntax.
-- Still gives hover, completion, and goto-def on the Python portions.
vim.lsp.config('pylsp_snakemake', {
    cmd = { 'pylsp' },
    filetypes = { 'snakemake' },
    settings = {
        pylsp = {
            plugins = {
                pyflakes        = { enabled = false },
                pycodestyle     = { enabled = false },
                flake8          = { enabled = false },
                pylint          = { enabled = false },
                ruff            = { enabled = false },
                rope_autoimport = { enabled = true },
            },
        },
    },
})

vim.lsp.enable({ 'pylsp', 'pylsp_snakemake', 'bashls', 'r_language_server' })

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
