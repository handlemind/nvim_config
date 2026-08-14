-- [[ Neotest: test explorer + running/debugging tests ]]
-- Runs and displays tests (pass/fail signs, output, summary tree) and can
-- debug them through nvim-dap via `strategy = "dap"`.
--
-- Debugging reuses the Delve adapter defined in `lua/plugins/dap.lua`
-- (`dap.adapters.delve`), so no extra Go debug plugin is needed.
--
-- Language adapters are listed under `dependencies` and registered in `setup`.
-- Add more adapters (e.g. neotest-python) as needed.
return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    'mfussenegger/nvim-dap',
    -- Language adapters
    { 'fredrikaverpil/neotest-golang', version = '*' },
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run() end, desc = 'Test: run nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Test: run [f]ile' },
    { '<leader>ta', function() require('neotest').run.run(vim.fn.getcwd()) end, desc = 'Test: run [a]ll' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Test: run [l]ast' },
    { '<leader>tx', function() require('neotest').run.stop() end, desc = 'Test: stop' },
    -- Debug via nvim-dap (Delve). Capital D avoids the gitsigns <leader>td map.
    { '<leader>tD', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Test: [D]ebug nearest' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test: toggle [s]ummary' },
    { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = 'Test: show [o]utput' },
    { '<leader>tp', function() require('neotest').output_panel.toggle() end, desc = 'Test: toggle output [p]anel' },
    { '[t', function() require('neotest').jump.prev { status = 'failed' } end, desc = 'Test: prev failed' },
    { ']t', function() require('neotest').jump.next { status = 'failed' } end, desc = 'Test: next failed' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {
          -- Reuse the Delve adapter from plugins/dap.lua for debugging tests.
          dap_mode = 'manual',
          dap_manual_config = {
            type = 'delve',
          },
        },
      },
    }
  end,
}
