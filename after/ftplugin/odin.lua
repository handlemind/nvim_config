-- Debounced autosave so OLS can run `odin check` on disk (diagnostics otherwise
-- only refresh after a manual save). See https://github.com/DanielGavin/ols/issues/1206
local delay_ms = 750
local timers = {}

local function autosave(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) then
    return
  end
  if vim.bo[bufnr].buftype ~= '' or not vim.bo[bufnr].modifiable then
    return
  end
  if not vim.bo[bufnr].modified or vim.api.nvim_buf_get_name(bufnr) == '' then
    return
  end

  vim.api.nvim_buf_call(bufnr, function()
    -- `update` only writes when modified; keeps didSave so OLS rechecks.
    vim.cmd 'silent! update'
  end)
end

local group = vim.api.nvim_create_augroup('OdinAutosave', { clear = true })

vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI', 'InsertLeave' }, {
  group = group,
  buffer = 0,
  callback = function(args)
    local bufnr = args.buf
    local timer = timers[bufnr]
    if timer then
      timer:stop()
      timer:close()
    end

    timer = vim.uv.new_timer()
    timers[bufnr] = timer
    timer:start(
      delay_ms,
      0,
      vim.schedule_wrap(function()
        if timers[bufnr] then
          timers[bufnr]:stop()
          timers[bufnr]:close()
          timers[bufnr] = nil
        end
        autosave(bufnr)
      end)
    )
  end,
})

vim.api.nvim_create_autocmd('BufUnload', {
  group = group,
  buffer = 0,
  callback = function(args)
    local timer = timers[args.buf]
    if timer then
      timer:stop()
      timer:close()
      timers[args.buf] = nil
    end
  end,
})
