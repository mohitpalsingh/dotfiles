-- Run after Lazy restore. Leave the pinned Neovim submodule unchanged.
local ok, err = pcall(function()
  dofile(vim.fn.stdpath('config') .. '/init.lua')
  vim.cmd('filetype plugin indent on')
  local registry = require('mason-registry')
  local names = { 'lua-language-server', 'clangd', 'jdtls', 'pyright', 'gopls', 'kotlin-language-server' }
  local refreshed, refresh_ok = false, false
  registry.refresh(function(success) refresh_ok = success; refreshed = true end)
  assert(vim.wait(120000, function() return refreshed end, 100), 'Mason registry refresh timed out')
  assert(refresh_ok, 'Mason registry refresh failed')
  local packages = {}
  for _, name in ipairs(names) do
    local package = registry.get_package(name)
    packages[#packages + 1] = package
    if not package:is_installed() and not package:is_installing() then package:install() end
  end
  assert(vim.wait(600000, function()
    for _, package in ipairs(packages) do
      if not package:is_installed() then return false end
    end
    return true
  end, 200), 'Mason installation failed or timed out; inspect :MasonLog')
  local parsers = {
    'vimdoc', 'javascript', 'typescript', 'c', 'cpp', 'lua', 'rust', 'jsdoc',
    'bash', 'go', 'gomod', 'gosum', 'java', 'kotlin', 'python', 'scala', 'json',
    'yaml', 'toml', 'dockerfile', 'proto', 'markdown', 'markdown_inline',
  }
  require('nvim-treesitter').install(parsers):wait(600000)
  local installed = require('nvim-treesitter').get_installed('parsers')
  for _, parser in ipairs(parsers) do
    assert(vim.tbl_contains(installed, parser), 'Treesitter parser missing: ' .. parser)
  end
end)
if not ok then
  io.stderr:write(tostring(err) .. '\n')
  vim.cmd('cquit 1')
end
vim.cmd('qa!')
