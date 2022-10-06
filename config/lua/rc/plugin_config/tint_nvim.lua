local M = {}

local ignore_window_ft = {
    "terminal",
    "Trouble",
}

local highlight_ignore_patterns = {
    "WinSeparator",
    "VertSplit",
}

---find item in array, return true if array contains item
---@generic T
---@param array T[]
---@param item T
---@return boolean
local function contains(array, item)
    for _, v in pairs(array) do
        if v == item then
            return true
        end
    end
    return false
end

function M.config()
    require("tint").setup({
        highlight_ignore_patterns = highlight_ignore_patterns,
        ---@param winid integer
        window_ignore_function = function(winid)
            local bufid = vim.api.nvim_win_get_buf(winid)
            local buftype = vim.api.nvim_buf_get_option(bufid, "buftype")
            local floating = vim.api.nvim_win_get_config(winid).relative ~= ""

            -- Do not tint `terminal` or floating windows, tint everything else
            return floating or contains(ignore_window_ft, buftype)
        end,
        focus_change_events = {
            focus = { "WinEnter", "TabEnter" },
            unfocus = { "WinLeave", "TabLeave" },
        },
    })
end

return M
