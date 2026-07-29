return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
  },
  keys = {
    { '<leader>f', vim.lsp.buf.format, desc = 'Format buffer', mode = 'n' },
    { '<leader>ln', '<cmd>NullLsInfo<CR>', desc = 'Show null-ls info', mode = 'n' },
  },
  opts = function()
    local null_ls = require 'null-ls'
    local h = require 'null-ls.helpers'
    local shfmt = null_ls.builtins.formatting.shfmt.with {
      filetypes = { 'sh', 'zsh', 'zshrc' },
      extra_args = { '-i', '2', '-ci' },
    }
    -- cargo install kdlfmt
    local kdlfmt = h.make_builtin {
      name = 'kdlfmt',
      method = null_ls.methods.FORMATTING,
      filetypes = { 'kdl' },
      generator_opts = {
        command = 'kdlfmt',
        args = { 'format', '$FILENAME' },
        to_stdin = true,
        to_temp_file = false,
      },
      factory = h.formatter_factory,
    }

    return {
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.completion.spell,
        null_ls.builtins.diagnostics.zsh,
        shfmt,
        kdlfmt,
      },
      -- null_ls.builtins.diagnostics.eslint_d,
    }

    --vim.keymap.set('n', '<leader>kd', vim.lsp.buf.format, {})
  end,
}
