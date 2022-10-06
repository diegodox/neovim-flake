-- LSP integration for notify.nvim
local M = {}

local util = require("rc.plugins.config.notify.util")

function M.notify_lsp_progress_handler(_, result, ctx)
    local client_id = ctx.client_id

    local val = result.value

    if not val.kind then
        return
    end

    local notif_data = util.get_notif_data(client_id, result.token)

    if val.kind == "begin" then
        local msg = util.format_message(val.message, val.percentage)
        local title = util.format_title(val.title, vim.lsp.get_client_by_id(client_id).name)
        local icon = util.spinner_frames[1]
        ---@diagnostic disable-next-line: redundant-parameter
        notif_data.notification = vim.notify(msg, vim.log.levels.INFO, {
            title = title,
            icon = icon,
            timeout = false,
            hide_from_history = false,
        })
        notif_data.spinner = 1
        util.update_spinner(client_id, result.token)
    elseif val.kind == "report" and notif_data then
        local msg = util.format_message(val.message, val.percentage)
        ---@diagnostic disable-next-line: redundant-parameter
        notif_data.notification = vim.notify(msg, vim.log.levels.INFO, {
            replace = notif_data.notification,
            hide_from_history = false,
        })
    elseif val.kind == "end" and notif_data then
        local msg = val.message and util.format_message(val.message) or "Complete"
        ---@diagnostic disable-next-line: redundant-parameter
        notif_data.notification = vim.notify(msg, vim.log.levels.INFO, {
            icon = "",
            replace = notif_data.notification,
            timeout = 3000,
        })
        notif_data.spinner = nil
    end
end

return M
