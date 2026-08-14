-- autoformat.lua

return {
  -- Autoformat
  'stevearc/conform.nvim',
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Odin buffers autosave frequently for OLS diagnostics; skip format there.
      if vim.bo[bufnr].filetype == 'odin' then
        return
      end
      return {
        timeout_ms = 500,
        lsp_fallback = true,
      }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      javascript = { { 'prettier' } },
      typescript = { { 'prettier' } },
      json = { 'prettierd' },
      html = { { 'prettier' } },
      css = { { 'prettier' } },
      fish = { 'fish_indent' },
      yaml = { 'yamlfmt' },
      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use a sub-list to tell conform to run *until* a formatter
      -- is found.
      -- javascript = { { "prettierd", "prettier" } },
    },
  },
}
