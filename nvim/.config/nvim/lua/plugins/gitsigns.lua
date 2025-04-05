return {
    "lewis6991/gitsigns.nvim",
    config = function()
        require("gitsigns").setup()

        vim.keymap.set({ "n" }, "<C-b>", function()
            vim.cmd(":Gitsigns blame")
        end)
    end,
}
