local M = {}

local keymap_prefix = "<C-t>"

---@class toolwindow_info
---@field name string
---@field plugin any
---@field close_fn function
---@field open_fn function

---@class keymap_arg
---@field mode string|table
---@field key string
---@field func function | string
---@field desc string

---@param toolwindow_info toolwindow_info
---@param keymaps keymap_arg|keymap_arg[]
local function register(toolwindow_info, keymaps)
    local toolwindow = require("toolwindow")

    toolwindow.register(toolwindow_info.name, toolwindow_info.plugin, toolwindow_info.close_fn, toolwindow_info.open_fn)

    if not keymaps[1] then
        vim.keymap.set(keymaps.mode, keymaps.key, keymaps.func, { desc = keymaps.desc })
    else
        for _, keymap in ipairs(keymaps) do
            vim.keymap.set(keymap.mode, keymap.key, keymap.func, { desc = keymap.desc })
        end
    end
end

local function register_trouble()
    local maps = {
        { key = "t", name = "trouble telescope", open = "telescope", desc = "Open: telescope with Trouble" },
        { key = "q", name = "trouble quickfix", open = "quickfix", desc = "Open: quickfix list" },
        { key = "l", name = "trouble loclist", open = "loclist", desc = "Open: location list" },
        {
            key = "?",
            name = "trouble document_diagnostics",
            open = "document_diagnostics",
            desc = "Open: document diagnostics",
        },
        {
            key = "d",
            name = "trouble workspace_diagnostics",
            open = "workspace_diagnostics",
            desc = "Open: workspace diagnostics",
        },
        { key = "r", name = "trouble lsp_references", open = "lsp_references", desc = "Open: references" },
        { key = "D", name = "trouble lsp_definitions", open = "lsp_definitions", desc = "Open: definitions" },
        {
            key = "T",
            name = "trouble lsp_type_definitions",
            open = "lsp_type_definitions",
            desc = "Open: type definitions",
        },
    }

    local toolwindow = require("toolwindow")
    local trouble = require("trouble")
    for _, map in ipairs(maps) do
        register({
            name = map.name,
            open_fn = function() trouble.open(map.open) end,
            close_fn = function() trouble.close() end,
            plugin = nil,
        }, {
            mode = "n",
            key = keymap_prefix .. map.key,
            func = function() toolwindow.open_window(map.name) end,
            desc = map.desc,
        })
    end
end

function M.config()
    local toolwindow = require("toolwindow")
    -- require("rc.plugins.config.which-key").pregister({ keymap_prefix = { name = "toolwindow" } })

    vim.keymap.set(
        "n",
        keymap_prefix .. keymap_prefix,
        function() toolwindow.close() end,
        { desc = "Close toolwindow" }
    )

    vim.keymap.set(
        "n",
        keymap_prefix .. "<CR>",
        function() toolwindow.open_window("term", nil) end,
        { desc = "Open term" }
    )

    register_trouble()
end

return M
