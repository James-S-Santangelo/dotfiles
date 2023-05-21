-- tell nvim to treat Snakefiles as python 
vim.filetype.add({
    extension = {
        smk = 'python',
    },
    filename = {
        ['Snakefile'] = 'python',
    },
})
