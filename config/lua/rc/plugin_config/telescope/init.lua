local M = {}

-- requirement plugins for telescope
M.requires = {
    "nvim-lua/plenary.nvim",
    "nvim-lua/popup.nvim",
    "kyazdani42/nvim-web-devicons",
    "tami5/sqlite.lua",
    "nvim-telescope/telescope-frecency.nvim",
}

--- dynamic layout based on nvim window size
---@param threshold number
---@return string
local function dynamic_layout_strategy(threshold)
    local ui = vim.api.nvim_list_uis()
    if not ui or not ui[1] or not ui[1]["width"] then
        return "vertical"
    end
    if ui[1]["width"] > threshold then
        return "horizontal"
    end
    return "vertical"
end

---call telescope.setup
local function setup()
    local ok_telescope, telescope = pcall(require, "telescope")
    local ok_actions, actions = pcall(require, "telescope.actions")
    if not ok_telescope then
        vim.notify_once("plugin 'telescope' not found", vim.log.levels.WARN)
        return
    elseif not ok_actions then
        vim.notify_once("plugin 'telescope' found, but 'telescope.actions' not found", vim.log.levels.WARN)
        return
    end
    local telescope_opts = {
        defaults = {
            vimgrep_arguments = {
                "rg",
                "--color=never",
                "--no-heading",
                "--with-filename",
                "--line-number",
                "--column",
                "--smart-case",
            },
            layout_strategy = "horizontal",
            layout_defaults = {
                horizontal = {
                    mirror = true,
                    preview_width = 0.7,
                },
                vertical = {
                    mirror = true,
                },
            },
            mappings = {
                i = {
                    ["<C-h>"] = "which_key",
                    ["<esc>"] = actions.close,
                    ["<C-e>"] = function(prompt_bufnr, _mode)
                        require("trouble.providers.telescope").open_with_trouble(prompt_bufnr, _mode)
                    end,
                },
            },
            winblend = 7,
        },
        pickers = {
            find_files = {
                -- theme = "dropdown",
                prompt_prefix = "🔍",
            },
            git_files = {
                -- theme = "dropdown",
                prompt_prefix = "🔍",
            },
            buffers = {
                mappings = {
                    i = {
                        ["<C-z>"] = "delete_buffer",
                    },
                },
            },
        },
    }

    telescope.setup(telescope_opts)

    vim.cmd("highlight link TelescopeNormal NormalUntransparent")
end

M.keymap = {
    ---bind general keymap
    general = function()
        local pregister = require("rc.plugins.config.which-key").pregister
        pregister({ l = { name = "LSP" } }, { prefix = "<Leader>" }, "Setup telescope keymap without 'which-key'")
        pregister({ t = { name = "Telescope" } }, { prefix = "<Leader>" }, "Setup telescope keymap without 'which-key'")
        pregister({ g = { name = "Git" } }, { prefix = "<Leader>" }, "Setup telescope keymap without 'which-key'")

        local builtin = require("telescope.builtin")

        --Call git_files if in git directory, otherwise call find_files.
        --Smarter than my old config.
        vim.keymap.set("n", "<C-p>", function()
            local threshold = 170
            local ok, _ = pcall(builtin.git_files, {
                layout_strategy = dynamic_layout_strategy(threshold),
                show_untracked = true,
            })
            if not ok then
                vim.notify("Not in git directory, call find_files instead", vim.log.levels.INFO)

                local telescope = package.loaded.telescope
                telescope.extensions.frecency.frecency({
                    layout_strategy = dynamic_layout_strategy(threshold),
                })
            end
        end, { desc = "Telescope smart list files" })
        vim.keymap.set("n", "<M-p>", builtin.buffers, { desc = "Telescope List Buffers" })
        vim.keymap.set("n", "<Leader>tb", builtin.buffers, { desc = "List buffers" })
        vim.keymap.set("n", "<Leader>tB", builtin.builtin, { desc = "Find builtin features" })
        vim.keymap.set("n", "<Leader>tf", builtin.find_files, { desc = "Find file" })
        vim.keymap.set("n", "<Leader>tg", builtin.live_grep, { desc = "Live grep" })
        vim.keymap.set("n", "<Leader>tr", builtin.oldfiles, { desc = "MRU" })
        vim.keymap.set("n", "<Leader>tk", builtin.keymaps, { desc = "List Keymap" })
        vim.keymap.set("n", "<Leader>tG", builtin.git_files, { desc = "Git files" })
        vim.keymap.set("n", "<Leader>th", builtin.help_tags, { desc = "List Helps" })
        vim.keymap.set("n", "<Leader>tH", builtin.highlights, { desc = "List Highlights" })
        vim.keymap.set("n", "<Leader>gc", builtin.git_commits, { desc = "List commits" })
        vim.keymap.set("n", "<Leader>gC", builtin.git_bcommits, { desc = "List buffer commits" })
    end,

    ---bind notifications list keybindings
    notify = function()
        require("rc.plugins.config.which-key").pregister(
            { t = { name = "Telescope" } },
            { prefix = "<Leader>" },
            "Setup telescope notify keymap without 'which-key'"
        )

        local notify = require("telescope").extensions.notify
        vim.keymap.set("n", "<Leader>tn", notify.notify, { desc = "List notifications" })
    end,

    ---Debugger Adapter Protocol
    dap = function()
        require("telescope").load_extension("dap")
        local dap = require("telescope").extensions.dap
        vim.keymap.set("n", "<Leader>dH", dap.commands, { desc = "DAP commands" })
        vim.keymap.set("n", "<Leader>dC", dap.configurations, { desc = "DAP configurations" })
        vim.keymap.set("n", "<Leader>dP", dap.list_breakpoints, { desc = "DAP list_breakpoints" })
        vim.keymap.set("n", "<Leader>dV", dap.variables, { desc = "DAP variables" })
    end,

    ---bind telescope's lsp keybinding to buffer
    ---@param bufnr number
    lsp = function(bufnr)
        local builtin = require("telescope.builtin")
        vim.keymap.set("n", "gd", builtin.lsp_definitions, { desc = "Definitions", buffer = bufnr })
        vim.keymap.set("n", "gD", builtin.lsp_type_definitions, { desc = "Type definitions", buffer = bufnr })
        vim.keymap.set("n", "gI", builtin.lsp_implementations, { desc = "Implementation", buffer = bufnr })
        vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "References", buffer = bufnr })
        vim.keymap.set("n", "g@", builtin.lsp_document_symbols, { desc = "Document Symbols", buffer = bufnr })
        vim.keymap.set("n", "gw", builtin.lsp_workspace_symbols, { desc = "Workspace Symbols", buffer = bufnr })
    end,
}

-- configure telescope (setup, keymap)
function M.config()
    setup()
    M.keymap.general()
    M.keymap.notify()
end

return M
