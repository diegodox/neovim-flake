local M = {}

-- setup Comment.nvim
function M.setup()
    local ok, comment = pcall(require, "Comment")
    if not ok then
        print("plugin 'Comment.nvim' not found")
        return
    end
    comment.setup()
end

-- configure Comment.nvim
-- call setup
function M.config() M.setup() end

return M
