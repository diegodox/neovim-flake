local M = {}

function M.config()
    require("lsp_lines").setup()

    -- Disable virtual_text since it's redundant due to lsp_lines.
    vim.diagnostic.config({
        virtual_text = false,
    })

    vim.api.nvim_create_autocmd("InsertEnter", {
        callback = function() M.hide_diagnostic() end,
    })

    vim.api.nvim_create_autocmd("ModeChanged", {
        pattern = "i:*",
        callback = function() M.show_diagnostic() end,
    })
end

---@param name string
---@return number?
local function get_namespace_by_name(name)
    local nss = vim.diagnostic.get_namespaces()
    for key, ns in pairs(nss or {}) do
        if ns and ns.name == name then
            assert(type(key) == "number")
            return key
        end
    end
end

---@param name string?
---@param config table[]?
---@param should_fallback boolean?
function M.show_diagnostic(name, config, should_fallback)
    local ns = name and get_namespace_by_name(name)
    if should_fallback or ns then
        vim.diagnostic.show(ns, 0, nil, config)
    end
end

---@param name string?
---@param should_fallback boolean?
function M.hide_diagnostic(name, should_fallback)
    local ns = name and get_namespace_by_name(name)
    if should_fallback or ns then
        vim.diagnostic.hide(ns, 0)
    end
end

---@param name string
function M.cargo_autocmd(name)
    -- Because of namespace configuration has higher priority than finally global configuration,
    -- we need to set this again.
    vim.api.nvim_create_autocmd("InsertEnter", {
        desc = "Hide virtual_lines when enter insert mode.",
        group = vim.api.nvim_create_augroup("CargoCheckDiagnostic", { clear = true }),
        pattern = "*.rs",
        callback = function()
            -- diagnostic_config_by_name({ virtual_lines = false }, "cargo_clippy")
            M.hide_diagnostic(name)
        end,
    })

    -- We need to turn-on virtual_lines when leave Insert Mode,
    -- since we already turn-off virtual_lines when enter to Insert mode.
    --
    -- In addition, check buffer is not modified because diagnostic which
    -- cargo-check generated make sence only if file is not modified.
    vim.api.nvim_create_autocmd("ModeChanged", {
        desc = "Show virtual_lines when leave insert mode and buffer is not modified.",
        group = vim.api.nvim_create_augroup("CargoCheckDiagnostic", { clear = false }),
        pattern = "i:*",
        callback = function()
            if vim.bo.filetype == "rust" and not vim.bo.modified then
                -- diagnostic_config_by_name({ virtual_lines = true }, "cargo_clippy")
                M.show_diagnostic(name, { virtual_lines = true })
            end
        end,
    })

    -- virtual_lines need to follow buffer Modified status,
    -- since sometinmes buffer modified/saved without enter/leave Insert mode.
    --
    -- TODO: Should mode afects this behavior?
    -- (more specific, does this event happen while in insert mode?)
    vim.api.nvim_create_autocmd("BufModifiedSet", {
        desc = "Make virtual_lines follw buffer modified status.",
        group = vim.api.nvim_create_augroup("CargoCheckDiagnostic", { clear = false }),
        pattern = "*.rs",
        callback = function()
            -- diagnostic_config_by_name({ virtual_lines = not vim.bo.modified }, "cargo_clippy")
            if vim.bo.modified then
                M.hide_diagnostic(name)
            else
                M.show_diagnostic(name, { virtual_lines = true })
            end
        end,
    })
end

function M.highlight() vim.cmd("highlight! default link DiagnosticVirtualTextHint NonText") end

return M
