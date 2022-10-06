local M = {}

M.requires = { "williamboman/mason-lspconfig.nvim" }

-- list of language servers which must installed and configured
local ensure_installed = { "rust_analyzer", "sumneko_lua", "texlab", "taplo", "clangd", "cmake" }

local enhance_server_opts = {
    sumneko_lua = {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                -- Use StyLua instead of sumneko_lua builtin formatter.
                format = { enable = false },
            },
        },
    },
    clangd = {
        cmd = { "clangd", "--offset-encoding=utf-16" },
    },
    pylsp = {
        settings = {
            pylsp = {
                configurationSources = { "pycodestyle" },
                plugins = {
                    pycodestyle = { ignore = { "E501" } },
                    autopep8 = { enabled = false },
                    flake8 = { enabled = true, ignore = { "E501" } },
                    pyflakes = { enabled = false },
                },
            },
        },
    },
}

---@param server string
local function setup_server(server)
    local enhance_opts = enhance_server_opts[server] or {}
    enhance_opts.on_attach = require("rc.plugins.config.navic").on_attach
    require("rc.plugins.config.lsp_config").setup_server(server, enhance_opts)
end

function M.config()
    local mason_lspconfig = require("mason-lspconfig")

    mason_lspconfig.setup({
        ensure_installed = ensure_installed,
    })

    for _, lsp_name in pairs(mason_lspconfig.get_installed_servers()) do
        if lsp_name ~= "rust_analyzer" then
            setup_server(lsp_name)
        end
    end
end

return M
