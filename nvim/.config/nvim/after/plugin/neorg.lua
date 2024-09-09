
HOME_DIR = os.getenv("HOME")
require("neorg").setup({
    load = {
        ["core.defaults"] = {},
        ["core.concealer"] = {
            config = {                  -- We added a `config` table!
                icon_preset = "varied", -- And we set our option here.
            },
        },
        ["core.dirman"] = {
            config = {
                workspaces = {
                    todo = HOME_DIR .. "/todo",
                },
            },
        },
    }
})
