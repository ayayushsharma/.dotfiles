return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
        vim.keymap.set("n", "<C-p>", builtin.git_files, {})
        vim.keymap.set("n", "<leader>ps", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)

        require("telescope").setup({
            defaults = {
                file_ignore_patterns = {
                    "node_modules",
                    "__pycache__",
                    ".venv",
                    ".git",
                }
            },
            pickers = {
                find_files = {
                    hidden = true
                }
            }
        })
    end,
}
