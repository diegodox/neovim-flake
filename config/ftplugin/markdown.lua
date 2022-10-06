vim.opt_local.colorcolumn = "80,100"

vim.api.nvim_create_user_command("ToggleMarkdownPreview", "MarkdownPreviewToggle", { desc = "Preview Markdown" })

vim.wo.wrap = true
