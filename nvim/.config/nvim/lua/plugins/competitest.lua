return {
    "xeluxee/competitest.nvim",
    dependencies = "MunifTanjim/nui.nvim",
    config = function()
        local function get_local_sim_state(online_sim_state)
            online_sim_state = tonumber(online_sim_state)
            if online_sim_state == 0 then
                return "1"
            else
                return "0"
            end
        end

        local online_simulation_state = os.getenv("ONLINE_SIM")
        local complication_macro_flag = "-DLOCAL"
        if online_simulation_state then
            local local_sim = get_local_sim_state(online_simulation_state)
            print("Simulation local state", local_sim)
            complication_macro_flag = "-DLOCAL=" .. tostring(local_sim)
        end

        require("competitest").setup({
            floating_border = "rounded",
            floating_border_highlight = "FloatBorder",
            picker_ui = {
                width = 0.2,
                "xeluxee/competitest.nvim",
                dependencies = "MunifTanjim/nui.nvim",
                height = 0.3,
                mappings = {
                    focus_next = { "j", "<down>", "<Tab>" },
                    focus_prev = { "k", "<up>", "<S-Tab>" },
                    close = { "<esc>", "<C-c>", "q", "Q" },
                    submit = { "<cr>" },
                },
            },
            editor_ui = {
                popup_width = 0.4,
                popup_height = 0.6,
                show_nu = true,
                show_rnu = false,
                normal_mode_mappings = {
                    switch_window = { "<C-h>", "<C-l>", "<C-i>" },
                    save_and_close = "<C-s>",
                    cancel = { "q", "Q" },
                },
                insert_mode_mappings = {
                    switch_window = { "<C-h>", "<C-l>", "<C-i>" },
                    save_and_close = "<C-s>",
                    cancel = "<C-q>",
                },
            },
            runner_ui = {
                interface = "popup",
                selector_show_nu = false,
                selector_show_rnu = false,
                show_nu = true,
                show_rnu = false,
                mappings = {
                    run_again = "R",
                    run_all_again = "<C-r>",
                    kill = "K",
                    kill_all = "<C-k>",
                    view_input = { "i", "I" },
                    view_output = { "a", "A" },
                    view_stdout = { "o", "O" },
                    view_stderr = { "e", "E" },
                    toggle_diff = { "d", "D" },
                    close = { "q", "Q" },
                },
                viewer = {
                    width = 0.5,
                    height = 0.5,
                    show_nu = true,
                    show_rnu = false,
                    close_mappings = { "q", "Q" },
                },
            },
            popup_ui = {
                total_width = 0.8,
                total_height = 0.8,
                layout = {
                    { 4, "tc" },
                    { 5, { { 1, "so" }, { 1, "si" } } },
                    { 5, { { 1, "eo" }, { 1, "se" } } },
                },
            },
            split_ui = {
                position = "right",
                relative_to_editor = true,
                total_width = 0.3,
                vertical_layout = {
                    { 1, "tc" },
                    { 1, { { 1, "so" }, { 1, "eo" } } },
                    { 1, { { 1, "si" }, { 1, "se" } } },
                },
                total_height = 0.4,
                horizontal_layout = {
                    { 2, "tc" },
                    { 3, { { 1, "so" }, { 1, "si" } } },
                    { 3, { { 1, "eo" }, { 1, "se" } } },
                },
            },

            save_current_file = true,
            save_all_files = false,
            compile_directory = ".",
            compile_command = {
                c = { exec = "gcc", args = { "-Wall", "$(FNAME)", "-o", "$(FNOEXT)" } },
                cpp = {
                    exec = "g++",
                    args = { "-std=c++17", complication_macro_flag, "$(FNAME)", "-o", "$(FNOEXT).out" },
                },
                rust = { exec = "rustc", args = { "$(FNAME)" } },
                java = { exec = "javac", args = { "$(FNAME)" } },
            },
            running_directory = ".",
            run_command = {
                c = { exec = "./$(FNOEXT)" },
                cpp = { exec = "./$(FNOEXT).out" },
                rust = { exec = "./$(FNOEXT)" },
                python = { exec = "python", args = { "$(FNAME)" } },
                java = { exec = "java", args = { "$(FNOEXT)" } },
            },
            multiple_testing = -1,
            maximum_time = 5000,
            output_compare_method = "squish",
            view_output_diff = false,

            testcases_directory = "./testcases/",
            testcases_use_single_file = false,
            testcases_auto_detect_storage = true,
            testcases_single_file_format = "$(FNOEXT).testcases",
            testcases_input_file_format = "$(FNOEXT)_input$(TCNUM).txt",
            testcases_output_file_format = "$(FNOEXT)_output$(TCNUM).txt",

            companion_port = 27121,
            receive_print_message = true,
            template_file = false,
            evaluate_template_modifiers = false,
            date_format = "%c",
            received_files_extension = "cpp",
            received_problems_path = "$(CWD)/$(PROBLEM).$(FEXT)",
            received_problems_prompt_path = true,
            received_contests_directory = "$(CWD)",
            received_contests_problems_path = "$(PROBLEM).$(FEXT)",
            received_contests_prompt_directory = true,
            received_contests_prompt_extension = true,
            open_received_problems = true,
            open_received_contests = true,
            replace_received_testcases = false,
        })

        vim.keymap.set({ "n" }, "<leader>ee", function()
            vim.cmd(":CompetiTest run")
        end)

        vim.keymap.set({ "n" }, "<leader>pp", function()
            vim.cmd(":CompetiTest receive problem")
        end)

        vim.keymap.set({ "n" }, "<leader>cc", function()
            vim.cmd(":CompetiTest receive contest")
        end)

        vim.keymap.set({ "n" }, "<leader>cp", function()
            vim.cmd(":CompetiTest run")
        end)
    end,
}
