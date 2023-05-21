-- tell nvim to treat Snakefiles as python 
-- this is approximate, could be fixed later with a paper LSP
vim.filetype.add({
    extension = {
        smk = 'python',
    },
    filename = {
        ['Snakefile'] = 'python',
    },
})
