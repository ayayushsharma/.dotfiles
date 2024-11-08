local lsp_zero = require('lsp-zero')
local lspconfig = require('lspconfig')

lsp_zero.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    lsp_zero.default_keymaps({ buffer = bufnr })
end)

-- to learn how to use mason.nvim
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guide/integrate-with-mason-nvim.md

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {
        "lua_ls",
        "pylsp",
        "ts_ls",
        "denols",
        "snyk_ls",
        "clangd",
        "gopls",
        "cssls"
    }
})

lspconfig.lua_ls.setup({
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME,
                    vim.env.PACKER_PLUGIN_PATH,
                    vim.api.nvim_get_runtime_file("", true)
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                },
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    }
})

lspconfig.pylsp.setup({})
lspconfig.clangd.setup({})
lspconfig.gopls.setup({})
lspconfig.cssls.setup({})
lspconfig.denols.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
}
lspconfig.ts_ls.setup {
  on_attach = on_attach,
  root_dir = lspconfig.util.root_pattern("package.json"),
  single_file_support = false
}

-- setting up snyk for code testing
local snyk_token = os.getenv("SNYK_TOKEN")
HOME_DIR = os.getenv("HOME")
if snyk_token then
    lspconfig.snyk_ls.setup({
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
