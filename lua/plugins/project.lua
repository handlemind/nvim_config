-- [[ Configure project.nvim ]]
-- Superior project management, integrated with fzf-lua
-- See https://github.com/DrKJeff16/project.nvim
return {
  'DrKJeff16/project.nvim',
  event = 'VeryLazy',
  dependencies = {
    'ibhagwan/fzf-lua',
  },
  opts = {
    -- Detect the project root via LSP, falling back to pattern matching.
    lsp = {
      enabled = true,
      use_pattern_matching = true,
    },
    -- Enable the fzf-lua picker (`:Project fzf-lua`)
    fzf_lua = {
      enabled = true,
    },
    patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', 'go.mod', 'Cargo.toml' },
  },
  config = function(_, opts)
    require('project').setup(opts)

    vim.keymap.set('n', '<leader>sp', '<cmd>Project fzf-lua<cr>', { desc = '[S]earch [P]rojects' })
    vim.keymap.set('n', '<leader>pp', '<cmd>Project<cr>', { desc = '[P]rojects: open [P]roject UI' })
  end,
}
