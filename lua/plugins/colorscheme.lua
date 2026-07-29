return {
  --'navarasu/onedark.nvim',
  --'catppuccin/nvim',
  -- 'bluz71/vim-nightfly-colors',
  'loctvl842/monokai-pro.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins

  config = function()
  require("monokai-pro").setup({
    -- ... your config
    background_clear = {"float_win"},
     filter = "spectrum"
    -- ... your config
})

    --vim.cmd.colorscheme 'onedark'
    -- vim.cmd.colorscheme 'nightfly'
    vim.cmd.colorscheme 'monokai-pro'
  end,
}
