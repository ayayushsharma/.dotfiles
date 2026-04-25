return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    dependencies = {
        "nvim-neorg/tree-sitter-norg",
        "nvim-neorg/tree-sitter-norg-meta",
    },
    config = function()
        local home = os.getenv("HOME")
        require("neorg").setup({
            load = {
                ["core.defaults"] = {},
                ["core.concealer"] = {
                    config = {
                        icon_preset = "varied",
                    },
                },
                ["core.dirman"] = {
                    config = {
                        workspaces = {
                            todo = home .. "/todo",
                        },
                    },
                },
            },
        })
    end,
}
