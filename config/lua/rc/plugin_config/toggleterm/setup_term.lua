---@return Terminal
local function create_term()
    return require("rc.plugins.config.toggleterm.utils").new_terminal({
        size = 15,
        env = {
            -- open a new split in current nvim to edit, instead of opening new vim in terminal
            VISUAL = "nvim --server " .. vim.v.servername .. " --remote +vs",
            EDITOR = "nvim --server " .. vim.v.servername .. " --remote +vs",
        },
    })
end

---@param term Terminal
local function create_user_command(term)
    vim.api.nvim_create_user_command("ToggleTerm", function() term:toggle(nil, nil) end, { desc = "Toggle terminal" })

    vim.api.nvim_create_user_command("ToggleTermVertical", function()
        if term:is_open() then
            term:close()
        end
        term:open(vim.o.columns * 0.4, "vertical", false)
    end, { desc = "Toggle terminal open in vertical" })

    vim.api.nvim_create_user_command("ToggleTermHorizontal", function()
        if term:is_open() then
            term:close()
        end
        term:open(15, "horizontal", false)
    end, { desc = "Toggle terminal open in horizontal" })
end

local function set_keymap()
    local pregister = require("rc.plugins.config.which-key").pregister
    pregister({ ["<C-t>"] = { name = "ToggleTerm" } })
    pregister({ ["<C-t>"] = { name = "ToggleTerm" } }, { mode = "t" })

    vim.keymap.set("n", "<C-t><CR>", "<cmd>ToggleTerm<CR>", { desc = "Toglle Terminal" })
    vim.keymap.set("n", "<C-t><C-CR>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
    vim.keymap.set("n", "<C-t>v", "<cmd>ToggleTermVertical<CR>", { desc = "Toggle Terminal Vertically" })
    vim.keymap.set("n", "<C-t>s", "<cmd>ToggleTermHorizontal<CR>", { desc = "Toggle Terminal Horizontally" })

    vim.keymap.set("t", "<C-t><CR>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
    vim.keymap.set("t", "<C-t><C-CR>", "<cmd>ToggleTerm<CR>", { desc = "Toggle Terminal" })
    vim.keymap.set("t", "<C-t>v", "<cmd>ToggleTermVertical<CR>", { desc = "Toggle Terminal Vertically" })
    vim.keymap.set("t", "<C-t>s", "<cmd>ToggleTermHorizontal<CR>", { desc = "Toggle Terminal Horizontally" })
end

---Setup toggle terminal
return function()
    local term = create_term()
    require("rc.plugins.config.toggleterm.utils").close_autocmd(
        "TabLeave",
        term,
        { desc = "Close ToggleTerm Before Leave Tab" }
    )
    create_user_command(term)
end
