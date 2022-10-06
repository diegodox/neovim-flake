local M = {}

M.requires = { "mattn/webapi-vim" }

---@param bufnr number
local function keymap(bufnr)
    require("rc.plugins.config.which-key").pregister(
        { r = { name = "Rust" } },
        { prefix = "<Leader>" },
        "Setup rust keymap without 'which-key' bufnr: " .. bufnr
    )
    vim.keymap.set("n", "<Leader>rp", "<cmd>RustParentModule<CR>", { desc = "Parent Module", buffer = bufnr })
    vim.keymap.set("n", "<Leader>rr", "<cmd>RustRunnables<CR>", { desc = "Runnables", buffer = bufnr })
    vim.keymap.set("n", "<Leader>rc", "<cmd>RustOpenCargo<CR>", { desc = "Open Cargo.toml", buffer = bufnr })
end

function M.setup()
    local cfg = {
        tools = { inlay_hints = { highlight = "NonText" } },
        server = require("rc.plugins.config.lsp_config").server_opts("rust_analyzer", {
            -- see: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
            settings = {
                -- To enable rust-analyzer settings, visit: https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                -- Sometimes this is better resource: https://github.com/simrat39/rust-tools.nvim/wiki/Server-Configuration-Schema
                ["rust-analyzer"] = {
                    cargo = { allFeatures = true },
                    checkOnSave = {
                        command = "clippy",
                        extraArgs = { "--examples", "--tests", "--benches" },
                        allFeatures = true,
                    },
                },
            },
        }),
    }
    local on_attach = cfg.server.on_attach
    cfg.server.on_attach = function(client, bufnr)
        on_attach(client, bufnr)
        keymap(bufnr)
    end
    require("rust-tools").setup(cfg)
end

return M
