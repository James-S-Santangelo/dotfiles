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
})
