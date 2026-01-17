local language = string.upper("java")
local env_var = "IS_INSTALLED_" .. language
local env_value = os.getenv(env_var)

if env_value == nil then
    return {}
end

return {
    "nvim-java/nvim-java",
    config = function()
        require("java").setup()
        vim.lsp.enable("jdtls")
    end,
}
