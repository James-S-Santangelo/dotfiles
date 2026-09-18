vim.filetype.add({
    extension = {
        smk = 'snakemake',
    },
    filename = {
        ['Snakefile'] = 'snakemake',
    },
    pattern = {
        ['Singularity.*'] = 'bash',
    },
vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.linebreak = true
        vim.opt_local.colorcolumn = ''
    end,
})
})
