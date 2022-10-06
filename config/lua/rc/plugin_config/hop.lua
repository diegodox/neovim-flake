local M = {}

function M.config()
    require("hop").setup()
    vim.keymap.set("n", "<C-f>", "<Cmd>HopChar1<CR>", { desc = "Hop to char" })
    vim.keymap.set("n", "gl", "<Cmd>HopLineStart<CR>", { desc = "Hop to line start" })

    require("rc.plugins.config.which-key").pregister({ h = { name = "hop" } }, { prefix = "<Leader>" })
    vim.keymap.set("n", "<Leader>hf", "<Cmd>HopChar1<CR>", { desc = "Hop to char" })
    vim.keymap.set("n", "<Leader>hl", "<Cmd>HopLineStart<CR>", { desc = "Hop to line start" })
end

return M
