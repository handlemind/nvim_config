return {
  -- Autocompletion
  'hrsh7th/nvim-cmp',
  dependencies = {
    -- Snippet Engine & its associated nvim-cmp source
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',

    -- Adds LSP completion capabilities
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',

    -- Adds a number of user-friendly snippets
    'rafamadriz/friendly-snippets',
  },
  config = function()
    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      window = {
        completion = cmp.config.window.bordered {
          border = vim.o.winborder ~= '' and vim.o.winborder or 'rounded',
          max_height = 15,
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None',
        },
        documentation = {
          border = vim.o.winborder ~= '' and vim.o.winborder or 'rounded',
          max_width = math.floor(vim.o.columns / 2),
          max_height = 20,
          winhighlight = 'Normal:NormalFloat,FloatBorder:FloatBorder',
        },
      },
      formatting = {
        fields = { 'abbr', 'kind', 'menu' },
        format = function(entry, item)
          local max_total = math.max(30, math.floor(vim.o.columns / 2) - 4)
          local kind_w = vim.fn.strdisplaywidth(item.kind or '')
          local max_abbr = math.max(16, max_total - kind_w - 8)

          if item.abbr and vim.fn.strdisplaywidth(item.abbr) > max_abbr then
            item.abbr = vim.fn.strcharpart(item.abbr, 0, max_abbr - 1) .. '…'
          end

          item.menu = ({
            nvim_lsp = 'LSP',
            luasnip = 'Snip',
            path = 'Path',
          })[entry.source.name] or entry.source.name

          return item
        end,
      },
      completion = {
        completeopt = 'menu,menuone,noinsert',
      },
      mapping = cmp.mapping.preset.insert {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete {},
        ['<C-y>'] = cmp.mapping.confirm { select = true },
        ['<CR>'] = cmp.mapping.confirm {
          behavior = cmp.ConfirmBehavior.Replace,
          select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { 'i', 's' }),
      },
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'path' },
      },
    }

    cmp.event:on('menu_opened', function(evt)
      local entries_win = evt.window.entries_win
      if not entries_win or not entries_win.win or not vim.api.nvim_win_is_valid(entries_win.win) then
        return
      end
      local max_w = math.max(20, math.floor(vim.o.columns / 2))
      local style = entries_win.style
      if not style or style.width <= max_w then
        return
      end
      style.width = max_w
      vim.api.nvim_win_set_config(entries_win.win, {
        relative = style.relative,
        row = style.row,
        col = style.col,
        width = max_w,
        height = style.height,
        border = style.border,
      })
    end)
  end,
}
