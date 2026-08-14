-- [[ Configure fzf-lua ]]
-- Fuzzy Finder (files, lsp, etc), replacement for telescope.
-- See `:help fzf-lua` and https://github.com/ibhagwan/fzf-lua
return {
  'ibhagwan/fzf-lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  event = 'VeryLazy',
  cmd = 'FzfLua',
  config = function()
    local fzf = require 'fzf-lua'

    fzf.setup {
      'default',
      winopts = {
        height = 0.85,
        width = 0.85,
        preview = {
          layout = 'flex',
        },
      },
      keymap = {
        -- Match telescope's disabled <C-u>/<C-d> in insert; keep fzf scroll on preview
        fzf = {
          ['ctrl-q'] = 'select-all+accept',
        },
      },
    }

    -- Use fzf-lua as the handler for vim.ui.select (replaces telescope-ui-select)
    fzf.register_ui_select()

    local map = vim.keymap.set

    -- Find a git root, falling back to cwd (ported from the old telescope config)
    local function find_git_root()
      local current_file = vim.api.nvim_buf_get_name(0)
      local current_dir
      local cwd = vim.fn.getcwd()
      if current_file == '' then
        current_dir = cwd
      else
        current_dir = vim.fn.fnamemodify(current_file, ':h')
      end

      local git_root = vim.fn.systemlist('git -C ' .. vim.fn.escape(current_dir, ' ') .. ' rev-parse --show-toplevel')[1]
      if vim.v.shell_error ~= 0 then
        print 'Not a git repository. Searching on current working directory'
        return cwd
      end
      return git_root
    end

    vim.api.nvim_create_user_command('LiveGrepGitRoot', function()
      fzf.live_grep { cwd = find_git_root() }
    end, {})

    -- [[ Ported from the old telescope keymaps ]]
    map('n', '<leader>s.', fzf.oldfiles, { desc = '[?] Find recently opened files' })
    map('n', '<leader><space>', fzf.buffers, { desc = '[ ] Find existing buffers' })
    map('n', '<leader>/', fzf.blines, { desc = '[/] Fuzzily search in current buffer' })
    map('n', '<leader>s/', function()
      local paths = {}
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
          local name = vim.api.nvim_buf_get_name(buf)
          if name ~= '' and vim.fn.filereadable(name) == 1 then
            table.insert(paths, name)
          end
        end
      end
      fzf.live_grep { search_paths = paths, prompt = 'Live Grep (open files)> ' }
    end, { desc = '[S]earch [/] in Open Files' })
    map('n', '<leader>ss', fzf.builtin, { desc = '[S]earch [S]elect fzf-lua' })
    map('n', '<leader>gf', fzf.git_files, { desc = 'Search [G]it [F]iles' })
    map('n', '<leader>sf', fzf.files, { desc = '[S]earch [F]iles' })
    map('n', '<leader>sh', fzf.helptags, { desc = '[S]earch [H]elp' })
    map('n', '<leader>sw', fzf.grep_cword, { desc = '[S]earch current [W]ord' })
    map('n', '<leader>sg', fzf.live_grep, { desc = '[S]earch by [G]rep' })
    map('n', '<leader>sG', '<cmd>LiveGrepGitRoot<cr>', { desc = '[S]earch by [G]rep on Git Root' })
    map('n', '<leader>sd', fzf.diagnostics_document, { desc = '[S]earch [D]iagnostics' })
    map('n', '<leader>sr', fzf.resume, { desc = '[S]earch [R]esume' })
    map('n', '<leader>sk', fzf.keymaps, { desc = '[S]earch [K]eymaps' })
    map('n', '<leader>sn', function()
      fzf.files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })

    -- [[ Suggested extras that fzf-lua makes easy ]]
    map('n', '<leader>sD', fzf.diagnostics_workspace, { desc = '[S]earch workspace [D]iagnostics' })
    map('n', '<leader>sc', fzf.commands, { desc = '[S]earch [C]ommands' })
    map('n', '<leader>s:', fzf.command_history, { desc = '[S]earch command history' })
    map('n', '<leader>sm', fzf.marks, { desc = '[S]earch [M]arks' })
    map('n', '<leader>sj', fzf.jumps, { desc = '[S]earch [J]umps' })
    map('n', '<leader>sq', fzf.quickfix, { desc = '[S]earch [Q]uickfix' })
    map('n', '<leader>sR', fzf.registers, { desc = '[S]earch [R]egisters' })
    map('n', '<leader>st', fzf.treesitter, { desc = '[S]earch [T]reesitter symbols' })

    -- Git pickers
    map('n', '<leader>gc', fzf.git_commits, { desc = '[G]it [C]ommits (repo)' })
    map('n', '<leader>gC', fzf.git_bcommits, { desc = '[G]it [C]ommits (buffer)' })
    map('n', '<leader>gs', fzf.git_status, { desc = '[G]it [S]tatus' })
    map('n', '<leader>gb', fzf.git_branches, { desc = '[G]it [B]ranches' })
  end,
}
