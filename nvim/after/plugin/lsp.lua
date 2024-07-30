local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = { "lua_ls", "pylsp", "tsserver", "snyk_ls" }
})

require('lspconfig').lua_ls.setup({})
require('lspconfig').pylsp.setup({})
require('lspconfig').tsserver.setup({})


-- setting up snyk for code testing
local snyk_token = os.getenv("SNYK_TOKEN")
HOME_DIR = os.getenv("HOME")
if snyk_token then
    require('lspconfig').snyk_ls.setup({
        init_options = {
            ["token"] = snyk_token,
            ["authenticationMethod"] = "token",
            ["activateSnykIac"] = "false",
            ["trustedFolders"] = {
                HOME_DIR .. "/projects"
            }
        }
    })
end
