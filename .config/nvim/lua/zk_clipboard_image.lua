local M = {}

local image_types = {
  ['image/png'] = 'png',
  ['image/jpeg'] = 'jpg',
  ['image/webp'] = 'webp',
  ['image/gif'] = 'gif',
}
local preferred_types = { 'image/png', 'image/jpeg', 'image/webp', 'image/gif' }

local function notify_error(message)
  vim.notify('Zettelkasten image paste: ' .. message, vim.log.levels.ERROR)
end

--- Save a Wayland clipboard image under Attachments and embed it at the cursor in a notebook note.
function M.paste_clipboard_image()
  local note = vim.api.nvim_buf_get_name(0)
  local root = vim.fn.fnamemodify(vim.env.ZK_NOTEBOOK_DIR or '~/Zettelkasten', ':p'):gsub('/$', '')
  local relative_note = vim.fs.relpath(root, note)
  if vim.bo.filetype ~= 'markdown' or not relative_note or not relative_note:match('%.md$') then
    notify_error('open a Markdown note inside ' .. root .. ' first')
    return
  end
  if vim.fn.executable('wl-paste') ~= 1 then
    notify_error('wl-paste is required (install wl-clipboard on Wayland)')
    return
  end

  local types = vim.system({ 'wl-paste', '--list-types' }, { text = true }):wait()
  if types.code ~= 0 then
    notify_error('could not read clipboard types: ' .. (types.stderr or ''))
    return
  end
  local available = {}
  for mime in (types.stdout or ''):gmatch('[^\r\n]+') do available[mime] = true end
  local selected_type
  for _, mime in ipairs(preferred_types) do
    if available[mime] then
      selected_type = mime
      break
    end
  end
  if not selected_type then
    notify_error('clipboard contains no supported image (PNG, JPEG, WebP or GIF)')
    return
  end

  local image = vim.system({ 'wl-paste', '--no-newline', '--type', selected_type }):wait()
  if image.code ~= 0 or not image.stdout or #image.stdout == 0 then
    notify_error('could not read clipboard image: ' .. (image.stderr or 'empty output'))
    return
  end

  local attachments = root .. '/Attachments'
  if vim.fn.mkdir(attachments, 'p') == 0 and vim.fn.isdirectory(attachments) == 0 then
    notify_error('could not create ' .. attachments)
    return
  end
  local filename = ('image-%s.%s'):format(os.date('!%Y%m%dT%H%M%S'), image_types[selected_type])
  local path = attachments .. '/' .. filename
  local fd, err = vim.uv.fs_open(path, 'wx', 420) -- 0644; never overwrite an existing attachment
  if not fd then
    notify_error('could not create ' .. path .. ': ' .. (err or 'unknown error'))
    return
  end
  local written = vim.uv.fs_write(fd, image.stdout, 0)
  vim.uv.fs_close(fd)
  if written ~= #image.stdout then
    vim.uv.fs_unlink(path)
    notify_error('could not write clipboard image to ' .. path)
    return
  end

  -- Each directory between the notebook root and the note needs one "../".
  local parent = relative_note:match('^(.*)/[^/]+$') or ''
  local depth = 0
  for _ in parent:gmatch('[^/]+') do depth = depth + 1 end
  -- A relative Markdown image link also works in Obsidian.
  local link = '![](' .. string.rep('../', depth) .. 'Attachments/' .. filename .. ')'
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  vim.api.nvim_buf_set_text(bufnr, row - 1, col, row - 1, col, { link })
  vim.api.nvim_win_set_cursor(0, { row, col + #link - 1 })
end

return M
