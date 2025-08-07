function LUA_LS()
    local lspconfig = require("lspconfig")
    local home = os.getenv("HOME")
    lspconfig.lua_ls.setup({
        on_init = function(client)
            local path = client.workspace_folders[1].name
            if
                vim.loop.fs_stat(path .. "/.luarc.json")
                or vim.loop.fs_stat(path .. "/.luarc.jsonc")
            then
                return
            end
            client.config.settings.Lua = (
                vim.tbl_deep_extend("force", client.config.settings.Lua, {
                    runtime = {
                        version = "LuaJIT",
                    },
                    workspace = {
                        checkThirdParty = false,
                        library = {
                            vim.env.VIMRUNTIME,
                            vim.env.PACKER_PLUGIN_PATH,
                            home .. "/.local/share/nvim/lazy/",
                            vim.api.nvim_get_runtime_file("", true),
                        },
                    },
                })
            )
        end,
        settings = {
            Lua = {},
        },
    })
end

function SYNK_LS()
    local lspconfig = require("lspconfig")
    local snyk_token = os.getenv("SNYK_TOKEN")
    local home = os.getenv("HOME")
    if snyk_token then
        lspconfig.snyk_ls.setup({
            init_options = {
                ["token"] = snyk_token,
                ["authenticationMethod"] = "token",
                ["activateSnykIac"] = "false",
                ["trustedFolders"] = {
                    home .. "/projects",
                },
            },
        })
    end
end

function DENOLS()
    local lspconfig = require("lspconfig")
    lspconfig.ts_ls.setup({
        root_dir = lspconfig.util.root_pattern("package.json"),
        single_file_support = false,
    })
end

function TERRAFORMLS()
    local lspconfig = require("lspconfig")
    local function early_return(_, result, ctx, config)
        if not result then
            return
        end
    end
    lspconfig.terraformls.setup({
        on_attach = function(client, bufnr)
            vim.lsp.handlers["textDocument/publishDiagnostics"] = early_return
        end,
    })
end

return {
    "neovim/nvim-lspconfig",

    dependencies = {
        "stevearc/conform.nvim",
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        require("conform").setup({
            formatters_by_ft = {
                lua = { "stylua" },
            },
        })

        local cmp = require("cmp")
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )

        require("fidget").setup({
            notification = {
                filter = vim.log.levels.WARN,
            },
        })

        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "snyk_ls",
                "ts_ls",
                "denols",
                "clangd",
                "cssls",
                "pylsp",
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                ["lua_ls"] = LUA_LS,
                ["snyk_ls"] = SYNK_LS,
                ["denols"] = DENOLS,
                ["terraformls"] = TERRAFORMLS,
            },
        })

        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
                ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
                ["<TAB>"] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
            }),
            sources = cmp.config.sources({
                { name = "copilot", group_index = 2 },
                { name = "nvim_lsp" },
                { name = "luasnip" },
            }, {
                { name = "buffer" },
            }),
            window = {
                documentation = cmp.config.window.bordered(),
            },
        })

        vim.diagnostic.config({
            -- update_in_insert = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "LSP actions",
            callback = function(event)
                local opts = { buffer = event.buf }
                vim.keymap.set(
                    "n",
                    "K",
                    "<cmd>lua vim.lsp.buf.hover({ border='single' })<cr>",
                    opts
                )
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                vim.keymap.set(
                    { "n", "x" },
                    "<F3>",
                    "<cmd>lua vim.lsp.buf.format({async = true})<cr>",
                    opts
                )
                vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
            end,
        })
    end,
}
