-- [[ General ]]

-- Enable mouse support
vim.opt.mouse = 'a'
-- Copy/paste to system clipboard
vim.opt.clipboard = 'unnamedplus'
-- Don't use swapfile
vim.opt.swapfile = false
vim.opt.backup = false
local undodir = vim.fs.joinpath(vim.fn.stdpath 'state', 'undo')
vim.fn.mkdir(undodir, 'p')
vim.opt.undodir = undodir
vim.opt.undofile = true

-- [[ Neovim UI ]]

vim.opt.guicursor = ''
vim.opt.nu = true -- Set the absolute number
vim.opt.relativenumber = true -- Set the relative number

-- Enable folding (default 'foldmarker')
-- vim.opt.foldmethod = 'syntax'
--vim.opt.foldcolumn = "1" -- Show the fold column
vim.opt.foldmethod = 'expr'
vim.opt.foldlevelstart = 99
-- vim.o.foldexpr = 'nvim_treesitter#foldexpr()'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

-- Line lenght marker at 80 columns
vim.opt.colorcolumn = '80'

-- Ignore case letters when search
vim.opt.ignorecase = true

-- Ignore lowercase for the whole pattern
vim.opt.smartcase = true

-- Highlight matching parenthesis
vim.opt.showmatch = true

-- Enable 24-bit RGB colors
vim.opt.termguicolors = true

-- Set completeopt to have a better completion experience
vim.opt.completeopt = 'menuone,noselect'

-- [[ Tabs, indent ]]

-- 1 tab == 4 spaces
vim.opt.tabstop = 4
vim.opt.softtabstop = 4

-- Shift 4 spaces when tab
vim.opt.shiftwidth = 4

-- Use spaces instead of tabs
vim.opt.expandtab = true

-- Autoindent new lines
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.cindent = true
vim.opt.wrap = false -- Do not display text over multiple lines

vim.opt.breakindent = true

-- Make it so that long lines wrap smartly
vim.opt.showbreak = string.rep(' ', 3)

-- Wrap on word boundary
vim.opt.linebreak = true

-- Highlight search serults
vim.opt.hlsearch = true

-- Makes search act like search in modern browsers
vim.opt.incsearch = true

vim.opt.inccommand = 'split'

-- Make it so there are always 5 lines below cursor
vim.opt.scrolloff = 5
vim.opt.signcolumn = 'yes'
vim.opt.isfname:append '@-@'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Display whitespaces characters
vim.opt.list = true
vim.opt.listchars = {
  -- tab = '▷▷⋮',
  -- tab = '» ',
  tab = '→ ',
  extends = '⟩',
  precedes = '⟨',
  trail = '·',
  space = '·',
  nbsp = '␣',
  -- eol = '↴', -- '⤶',--'¬'
}

-- ms to wait for trigger an event
vim.opt.updatetime = 50 -- If in this many milliseconds nothing is typed, the swap file will be written to disk
vim.opt.timeoutlen = 300 -- Time in milliseconds to wait for a mapped sequence to complete
vim.opt.splitbelow = true -- Put new windows below current
vim.opt.splitright = true -- Put new windows right of current
-- Set borders for all floating windows 'rounded'/'single'/'double'/'solid'
vim.o.winborder = 'rounded'
