require('blink.cmp').setup({

    keymap = { preset = 'default' },

    appearance = {
        nerd_font_variant = 'mono',
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 400,
        },
        accept = {
            auto_brackets = { enabled = false },
        },
    },

    -- Top-level, not nested under completion
    signature = { enabled = true },

    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },

    fuzzy = {
        implementation = 'lua',
    },
})
