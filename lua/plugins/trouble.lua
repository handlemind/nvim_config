return {
  'folke/trouble.nvim',
  keys = {
    { '<leader>xx', '<cmd>TroubleToggle<CR>', desc = 'Troubles', mode = 'n' },
    { '<leader>xq', '<cmd>TroubleToggle quickfix<CR>', desc = 'Trouble quickfix', mode = 'n' },
  },
  opts = {
    icons = false,
  },
}
