local M = {}

---Configure toggleterm.nvim
function M.config()
    if not vim.o.hidden then
        vim.notify("toggleterm needs 'hidden' option, set hidden = true", vim.log.levels.WARN)
        vim.o.hidden = true
    end
    require("toggleterm").setup({
        start_in_insert = false,
        float_opts = { winblend = 4 },
    })
    require("rc.plugins.config.toggleterm.setup_term")()
    -- require("rc.plugins.config.toggleterm.setup_lazygit")()
    -- require("rc.plugins.config.toggleterm.setup_ranger")()
end

return M
