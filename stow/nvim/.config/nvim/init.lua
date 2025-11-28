vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.mouse = 'a'
vim.opt.clipboard = 'unnamedplus'
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.updatetime = 250
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Keymaps
local map = vim.keymap.set
local opts = { silent = true }

map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<S-l>', ':bnext<CR>', opts)
map('n', '<S-h>', ':bprevious<CR>', opts)
map('n', '<Esc>', ':nohlsearch<CR>', opts)
map('v', '<', '<gv', opts)
map('v', '>', '>gv', opts)
map('v', 'J', ":m '>+1<CR>gv=gv", opts)
map('v', 'K', ":m '<-2<CR>gv=gv", opts)
map('n', '<C-d>', '<C-d>zz', opts)
map('n', '<C-u>', '<C-u>zz', opts)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({ 'git', 'clone', '--filter=blob:none', 'https://github.com/folke/lazy.nvim.git', '--branch=stable', lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require('lazy').setup({
    { 'catppuccin/nvim', name = 'catppuccin', priority = 1000, config = function() vim.cmd.colorscheme('catppuccin-mocha') end },
    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate', config = function()
        require('nvim-treesitter.configs').setup({ ensure_installed = { 'lua', 'bash', 'python', 'yaml', 'json', 'markdown' }, highlight = { enable = true }, indent = { enable = true } })
    end },
    { 'nvim-telescope/telescope.nvim', branch = '0.1.x', dependencies = { 'nvim-lua/plenary.nvim' }, config = function()
        local b = require('telescope.builtin')
        map('n', '<leader>ff', b.find_files)
        map('n', '<leader>fg', b.live_grep)
        map('n', '<leader>fb', b.buffers)
    end },
    { 'lewis6991/gitsigns.nvim', config = true },
    { 'numToStr/Comment.nvim', config = true },
    { 'windwp/nvim-autopairs', event = 'InsertEnter', config = true },
    { 'christoomey/vim-tmux-navigator' },
}, {})

-- Autocommands
vim.api.nvim_create_autocmd('TextYankPost', { callback = function() vim.highlight.on_yank() end })
