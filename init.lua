-- from https://github.com/radsoc/kickstart.nvim/blob/master/init.lua

local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd('packadd packer.nvim')
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Gruvbox theme
  use 'ellisonleao/gruvbox.nvim'

  -- Mason (installs language servers for example)
  use { "williamboman/mason.nvim",
  	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",}

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use "nvim-treesitter/nvim-treesitter"

  -- syntastic, python flake8 seems to be active by default
  use "vim-syntastic/syntastic"

-- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Global settings
vim.g.mapleader = ','

vim.opt.smartindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.laststatus = 2
vim.opt.cursorline = true
vim.opt.number = true
vim.opt.mouse = 'a'

-- Ignore the case when the search pattern is all lowercase
vim.opt.smartcase = true
vim.opt.ignorecase = true

-- Set colorscheme
vim.o.termguicolors = true

-- gruvbox setup
require('gruvbox').setup({
  undercurl = true,
  underline = true,
  bold = false,
  italic = {},
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = true, -- invert background for search, diffs, statuslines and errors
  contrast = 'hard', -- can be 'hard', 'soft' or empty string
  palette_overrides = {},
  overrides = {
    SignColumn = {bg = '#1d2021'},
    GitSignsAdd = {bg = '#1d2021', fg = '#b8bb26'},
    GitSignsChange = {bg = '#1d2021', fg = '#d65d0e'},
    GitSignsDelete = {bg = '#1d2021', fg = '#cc241d'},
  },
  dim_inactive = false,
  transparent_mode = false,
})
vim.cmd('colorscheme gruvbox')

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', '<Leader>lk', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', '<Leader>lg', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
  vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', '<Leader>lb', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<space>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end


-- Mason setup
require("mason").setup()
require("mason-lspconfig").setup()

-- Language Server Setup
require("lspconfig").pyright.setup{
    on_attach = on_attach,
}

require('lualine').setup {
  options = {
    theme = 'gruvbox',
    icons_enabled = false,
  },
  sections = {
    lualine_c = {
      {
        'filename',
        file_status = true,
        path = 1,
      }
    }
  }
}

require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
  },
  ensure_installed = {
    'c',
    'lua',
    'vim',
    'help',
    'javascript',
    'typescript',
    'tsx',
    'css',
    'json',
    'python',
    'cpp',
    'fsh',
    'elm',
    'haskell',
    'html',
    'htmldjango',
    'nix',
    'ocaml',
    'rust',
  },
})

-- display diagnostic messages as floating text
vim.diagnostic.config({
  float = { source = "always", border = border },
  virtual_text = false,
  signs = true,
})

vim.cmd('autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})')

-- syntastic setup
vim.opt.statusline:append('%#warningmsg#')
vim.opt.statusline:append('%{SyntasticStatuslineFlag()}')
vim.opt.statusline:append('%*')
vim.g['syntastic_always_populate_loc_list'] = '1'
vim.g['syntastic_check_on_open'] = '0'
vim.g['syntastic_check_on_wq'] = '0'
