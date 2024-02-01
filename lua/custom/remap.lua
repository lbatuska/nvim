
local set = vim.opt
local cmd = vim.cmd
local o = vim.o
local map = vim.api.nvim_set_keymap

vim.api.nvim_set_keymap('n', '<Space>', '', {})
vim.g.mapleader = ' '

options = { noremap = true }

-- Terminal back to normal mode
map( 't', '<leader><Esc>', '<C-\\><C-n>', options)
-- Tab interaction
map( 'n', '<leader><tab>', ':tabnext<cr>', options)
-- SHIFT + TAB prev tab
map( 'n', '<leader><S-Tab>', ':tabprev<cr>', options)
-- From http://vimdoc.sourceforge.net/htmldoc/cmdline.html#filename-modifiers,
-- :p Make file name a full path.
-- :h Head of the file name (the last component and any separators removed)
map( 'n', '<leader>t', ':tabnew %:h<cr>', options)
--map( 'n', '<leader>w', ':tabclose<cr>', options)
map( 'n', '<leader>w', ':close<cr>', options) -- Instead use close so we can separately close splits instead of closing the whole tab
-- Vertical split terminal
map( 'n', '<leader>T', ':vsplit term://bash<cr>', options)
-- Resize vertual split ctrl + shift + arrows
map( 'n', '<C-S-Left>', ':vertical resize +5<CR>', options)
map( 'n', '<C-S-Right>', ':vertical resize -5<CR>', options)

map( 'n', '<C-S-Up>', ':horizontal resize +5<CR>', options)
map( 'n', '<C-S-Down>', ':horizontal resize -5<CR>', options)

-- Next split
map('n', '<M-Right>', ':execute "wincmd w"<CR>', { noremap = true, silent = true })
-- Last split
map('n', '<M-Left>', ':execute "wincmd W"<CR>', { noremap = true, silent = true })
