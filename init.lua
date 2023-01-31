-- from https://github.com/radsoc/kickstart.nvim/blob/master/init.lua

local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  -- Gruvbox theme
  use 'ellisonleao/gruvbox.nvim'

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

-- Set colorscheme
vim.o.termguicolors = true
require('gruvbox').setup({
  undercurl = true,
  underline = true,
  bold = false,
  italic = false,
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
vim.cmd([[colorscheme gruvbox]])
