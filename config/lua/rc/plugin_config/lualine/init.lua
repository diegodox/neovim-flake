local M = {} -- lualine configuration

M.requires = { -- plugins required for lualine
    "nvim-treesitter/nvim-treesitter",
    "SmiteshP/nvim-navic",
    "kyazdani42/nvim-web-devicons",
}

---configure lualine
function M.config()
    vim.o.showtabline = 0

    local utils = require("rc.plugins.config.lualine.utils")
    utils.highlight_autocmd()
    local mod = utils.modules
    require("lualine").setup({
        options = {
            section_separators = { left = "", right = "" },
            globalstatus = true,
            refresh = {
                statusline = 300,
                winbar = 300,
            },
            disabled_filetypes = {
                winbar = { "toggleterm", "Trouble" },
            },
        },
        sections = {
            lualine_a = { "mode", mod.branch },
            lualine_b = {
                mod.icon,
                mod.filename(),
            },
            lualine_c = {
                mod.center,
                mod.signature_label,
            },
            lualine_x = { { "diff", source = vim.b.gitsigns_head }, mod.workspace_diagnostics },
            lualine_y = { { "location", cond = utils.hide(200) }, mod.tabs, mod.ime_status },
            lualine_z = {
                mod.cwd, --[[ mod.session ]]
            },
        },
        inactive_winbar = {
            lualine_a = { mod.icon, mod.filename({ path = 1 }) },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        winbar = {
            lualine_a = { mod.icon, mod.filename({ path = 1 }) },
            lualine_b = {},
            lualine_c = { mod.navic() },
            lualine_x = {
                { "encoding", cond = utils.hide(200) },
                { "fileformat", cond = utils.hide(200) },
                { "filetype", cond = utils.hide(200) },
                { "diff", source = vim.b.gitsigns_status_dict },
                "diagnostics",
            },
            lualine_y = {},
            lualine_z = {},
        },
    })
end

return M
