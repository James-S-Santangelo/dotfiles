require('Comment').setup({
    ignore = '^$',
    toggler = {
        line = '<leader>cc',
        block = '<leader>bc',
    },
    opleader = {
        line = '<leader>c',
        block = '<leader>b',
    },
})

local ft = require('Comment.ft')
ft.set('snakemake', '# %s')
