local M = {}
function M.config()
	require("nvim-treesitter.configs").setup({
		textobjects = {
			select = {
				enable = true,

				-- Automatically jump forward to textobj, similar to targets.vim
				lookahead = true,

				keymaps = {
					["af"] = { query = "@function.outer", desc = "Select function body" },
					["if"] = { query = "@function.inner", desc = "Selct function" },
					["ac"] = { query = "@class.outer", desc = "Select class" },
					["ic"] = { query = "@class.inner", desc = "Select class body" },
				},
				-- You can choose the select mode (default is charwise 'v')
				selection_modes = {
					["@parameter.outer"] = "v", -- charwise
					["@function.outer"] = "V", -- linewise
					["@class.outer"] = "<c-v>", -- blockwise
				},
				-- If you set this to `true` (default is `false`) then any textobject is
				-- extended to include preceding xor succeeding whitespace. Succeeding
				-- whitespace has priority in order to act similarly to eg the built-in
				-- `ap`.
				include_surrounding_whitespace = true,
			},

			swap = {
				enable = true,
				swap_next = {
					["<leader>a"] = { query = "@parameter.inner", desc = "Swap parameter with next" },
				},
				swap_previous = {
					["<leader>A"] = { query = "@parameter.inner", desc = "Swap parameter with previous" },
				},
			},

			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = { query = "@function.outer", desc = "Jump to next fucntion start" },
					["]]"] = { query = "@class.outer", desc = "Jump to next class start" },
				},
				goto_next_end = {
					["]M"] = { query = "@function.outer", desc = "Jump to next fucntion end" },
					["]["] = { query = "@class.outer", desc = "Jump to next class end" },
				},
				goto_previous_start = {
					["[m"] = { query = "@function.outer", desc = "Jump to previous function start" },
					["[["] = { query = "@class.outer", desc = "Jump to previous class satrt" },
				},
				goto_previous_end = {
					["[M"] = { query = "@function.outer", desc = "Jump to previous function end" },
					["[]"] = { query = "@class.outer", desc = "Jump to previous class end" },
				},
			},
		},
	})
end

return M
