-- [[ Configure DAP (Debug Adapter Protocol) ]]
return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'igorlfs/nvim-dap-view',
    'Jorenar/nvim-dap-disasm',
    'NANDquark/nvim-dap-odin',
  },
  keys = {
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'DAP: Toggle [B]reakpoint' },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'DAP: Conditional [B]reakpoint',
    },
    { '<leader>dc', function() require('dap').continue() end, desc = 'DAP: [C]ontinue / start' },
    { '<leader>dC', function() require('dap').run_to_cursor() end, desc = 'DAP: Run to [C]ursor' },
    { '<leader>di', function() require('dap').step_into() end, desc = 'DAP: Step [I]nto' },
    { '<leader>do', function() require('dap').step_over() end, desc = 'DAP: Step [O]ver' },
    { '<leader>dO', function() require('dap').step_out() end, desc = 'DAP: Step [O]ut' },
    { '<leader>dl', function() require('dap').run_last() end, desc = 'DAP: Run [L]ast' },
    { '<leader>dr', function() require('dap').repl.toggle() end, desc = 'DAP: Toggle [R]EPL' },
    { '<leader>dt', function() require('dap').terminate() end, desc = 'DAP: [T]erminate' },
    { '<leader>dv', '<cmd>DapViewToggle<CR>', desc = 'DAP: Toggle [V]iew' },
    { '<leader>dd', '<cmd>DapDisasm<CR>', desc = 'DAP: [D]isassembly' },
    {
      '<leader>de',
      function() require('dap.ui.widgets').hover() end,
      mode = { 'n', 'v' },
      desc = 'DAP: [E]valuate under cursor',
    },
    { '<F5>', function() require('dap').continue() end, desc = 'DAP: Continue' },
    { '<F10>', function() require('dap').step_over() end, desc = 'DAP: Step over' },
    { '<F11>', function() require('dap').step_into() end, desc = 'DAP: Step into' },
    { '<F12>', function() require('dap').step_out() end, desc = 'DAP: Step out' },
  },
  config = function()
    local dap = require 'dap'

    -- Signs
    vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticError', numhl = '' })
    vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = 'DiagnosticWarn', numhl = '' })
    vim.fn.sign_define('DapLogPoint', { text = '◆', texthl = 'DiagnosticInfo', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticWarn', linehl = 'Visual', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '', texthl = 'DiagnosticHint', numhl = '' })

    -- [[ UI: nvim-dap-view + nvim-dap-disasm ]]
    require('dap-view').setup {
      auto_toggle = true,
      winbar = {
        sections = {
          'watches',
          'scopes',
          'exceptions',
          'breakpoints',
          'threads',
          'disassembly',
          'repl',
          'console',
        },
        default_section = 'scopes',
        controls = {
          enabled = true,
          position = 'left',
        },
      },
    }

    require('dap-disasm').setup {
      dapview_register = true,
      dapview = {
        keymap = 'D',
        label = 'Disassembly',
        short_label = '󰒓 [D]',
      },
    }

    local function mason_bin(name)
      local base = vim.fs.joinpath(vim.fn.stdpath 'data', 'mason', 'bin', name)
      local candidates = { base }
      if vim.fn.has 'win32' == 1 then
        candidates = { base .. '.cmd', base .. '.exe', base .. '.bat', base }
      end
      for _, candidate in ipairs(candidates) do
        if vim.fn.executable(candidate) == 1 then
          return candidate
        end
      end
      return name
    end

    -- [[ Adapter: CodeLLDB ]]
    local codelldb_cmd = mason_bin 'codelldb'

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = codelldb_cmd,
        args = { '--port', '${port}' },
      },
    }

    -- [[ Configurations ]]
    local function pick_executable()
      local sep = package.config:sub(1, 1)
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. sep, 'file')
    end

    local function prompt_args()
      local input = vim.fn.input 'Program args: '
      return vim.split(input, ' ', { trimempty = true })
    end

    local codelldb_configs = {
      {
        name = 'Launch',
        type = 'codelldb',
        request = 'launch',
        program = pick_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        terminal = 'integrated',
        args = {},
      },
      {
        name = 'Launch (with args)',
        type = 'codelldb',
        request = 'launch',
        program = pick_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        terminal = 'integrated',
        args = prompt_args,
      },
      {
        -- Stops at `main` in SOURCE (like GDB's stopAtBeginningOfMainSubprogram).
        -- Prefer this over `stopOnEntry`, which stops at the ELF entry point
        -- (`_start`) in disassembly and surfaces as "signal SIGSTOP".
        name = 'Launch (break at main)',
        type = 'codelldb',
        request = 'launch',
        program = pick_executable,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        terminal = 'integrated',
        args = {},
        preRunCommands = { 'breakpoint set --name main' },
      },
      {
        name = 'Attach to process',
        type = 'codelldb',
        request = 'attach',
        pid = require('dap.utils').pick_process,
        cwd = '${workspaceFolder}',
      },
    }

    dap.configurations.c = codelldb_configs
    dap.configurations.cpp = codelldb_configs
    dap.configurations.rust = codelldb_configs
    dap.configurations.zig = codelldb_configs

    -- [[ Odin: nvim-dap-odin ]]
    -- Plugin defers DAP registration by 100ms, which races with F5 on first load.
    local odin_dap = require 'nvim-dap-odin'
    odin_dap.setup {
      build_flags = '-debug',
      notifications = true,
    }
    odin_dap.setup_dap_config()

    local odin_project_cwd

    local function with_buf_cwd(fn)
      local start = vim.fn.expand '%:p:h'
      if start == '' then
        start = vim.fn.getcwd()
      end
      local old = vim.fn.getcwd()
      vim.fn.chdir(start)
      local ok, result = pcall(fn)
      vim.fn.chdir(old)
      if not ok then
        error(result)
      end
      return result
    end

    local function odin_program(auto_build)
      return function()
        local path = with_buf_cwd(function()
          local main_dir = odin_dap.find_main_directory()
          odin_project_cwd = main_dir
          return odin_dap.get_program_path { auto_build = auto_build }
        end)
        if not path or path == '' then
          return dap.ABORT
        end
        return path
      end
    end

    local function odin_args()
      return vim.split(vim.fn.input 'Program args: ', ' ', { trimempty = true })
    end

    local odin_configs = {
      {
        name = 'Odin: Auto-build and Launch',
        type = 'codelldb',
        request = 'launch',
        program = odin_program(true),
        cwd = function()
          return odin_project_cwd or vim.fn.getcwd()
        end,
        stopOnEntry = false,
        terminal = 'integrated',
        args = {},
      },
      {
        name = 'Odin: Auto-build and Launch (with args)',
        type = 'codelldb',
        request = 'launch',
        program = odin_program(true),
        cwd = function()
          return odin_project_cwd or vim.fn.getcwd()
        end,
        stopOnEntry = false,
        terminal = 'integrated',
        args = odin_args,
      },
      {
        name = 'Odin: Launch (Manual)',
        type = 'codelldb',
        request = 'launch',
        program = odin_program(false),
        cwd = function()
          return odin_project_cwd or vim.fn.getcwd()
        end,
        stopOnEntry = false,
        terminal = 'integrated',
        args = {},
      },
      {
        name = 'Odin: Launch (Manual, with args)',
        type = 'codelldb',
        request = 'launch',
        program = odin_program(false),
        cwd = function()
          return odin_project_cwd or vim.fn.getcwd()
        end,
        stopOnEntry = false,
        terminal = 'integrated',
        args = odin_args,
      },
    }
    dap.configurations.odin = odin_configs
    -- Plugin setup_dap_config is also deferred 100ms; re-apply so it doesn't win the race.
    vim.defer_fn(function()
      dap.configurations.odin = odin_configs
    end, 150)

    -- [[ Adapter: Delve (Go) ]]
    local dlv_cmd = mason_bin 'dlv'

    dap.adapters.delve = function(callback, config)
      if config.mode == 'remote' and config.request == 'attach' then
        callback {
          type = 'server',
          host = config.host or '127.0.0.1',
          port = config.port or '38697',
        }
      else
        callback {
          type = 'server',
          port = '${port}',
          executable = {
            command = dlv_cmd,
            args = { 'dap', '-l', '127.0.0.1:${port}', '--log', '--log-output=dap' },
            -- Delve must not be detached on Unix so it dies with Neovim.
            detached = vim.fn.has 'win32' == 0,
          },
        }
      end
    end

    dap.configurations.go = {
      {
        type = 'delve',
        name = 'Debug',
        request = 'launch',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug (package)',
        request = 'launch',
        program = '${fileDirname}',
      },
      {
        type = 'delve',
        name = 'Debug (with args)',
        request = 'launch',
        program = '${fileDirname}',
        args = prompt_args,
      },
      {
        type = 'delve',
        name = 'Debug test (current file)',
        request = 'launch',
        mode = 'test',
        program = '${file}',
      },
      {
        type = 'delve',
        name = 'Debug test (package)',
        request = 'launch',
        mode = 'test',
        program = '${fileDirname}',
      },
      {
        type = 'delve',
        name = 'Attach to process',
        request = 'attach',
        mode = 'local',
        processId = require('dap.utils').pick_process,
      },
    }
  end,
}
