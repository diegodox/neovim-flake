local M = {}

--- setup nvim-notify
--- reculclate max size of notification window, based on nvim window size
---@param notify any
local function setup_notify(notify)
    local ui = vim.api.nvim_list_uis()
    local max_width = 50
    local max_height = 20
    if ui then
        max_width = math.floor(ui[1]["width"] / 3)
        max_height = math.floor(vim.api.nvim_list_uis()[1]["height"] / 4)
    end
    notify.setup({
        -- hack: set this since "notify-nvim" warn if background_colour has tranparency(default is `Normal`).
        background_colour = "CursorLine",
        timeout = 1000,
        max_width = max_width,
        max_height = max_height,
        stages = "fade",
    })
end

local function register_user_command()
    vim.api.nvim_create_user_command(
        "NotifyDissmiss",
        function() require("notify").dismiss({ pending = false }) end,
        { desc = "Dismiss all notification windows currently displayed" }
    )
end

function M.config()
    local notify = require("notify")
    setup_notify(notify)

    -- reculclate max size of notification window, based on nvim window size
    local aug = vim.api.nvim_create_augroup("NotifyConf", { clear = true })
    vim.api.nvim_create_autocmd("VimResized", {
        callback = function() setup_notify(notify) end,
        group = aug,
    })

    register_user_command()

    -- override default vim notification service (which is a message)
    vim.notify = notify
end

return M
