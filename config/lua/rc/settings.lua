vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

vim.o.title = true
vim.o.hidden = true
vim.o.swapfile = false
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"
vim.o.conceallevel = 0
vim.o.updatetime = 300
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"
vim.o.iskeyword = vim.o.iskeyword
vim.o.backspace = "indent,eol,start"
vim.g.sessionoptions = "buffers,curdir,help,winsize"
vim.o.pumblend = 7
vim.o.pumheight = 20
vim.o.pumwidth = 10

-- indent settings
vim.o.smarttab = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- search settings
vim.o.ignorecase = true
vim.o.smartcase = true

-- visual settings
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.ruler = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.list = true
vim.o.listchars = "tab:▸ ,trail:·"
vim.o.scrolloff = 5
vim.o.sidescrolloff = 5
-- vim.o.cmdheight = 0

-- window settings
vim.o.splitbelow = true
vim.o.splitright = true
-- vim.o.winfixheight = true
-- vim.o.winfixwidth = true

vim.g.mapleader = " "

vim.g.transparent_bg = false
vim.diagnostic.config({
	update_in_insert = true,
})
