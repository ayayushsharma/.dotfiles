local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format({details = true})

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'buffer'},
  },
  --- (Optional) Show source name in completion menu
  formatting = cmp_format,
})

cmp.setup({
    mapping = cmp.mapping.preset.insert({
        -- confirm completion
        ['<tab>'] = cmp.mapping.confirm({ select = true }),

        -- scroll up and down the documentation window
        -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        -- ['<C-d>'] = cmp.mapping.scroll_docs(4),
    }),
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    }
})
