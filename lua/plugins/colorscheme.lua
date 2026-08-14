return {
  --'navarasu/onedark.nvim',
  --'catppuccin/nvim',
  -- 'bluz71/vim-nightfly-colors',
  --'loctvl842/monokai-pro.nvim',
  'EdenEast/nightfox.nvim',
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    -- transparent = true,
    -- theme = 'dragon', --  wave dragon lotus
  },
  config = function()
  -- require("monokai-pro").setup({
  --   background_clear = {"float_win"},
  --   filter = "spectrum"
  -- })

    --vim.cmd.colorscheme 'onedark'
    -- vim.cmd.colorscheme 'nightfly'
    vim.cmd.colorscheme 'nightfox'
    --vim.cmd.colorscheme 'monokai-pro'
  end,
}
