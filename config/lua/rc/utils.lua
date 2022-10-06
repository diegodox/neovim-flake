local M = {}

---iconize path
---@param path string
---@return string
function M.path_icon(path)
    path = vim.fn.substitute(path, os.getenv("HOME"), "", "")
    path = vim.fn.substitute(path, "/dev/", "//", "")
    path = vim.fn.substitute(path, ".config/", "/", "")
    path = vim.fn.substitute(path, "/dotfiles/", "//", "")
    path = vim.fn.substitute(path, "nvim/", "/", "")
    path = vim.fn.substitute(path, "/work/", "//", "")
    return path
end

local function set_transparent()
    if not vim.g.transparent_bg then
        -- vim.notify("not apply transparent", vim.lsp.log_levels.TRACE)
        vim.cmd("colorscheme " .. vim.g.colors_name)
        return
    end
    if vim.g.neovide then
        -- vim.notify("apply neovide transparent", vim.lsp.log_levels.TRACE)
        vim.g.neovide_transparency = 0.9
        vim.cmd("highlight StartifyPath guibg=none")
        vim.cmd("highlight WarningMsg guibg=none")
        vim.cmd("highlight Error guibg=none")
    else
        -- vim.notify("apply term neovim transparent", vim.lsp.log_levels.TRACE)
        vim.cmd("highlight Normal ctermbg=none guibg=none")
        vim.cmd("highlight NonText ctermbg=none guibg=none")
        vim.cmd("highlight EndOfBuffer ctermbg=none guibg=none")
        vim.cmd("highlight VertSplit ctermbg=none guibg=none")
        vim.cmd("highlight SignColumn ctermbg=none guibg=none")
        vim.cmd("highlight SpecialKey ctermbg=none guibg=none")
        vim.cmd("highlight WarningMsg ctermbg=none guibg=none")
        vim.cmd("highlight Error ctermbg=none guibg=none")
        vim.cmd("highlight clear LineNr")
        vim.cmd("highlight LineNr ctermfg=none guifg=none")
        vim.cmd("highlight StartifyPath ctermbg=none guibg=none")
    end
end

function M.enable_transparent()
    vim.g.transparent_bg = true
    vim.api.nvim_exec_autocmds("colorscheme", {})
    vim.notify("Enable background transparent", vim.log.levels.TRACE)
end

function M.disable_transparent()
    vim.g.transparent_bg = false
    vim.api.nvim_exec_autocmds("colorscheme", {})
    vim.notify("Disable background transparent", vim.log.levels.TRACE)
end

function M.toggle_transparent()
    vim.g.transparent_bg = not vim.g.transparent_bg
    vim.api.nvim_exec_autocmds("colorscheme", {})
    vim.notify("Toggle background transparent", vim.log.levels.TRACE)
end

-- set highlight
function M.set_colorscheme()
    -- copy Normal highlight with background into NormalUntransparent
    vim.cmd("hi link NormalUntransparent Normal")
    vim.cmd([[exec 'hi NormalUntransparent ' .
                \' guifg=' . synIDattr(synIDtrans(hlID('Normal')), 'fg', 'gui') .
                \' ctermfg=' . synIDattr(synIDtrans(hlID('Normal')), 'fg', 'cterm') .
                \' guibg=' . synIDattr(synIDtrans(hlID('Normal')), 'bg', 'gui') .
                \' ctermbg=' . synIDattr(synIDtrans(hlID('Normal')), 'bg', 'cterm')]])

    set_transparent()
    require("rc.lsp-handler").def_reference_highlight()
    require("rc.plugins.config.lsplines").highlight()
end

-- create autocommand that automatically set background transparent after set colorscheme
function M.setup_colorscheme()
    local group = vim.api.nvim_create_augroup("Transparent", { clear = true })
    vim.api.nvim_create_autocmd(
        "colorscheme",
        { callback = M.set_colorscheme, group = group, desc = "set transparent" }
    )
    vim.api.nvim_create_user_command(
        "ToggleBackgroundTranprent",
        M.toggle_transparent,
        { desc = "Toggle Background Transparentecy" }
    )
    vim.api.nvim_create_user_command(
        "EnableBackgroundTranprent",
        M.enable_transparent,
        { desc = "Enable Background Transparentecy" }
    )
    vim.api.nvim_create_user_command(
        "DisableBackgroundTranprent",
        M.disable_transparent,
        { desc = "Disable Background Transparentecy" }
    )
end

return M
