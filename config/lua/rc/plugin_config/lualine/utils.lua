local M = {}

local function highlight()
    vim.cmd("highlight! link lualine_signature lualine_c_normal")
    vim.cmd("highlight! link lualine_signature_act_param lualine_x_diagnostics_error_normal")

    -- vim.cmd("highlight! link lualine_signature lualine_transitional_lualine_a_inactive_to_lualine_c_normal")
    -- vim.cmd("highlight! link lualine_signature_act_param lualine_c_normal")
    -- vim.cmd("highlight! link lualine_signature_act_param lualine_c_normal")
end

function M.highlight_autocmd()
    local group = vim.api.nvim_create_augroup("LulaineModuleHighlight", { clear = true })
    vim.api.nvim_create_autocmd("colorscheme", {
        callback = highlight,
        group = group,
        desc = "set lualine utils highlight",
    })
    highlight()
end

---Set timer to update tabline periodicaly
---Latency now is acceptable, but it would be better tabline also redrawn when statusline redrawn.
---See: https://github.com/nvim-lualine/lualine.nvim/wiki/FAQ#my-tabline-updates-infrequently
---@param period integer
function M.setup_tubline_timer(period)
    if _G.Tabline_timer == nil then
        _G.Tabline_timer = vim.loop.new_timer()
    else
        _G.Tabline_timer:stop()
    end
    _G.Tabline_timer:start(
        0, -- never timeout
        period, -- repeat every period ms
        vim.schedule_wrap(function() -- updater function
            vim.api.nvim_command("redrawtabline")
        end)
    )
end

---Set timer to update statusline periodicaly
---Latency now is acceptable, but it would be better tabline also redrawn when statusline redrawn.
---See: https://github.com/nvim-lualine/lualine.nvim/wiki/FAQ#my-tabline-updates-infrequently
---@param period integer
function M.setup_statusline_timer(period)
    if _G.Satusline_timer == nil then
        _G.Satusline_timer = vim.loop.new_timer()
    else
        _G.Satusline_timer:stop()
    end
    _G.Satusline_timer:start(
        0, -- never timeout
        period, -- repeat every period ms
        vim.schedule_wrap(function() -- updater function
            vim.api.nvim_command("redrawstatus")
        end)
    )
end

---return function which replace text to 'replaced' if given text is empty
---@param replaced string
---@return function
function M.replace_empty(replaced)
    return function(str)
        if str == "" then
            return replaced
        else
            return str
        end
    end
end

---return true if vim has width more than `win_width`, otherwise, false
---@param win_width number
---@return function
function M.hide(win_width)
    return function()
        local ui = vim.api.nvim_list_uis()
        if not ui or not ui[1] or not ui[1]["width"] then
            return true
        end
        return ui[1]["width"] > win_width
    end
end

---workspace diagnostics
---@return LualineDiagnostic
local function workspace_diag_source()
    ---comment
    ---@param severity any
    ---@return number
    local function workspace_diag(severity)
        local diag = vim.diagnostic.get(nil, { severity = severity })
        return vim.tbl_count(diag)
    end
    ---@class LualineDiagnostic
    ---@field error number
    ---@field warn number
    ---@field hint number
    ---@field info number
    return {
        error = workspace_diag(vim.diagnostic.severity.ERROR),
        warn = workspace_diag(vim.diagnostic.severity.WARN),
        hint = workspace_diag(vim.diagnostic.severity.HINT),
        info = workspace_diag(vim.diagnostic.severity.INFO),
    }
end

M.modules = {
    icon = { -- filetype icon
        "filetype",
        icon_only = true,
        colors = false,
        separator = "",
        padding = { right = 0, left = 1 },
        fmt = function(str)
            local icon = require("nvim-web-devicons")
            if not icon.get_icon(vim.fn.expand("%:t"), vim.bo.filetype) then
                return nil
            end
            return str
        end,
    },

    center = { -- centerlize
        "%=",
        separator = "",
        padding = { right = 0, left = 0 },
    },

    ---configured filename module
    ---@param cfg table?
    ---@return table
    filename = function(cfg)
        return vim.tbl_extend("keep", cfg or {}, {
            "filename",
            symbols = {
                modified = " +",
                readonly = " ",
            },
        })
    end,

    tabs = {
        "tabs",
        -- mode = 2,
        tabs_color = {
            active = { fg = "#000000", bg = "#eeeeee", gui = "italic" },
            inactive = { fg = "#444444", bg = "#999999" },
        },
        last_separator = false,
        separator = "",
        cond = function() return #vim.api.nvim_list_tabpages() > 1 end,
    },

    navic = require("rc.plugins.config.navic").lualine_widget,

    cwd = { -- current working directory
        "vim.fn.getcwd()",
        fmt = function(cwd) return require("rc.utils").path_icon(cwd) end,
    },

    ime_status = function()
        local status = require("rc.fcitx5").is_ime_on()
        if not status == nil then
            return "??"
        elseif status == true then
            return "JP"
        end
        return "EN"
    end,

    session = { -- current session
        "vim.v.this_session",
        fmt = function(session_path) return M.replace_empty("[NO SESSION]")(vim.fn.fnamemodify(session_path, ":t")) end,
    },

    signature_label = {
        ---@return string
        function()
            local ok, signature = pcall(require, "lsp_signature")
            if not ok then
                return ""
            end
            local sig = signature.status_line()

            local label1 = sig.label
            local label2 = ""
            if sig.range and sig.range["start"] ~= sig.range["end"] then
                label1 = sig.label:sub(1, sig.range["start"] - 1)
                label2 = sig.label:sub(sig.range["end"] + 1, #sig.label)
            end
            return "%#lualine_signature#"
                .. label1
                .. "%*"
                .. "%#lualine_signature_act_param#"
                .. sig.hint
                .. "%*"
                .. "%#lualine_signature#"
                .. label2
        end,
        ---@return boolean
        cond = function()
            local ok, signature = pcall(require, "lsp_signature")
            if not ok then
                return false
            end
            return signature.status_line().label ~= ""
        end,
    },

    ---@return string
    signature_hint = function()
        local ok, signature = pcall(require, "lsp_signature")
        if not ok then
            return ""
        end
        local sig = signature.status_line()
        return sig.hint
    end,

    workspace_diagnostics = {
        "diagnostics",
        sources = { workspace_diag_source },
    },

    branch = { "branch", fmt = M.replace_empty("-") },
}

return M
