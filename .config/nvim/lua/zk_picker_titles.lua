local M = {}

--- Display a note's H1 title and timestamp ID, falling back to its filename.
function M.format_note_title_and_id(title, path)
  local stem = vim.fn.fnamemodify(path, ':t:r')
  local id = stem:match('^(%d+)')
  if not id or (#id ~= 12 and #id ~= 14) then return title and title ~= '' and title or stem end
  local display_title = title and title:gsub('^' .. id .. '%s+', '') or ''
  if display_title == '' or display_title == id then return stem end
  return display_title .. ' - ' .. id
end

--- Rename zk-nvim note pickers and show title plus ID when opening notes.
function M.configure_note_picker_titles()
  local ui = require('zk.ui')
  local original_pick_notes = ui.pick_notes
  local titles = {
    ['Zk Notes'] = 'Open notes',
    ['Zk Backlinks'] = 'Backlinks',
    ['Zk Insert link'] = 'Insert link',
  }

  ui.pick_notes = function(notes, options, callback)
    local title = options and titles[options.title]
    if title then options = vim.tbl_extend('force', options, { title = title }) end
    if title == 'Open notes' then
      local items = vim.tbl_map(function(note)
        return {
          text = M.format_note_title_and_id(note.title, note.path),
          path = note.absPath,
          value = note,
        }
      end, notes)
      options.minipick = vim.tbl_deep_extend('force', options.minipick or {}, { source = { items = items } })
    end
    return original_pick_notes(notes, options, callback)
  end
end

return M
