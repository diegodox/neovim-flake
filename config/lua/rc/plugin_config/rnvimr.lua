local M = {}

function M.config()
    -- <C-b> to open ranger in proper size(rnvimr_ranger_views[1])
    vim.keymap.set("n", "<C-b>", "<Cmd>RnvimrToggle<CR><Cmd>RnvimrResize 2<CR>", { desc = "Toggle Ranger" })

    -- Link CursorLine into RnvimrNormal highlight in the Floating window
    vim.cmd("highlight link RnvimrNormal CursorLine")

    -- Make Ranger replace Netrw and be the file explorer
    vim.g.rnvimr_enable_ex = 1
    -- Make Ranger to be hidden after picking a file
    vim.g.rnvimr_enable_picker = 1
    -- Make Neovim wipe the buffers corresponding to the files deleted by Ranger
    vim.g.rnvimr_enable_bw = 1
    -- Customize the initial layout
    vim.g.rnvimr_layout = {
        style = "minimal",
        relative = "editor",
        width = math.ceil(0.85 * vim.o.columns),
        height = math.ceil(0.85 * vim.o.lines),
        col = math.ceil(0.075 * vim.o.columns),
        row = math.ceil(0.075 * vim.o.lines),
    }
    -- " Add views for Ranger to adapt the size of floating window
    -- let g:rnvimr_ranger_views = [
    --             \ {'minwidth': 90, 'ratio': []},
    --             \ {'minwidth': 50, 'maxwidth': 89, 'ratio': [1,1]},
    --             \ {'maxwidth': 49, 'ratio': [1]}
    --             \ ]
end

return M
