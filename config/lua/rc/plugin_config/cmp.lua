local M = {}

M.requires = {
	-- snip engine
	"L3MON4D3/LuaSnip",
	-- sources
	"saadparwaiz1/cmp_luasnip",
	"hrsh7th/cmp-nvim-lsp",
	-- "hrsh7th/cmp-nvim-lua",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	-- format
	"onsails/lspkind.nvim",
}

-- call cmp.setup
local function setup(cmp)
	local luasnip = require("luasnip")
	local ok_lspkind, lspkind = pcall(require, "lspkind")

	-- lspkind format
	local formatting = nil
	if ok_lspkind then
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol", -- show only symbol annotations
				maxwidth = 50,
				menu = { -- show which source that completion item came from
					buffer = "[buf]",
					nvim_lsp = "[LSP]",
					nvim_lua = "[api]",
					path = "[path]",
					luasnip = "[snip]",
					cmdline = "[cmd]",
				},
			}),
		}
	else
		vim.notify_once(
			"Plugin 'lspkind' not found.\nCompletion will not have fancy icon and it's origin",
			vim.log.levels.WARN
		)
	end

	cmp.setup({
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
		},

		sources = cmp.config.sources({
			{ name = "nvim_lua" },
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		}),

		preselect = true,
		mapping = {
			["<C-Up>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
			["<C-Down>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),

			["<Up>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				else
					fallback()
				end
			end, { "i", "c" }),
			["<Down>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				else
					fallback()
				end
			end, { "i", "c" }),

			["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
			["<C-e>"] = cmp.mapping({ i = cmp.mapping.abort(), c = cmp.mapping.close() }),

			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = false,
			}),

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.confirm({ select = false })
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
		},

		formatting = formatting,
		experimental = {
			ghost_text = true,
		},
	})
end

local function setup_search(cmp)
	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})
end

local function setup_cmdline(cmp)
	-- disable tabs on command
	vim.keymap.set("c", "<Tab>", "<nop>", { desc = "disable tab on command" })
	vim.keymap.set("c", "<S-Tab>", "<nop>", { desc = "disable S-tab on command" })

	cmp.setup.cmdline(":", {
		mapping = {
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.confirm({ select = false })
				else
					fallback()
				end
			end, { "c" }),
		},
		sources = {
			{ name = "cmdline" },
			{ name = "path" },
		},
	})
end

-- vscode theme
local function set_hightlight()
	vim.cmd([[highlight CmpItemAbbrDeprecated guibg=NONE gui=strikethrough guifg=#808080]])
	vim.cmd([[highlight CmpItemAbbrMatch guibg=NONE guifg=#569CD6]])
	vim.cmd([[highlight CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6]])
	vim.cmd([[highlight CmpItemKindVariable guibg=NONE guifg=#9CDCFE]])
	vim.cmd([[highlight CmpItemKindInterface guibg=NONE guifg=#9CDCFE]])
	vim.cmd([[highlight CmpItemKindText guibg=NONE guifg=#9CDCFE]])
	vim.cmd([[highlight CmpItemKindFunction guibg=NONE guifg=#C586C0]])
	vim.cmd([[highlight CmpItemKindMethod guibg=NONE guifg=#C586C0]])
	vim.cmd([[highlight CmpItemKindKeyword guibg=NONE guifg=#D4D4D4]])
	vim.cmd([[highlight CmpItemKindProperty guibg=NONE guifg=#D4D4D4]])
	vim.cmd([[highlight CmpItemKindUnit guibg=NONE guifg=#D4D4D4]])
end

function M.update_capabilities(capabilities)
	capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
	return capabilities
end

-- setup, setup_cmdline, setup_search, set_hightlight
function M.config()
	local ok, cmp = pcall(require, "cmp")
	if not ok then
		vim.notify_once("plugin 'cmp.nvim' not found, skip setup cmpletion", vim.log.levels.WARN)
		return
	end
	setup(cmp)
	setup_cmdline(cmp)
	setup_search(cmp)
	set_hightlight()
end

return M
