local conf = require('telescope.config').values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end

  require('telescope.pickers')
    .new({}, {
      prompt_title = 'Harpoon',
      finder = require('telescope.finders').new_table {
        results = file_paths,
      },
      previewer = conf.file_previewer {},
      sorter = conf.generic_sorter {},
    })
    :find()
end

return {
  {
    'letieu/harpoon-lualine',
  },
  {
    'theprimeagen/harpoon',
    branch = 'harpoon2',
    keys = {
      {
        '<C-e>',
        function()
          toggle_telescope(require('harpoon'):list())
        end,
        desc = 'Open harpoon window',
      },
      {
        '<leader>a',
        function()
          require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
        end,
        desc = 'Markied harpood files',
      },
      {
        '<leader>m',
        function()
          require('harpoon'):list():add()
        end,
        desc = 'Mark harpoon file',
      },
      {
        '<M-h>',
        function()
          require('harpoon'):list():select(1)
        end,
        desc = 'Go to 1 [harpoon]',
      },
      {
        '<M-j>',
        function()
          require('harpoon'):list():select(2)
        end,
        desc = 'Go to 2 [harpoon]',
      },
      {
        '<M-k>',
        function()
          require('harpoon'):list():select(3)
        end,
        desc = 'Go to 3 [harpoon]',
      },
      {
        '<M-l>',
        function()
          require('harpoon'):list():select(4)
        end,
        desc = 'Go to 4 [harpoon]',
      },
    },
    opts = {},
  },
}
