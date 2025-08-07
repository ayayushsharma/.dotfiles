return {
    "nvim-neorg/neorg",
    lazy = false,
    version = "*",
    config = function()
        home = os.getenv("HOME")
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
