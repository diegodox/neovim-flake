local navic = require("nvim-navic")

local M = {
    already_setup = false,
}

--- attach navic to lsp
---@param client string
---@param bufnr number
function M.on_attach(client, bufnr) navic.attach(client, bufnr) end

function M.config()
    navic.setup()
    M.already_setup = true
end

M.lualine_widget = function()
    if not M.already_setup then
        M.config()
    end

    return {
        navic.get_location,
        cond = navic.is_available,
    }
end

return M
