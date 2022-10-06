local M = {}

local function setup_rust(dap)
    dap.adapters.rust = {
        attach = { pidProperty = "pid", pidSelect = "ask" },
        command = "lldb-vscode", -- my binary was called 'lldb-vscode-11'
        env = { LLDB_LAUNCH_FLAG_LAUNCH_IN_TTY = "YES" },
        name = "lldb",
        type = "executable",
    }
end

local function sign_define() vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "", linehl = "", numhl = "" }) end

local keymap = {
    general = function(dap)
        require("rc.plugins.config.which-key").pregister({ d = { name = "DAP" } }, { prefix = "<Leader>" })

        local set_breakpoint = function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end

        vim.keymap.set("n", "<Leader>db", dap.toggle_breakpoint, { desc = "DAP toggle breakpoint" })
        vim.keymap.set("n", "<Leader>dc", dap.continue, { desc = "DAP Continue" })
        vim.keymap.set("n", "<Leader>dn", dap.step_over, { desc = "DAP Step over" })
        vim.keymap.set("n", "<Leader>di", dap.step_into, { desc = "DAP Step into" })
        vim.keymap.set("n", "<Leader>do", dap.setp_out, { desc = "DAP Step out" })
        vim.keymap.set("n", "<Leader>dR", dap.repl_open, { desc = "DAP Open REPL" })
        vim.keymap.set("n", "<Leader>dg", dap.run_last, { desc = "DAP run last" })
        vim.keymap.set("n", "<Leader>dq", dap.disconnect, { desc = "disconnect debugger" })
        vim.keymap.set("n", "<Leader>dB", set_breakpoint, { desc = "DAP Breakpoint condition" })
    end,
}

function M.setup()
    local dap = require("dap")
    sign_define()
    keymap.general(dap)
    require("rc.plugins.config.telescope").keymap.dap()
    require("telescope").load_extension("dap")
    setup_rust(dap)
end

return M
