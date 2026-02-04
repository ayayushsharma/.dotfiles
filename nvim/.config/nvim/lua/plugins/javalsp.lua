return {
    "nvim-java/nvim-java",
    config = function()
        local language = string.upper("java")
        local env_var = "IS_INSTALLED_" .. language
        local env_value = os.getenv(env_var)
        if env_value == nil then
            return
        end
        require('java').setup({
            jdk = { auto_install = false },
            java_debug_adapter = { enable = false },
            java_test = { enable = false },
            spring_boot_tools = { enable = false },
        })
        vim.lsp.enable('jdtls')
    end,
}
