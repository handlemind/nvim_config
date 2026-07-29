-- Useful plugin to show you pending keybinds.
return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  priority = 100,
  opts = {},
  keys = {},
  config = function()
    -- document existing key chainsf
    -- {
    --   { "<leader>", group = "VISUAL <leader>", mode = "v" },
    --   { "<leader>h", desc = "Git [H]unk", mode = "v" },
    -- }
    -- require('which-key').register {
    --   { '<leader>c', desc = '[C]ode', _ = 'which_key_ignore' },
    --   { '<leader>d', desc = '[D]ocument', _ = 'which_key_ignore' },
    --   { '<leader>g', desc = '[G]it', _ = 'which_key_ignore' },
    --   { '<leader>h', desc = 'Git [H]unk', _ = 'which_key_ignore' },
    --   { '<leader>r', desc = '[R]ename', _ = 'which_key_ignore' },
    --   { '<leader>s', desc = '[S]earch', _ = 'which_key_ignore' },
    --   { '<leader>t', desc = '[T]oggle', _ = 'which_key_ignore' },
    --   { '<leader>w', desc = '[W]orkspace', _ = 'which_key_ignore' },
    -- }
    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
  end,
}
