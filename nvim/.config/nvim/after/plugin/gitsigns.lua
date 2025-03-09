require('gitsigns').setup()


vim.keymap.set({ "n" }, "<C-b>", function()
    vim.cmd(":Gitsigns blame")
end)
