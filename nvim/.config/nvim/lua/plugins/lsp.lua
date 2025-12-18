---List language servers to install
---@return elem_or_list
function INSTALLED_LANGUAGES()
    ---Returns true if language env var is available
    ---in form "IS_INSTALLED_<LANG>"
    ---@param language string
    ---@return boolean
    local function lang_is_installed(language)
        language = string.upper(language)
        local env_var = "IS_INSTALLED_" .. language
        local env_value = os.getenv(env_var)
        if env_value == nil then
            return false
        end
        return true
    end

    local lsp_to_install = {
        "lua_ls",
    }

    if lang_is_installed("python3") then
        table.insert(lsp_to_install, "pylsp")
    end

    if lang_is_installed("node") then
        table.insert(lsp_to_install, "cssls")
        table.insert(lsp_to_install, "ts_ls")
    end

    if lang_is_installed("cpp") then
        table.insert(lsp_to_install, "clangd")
    end

    if lang_is_installed("deno") then
        table.insert(lsp_to_install, "denols")
    end

    if lang_is_installed("go") then
        table.insert(lsp_to_install, "gopls")
    end

    if lang_is_installed("rust") then
        table.insert(lsp_to_install, "rust_analyzer")
    end

    if os.getenv("SNYK_TOKEN") ~= nil then
        table.insert(lsp_to_install, "snyk_ls")
    end

    return lsp_to_install
end

---inits Lua Language server
function LUA_LS()
    require("lspconfig").lua_ls.setup({
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

---inits Snyk Language Server
function SYNK_LS()
    local snyk_token = os.getenv("SNYK_TOKEN")
    local home = os.getenv("HOME")
    if not snyk_token then
        return
    end
    require("lspconfig").snyk_ls.setup({
        init_options = {
            ["token"] = snyk_token,
            ["authenticationMethod"] = "token",
            ["activateSnykIac"] = "false",
            ["trustedFolders"] = {
                home .. "/projects",
                home .. "/todo",
                home .. "/.dotfiles",
                home .. "/go",
            },
        },
    })
end

---inits deno language server
function DENOLS()
    local lspconfig = require("lspconfig")
    lspconfig.ts_ls.setup({
        root_dir = lspconfig.util.root_pattern("package.json"),
        single_file_support = false,
    })
end

---inits terraform language server
function TERRAFORMLS()
    local function early_return(_, result, ctx, config)
        if not result then
            return
        end
    end
    require("lspconfig").terraformls.setup({
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

        require("mason").setup()

        require("mason-lspconfig").setup({
            ensure_installed = INSTALLED_LANGUAGES(),
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

        local fidget = require("fidget")
        vim.lsp.handlers["window/showMessage"] = function(_, result, ctx)
            local client = vim.lsp.get_client_by_id(ctx.client_id)
            local level = ({
                "ERROR",
                "WARN",
                "INFO",
                "DEBUG",
            })[result.type] or "INFO"

            ---Splits line into 2 parts after N characters
            ---@param line string
            ---@param character_limit number|nil
            ---@return unknown
            local function reformat(line, character_limit)
                character_limit = character_limit or 40
                local lines = {}
                local currentLine = {}
                local character_count = 0

                for word in line:gmatch("%S+") do
                    character_count = character_count + string.len(word)
                    table.insert(currentLine, word)
                    if character_count / character_limit > 1 then
                        table.insert(lines, table.concat(currentLine, " "))
                        currentLine = {}
                        character_count = 0
                    end
                end

                if #currentLine > 0 then
                    table.insert(lines, table.concat(currentLine, " "))
                end

                return table.concat(lines, "\n")
            end

            fidget.notify(
                reformat(string.format("LSP[%s] %s", client and client.name or "?", result.message)),
                vim.log.levels[level]
            )
        end

        vim.keymap.set("n", "<leader>ld", function()
            if vim.diagnostic.is_enabled() then
                vim.diagnostic.enable(false)
                return
            end
            vim.diagnostic.enable()
        end)
    end,
}
