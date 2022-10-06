local M = {}

M.requires = { "stevearc/dressing.nvim" }

function M.setup()
    require("inc_rename").setup({
        input_buffer_type = "dressing",
    })
end

function M.increname() return ":IncRename " .. vim.fn.expand("<cword>") end

return M
