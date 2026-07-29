return {
  'folke/zen-mode.nvim',
  keys = {
    { '<leader>zz', '<cmd>ZenMode<CR>', desc = 'Toggle zen mode', mode = 'n' },
  },
  opts = {
    window = {
      width = 120,

      options = {
        signcolumn = 'no', -- disable signcolumn
        number = false, -- disable number column
        relativenumber = false, -- disable relative numbers
        cursorline = false, -- disable cursorline
        cursorcolumn = false, -- disable cursor column
        foldcolumn = '0', -- disable fold column
        colorcolumn = '0',
        list = false, -- disable whitespace characters
      },
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false, -- disables the ruler text in the cmd line area
        -- showcmd = false, -- disables the command in the last line of the screen
        -- statusline will be shown only if 'laststatus' == 3
        -- laststatus = 0, -- turn off the statusline in zen mode
      },
    },
  },
}
