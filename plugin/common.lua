-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  group = highlight_group,
  desc = 'Highlight when yanking text',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.diagnostic.config({
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
  underline = true,
  signs = true,
  virtual_text = {
    spacing = 2,
  },
})