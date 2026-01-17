return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
        notifier = {
            enabled = true,
            timeout = 4000,
        },
        styles = {
            notification = {
                wo = { wrap = true }, -- Wrap notifications
            },
        },
    },
    init = function()
        vim.api.nvim_create_autocmd("User", {
            pattern = "VeryLazy",
            callback = function()
                -- Add Copilot toggle
                local copilot_exists = pcall(require, "copilot")
                if copilot_exists then
                    Snacks.toggle({
                        name = "Copilot Completion",
                        color = {
                            enabled = "azure",
                            disabled = "orange",
                        },
                        get = function()
                            return not require("copilot.client").is_disabled()
                        end,
                        set = function(state)
                            if state then
                                require("copilot.command").enable()
                            else
                                require("copilot.command").disable()
                            end
                        end,
                    }):map("<leader>at")
                end
            end,
        })
    end,
}
