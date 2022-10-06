local M = {}

function M.config() require("lsp_signature").setup({ hint_enable = false, always_trigger = true }) end

return M
