local M = {}

function M.config()
    vim.keymap.set("n", "<C-w>x", "<Cmd>WinShift swap<CR>", { desc = "Swap windows" })
    vim.keymap.set("n", "<C-w><S-h>", "<Cmd>WinShift left<CR>", { desc = "Move window left" })
    vim.keymap.set("n", "<C-w><S-j>", "<Cmd>WinShift down<CR>", { desc = "Move window down" })
    vim.keymap.set("n", "<C-w><S-k>", "<Cmd>WinShift up<CR>", { desc = "Move window up" })
    vim.keymap.set("n", "<C-w><S-l>", "<Cmd>WinShift right<CR>", { desc = "Move window right" })
end

return M
