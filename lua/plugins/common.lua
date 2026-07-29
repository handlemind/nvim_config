return {
  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'ThePrimeagen/vim-be-good',

  -- {
  --   'https://github.com/fresh2dev/zellij.vim.git',
  --   lazy = false,
  --   keys = {
  --     { '<leader>tt', ':ZellijNewPane<CR>', mode = { 'n' }, { noremap = true } },
  --     { '<M-f>', ':ZellijNewPane<CR>', mode = { 'n', 'i' }, { noremap = true } },
  --     { '<M-t>', ':ZellijNewPaneSplit<CR>', mode = { 'n', 'i' }, { noremap = true } },
  --     { '<M-j>', ':ZellijNavigateDown<CR>', mode = { 'n', 'i' }, { noremap = true } },
  --   },
  -- },
  {
    'swaits/zellij-nav.nvim',
    lazy = true,
    event = 'VeryLazy',
    keys = {
      { '<c-h>', '<cmd>ZellijNavigateLeftTab<cr>', { silent = true, desc = 'navigate left or tab' } },
      { '<c-j>', '<cmd>ZellijNavigateDownTab<cr>', { silent = true, desc = 'navigate down or tab' } },
      { '<c-k>', '<cmd>ZellijNavigateUpTab<cr>', { silent = true, desc = 'navigate up or tab' } },
      { '<c-l>', '<cmd>ZellijNavigateRightTab<cr>', { silent = true, desc = 'navigate right or tab' } },
    },
    opts = {},
  },

  -- Highlight todo, notes, etc in comments
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ---@module "lua.todo-comments.config"
    ---@type TodoOptions
    opts = { signs = false },
  },

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- Next/Prev highlight <a-n>/<a-p>
  {
    'RRethy/vim-illuminate',
    config = function()
      -- author is rejecting the fact that this method should be called setup for ease of use
      require('illuminate').configure {
        large_file_cutoff = 350,
      }
    end,
  },

  {
    'eandrju/cellular-automaton.nvim',
    keys = {
      { '<leader>zx', '<cmd>CellularAutomaton make_it_rain<CR>', desc = 'Drop buffer' },
      { '<leader>zc', '<cmd>CellularAutomaton scramble<CR>', desc = 'Drop buffer' },
    },
  },

  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = function()
      require('nvim-autopairs').setup { check_ts = true }
      local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
      local cmp = require 'cmp'
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'monokai-pro',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = { 'filename', 'navic' },
        lualine_x = { 'harpoon2', 'encoding', 'fileformat', 'filetype' },
      },
    },
  },

  -- {
  --   -- Add indentation guides even on blank lines
  --   'lukas-reineke/indent-blankline.nvim',
  --   -- See `:help ibl`
  --   main = 'ibl',
  --   opts = {},
  -- },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  { 'catgoose/nvim-colorizer.lua', opts = {} },

  { 'windwp/nvim-ts-autotag', opts = {} },

  { 'aznhe21/actions-preview.nvim', opts = {}, lazy = true },

  {
    'olrtg/nvim-emmet',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },
}
