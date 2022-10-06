local M = {}

local lspconfig = require("rc.plugins.config.mason.lsp")

M.requires = lspconfig.requires

function M.config()
    require("mason").setup({
        ui = {
            icons = {
                server_installed = "✓",
                server_pending = "➜",
                server_uninstalled = "✗",
            },
            border = "rounded",
        },
    })
    lspconfig.config()
end

return M
