local M = {}

function M.setup() vim.g.timeoutlen = 10 end

function M.config()
    local ok, whichkey = pcall(require, "which-key")
    if not ok then
        vim.notify_once("Plugin 'which-key' not found\nSkip setup 'which-key'", vim.lsp.log_levels.ERROR)
        return
    end
    whichkey.setup({
        window = {
            border = "rounded",
            winblend = 10,
        },
    })
end

---pcall `whichkey.register(mappings, opts)`
---print `fail_msg` whenfail to `require("which-key")`
---@param mappings any
---@param opts any
---@param fail_msg string?
---@return boolean
function M.pregister(mappings, opts, fail_msg)
    local ok_whichkey, whichkey = pcall(require, "which-key")
    if ok_whichkey then
        whichkey.register(mappings, opts)
    elseif fail_msg then
        vim.notify_once("Plugin 'which-key' not found\n" .. fail_msg, vim.log.levels.WARN)
    end
    return ok_whichkey
end

return M
