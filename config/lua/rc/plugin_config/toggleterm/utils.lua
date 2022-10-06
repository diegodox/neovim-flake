local M = {}

---create a new terminal oblject appling my deafult settings
---setting: hidden, EDITOR as new tab.
---@param term Terminal?
---@return Terminal
function M.new_terminal(term)
    term = term or {}
    term = vim.tbl_deep_extend("keep", term, {
        hidden = true,
        env = {
            VISUAL = "nvim --server " .. vim.v.servername .. " --remote ",
            EDITOR = "nvim --server " .. vim.v.servername .. " --remote ",
        },
    })
    return require("toggleterm.terminal").Terminal:new(term)
end

---@param event string
---@param term Terminal
---@param opts table
function M.close_autocmd(event, term, opts)
    -- auto close term before leave current tab
    local group = vim.api.nvim_create_augroup("AutoCloseToggleTerm", { clear = false })
    opts = opts or {}
    opts = vim.tbl_deep_extend("keep", opts, {
        group = group,
        callback = function() term:close() end,
    })
    vim.api.nvim_create_autocmd(event, opts)
end

return M
