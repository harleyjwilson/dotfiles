local M = {}

--- Show all zk notebook tags, then find notes with every selected tag by default.
function M.open_tag_search_picker(options)
  options = options or {}
  local strategy = options.multi_select_strategy or 'AND'
  local zk = require('zk')

  zk.pick_tags(options, { title = 'Search notes by tag' }, function(selected_tags)
    if #selected_tags == 0 then return end

    local names = vim.tbl_map(function(tag) return tag.name end, selected_tags)
    -- zk's LSP takes one tag per array entry for AND; it does not parse CLI commas.
    local filters = strategy == 'OR' and { table.concat(names, ' OR ') } or names
    local note_options = vim.tbl_extend('force', options, { tags = filters })
    note_options.multi_select_strategy = nil
    zk.edit(note_options, { title = 'Notes with ' .. table.concat(names, ' ' .. strategy .. ' ') })
  end)
end

return M
