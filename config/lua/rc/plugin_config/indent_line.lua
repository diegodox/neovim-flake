local M = {}

M.requires = "nvim-treesitter/nvim-treesitter"

-- highlights
local function highlight()
    vim.cmd([[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]])
    vim.cmd([[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]])
end

-- settings
local function setting() vim.g.indent_blankline_show_trailing_blankline_indent = false end

-- setup indent blank line
local function setup()
    require("indent_blankline").setup({
        filetype_exclude = {
            "help",
            "startify",
            "Term",
            "packer",
            "nvim-lsp-installer",
        },
        space_char_blankline = " ",
        char_highlight_list = {
            "IndentBlanklineIndent1",
            "IndentBlanklineIndent2",
            "IndentBlanklineIndent3",
            "IndentBlanklineIndent4",
            "IndentBlanklineIndent5",
            "IndentBlanklineIndent6",
        },
    })
end

local function autoset_highlight()
    local g = vim.api.nvim_create_augroup("AutoSetIndentBlanklineHightlight", { clear = true })
    vim.api.nvim_create_autocmd("colorscheme", {
        group = g,
        callback = function()
            highlight()
            vim.notify("set indent_blankline highlights", vim.log.levels.TRACE)
        end,
        desc = "Automatically set indent_blankline highlighting after colorscheme applied",
    })
end

-- call highlight, settings, setup
function M.config()
    highlight()
    setting()
    setup()
    autoset_highlight()
end

return M
