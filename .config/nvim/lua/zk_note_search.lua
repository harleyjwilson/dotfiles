local M = {}

--- Open an asynchronous MiniPick search of zk's indexed note titles and bodies.
function M.open_note_search_picker()
  local pick = require('mini.pick')
  local util = require('zk.util')
  local format_note_title_and_id = require('zk_picker_titles').format_note_title_and_id
  local root = util.notebook_root(util.resolve_notebook_path(0))
  if not root then
    vim.notify('zk note search: no notebook found', vim.log.levels.WARN)
    return
  end

  local picker_buffer, process
  -- Reject results from an older query or a picker that has since closed.
  local function is_current_search(querytick)
    local state = pick.get_picker_state()
    return state and state.buffers.main == picker_buffer and pick.get_querytick() == querytick
  end

  local function search_zk_index(query, querytick)
    if not is_current_search(querytick) then return end
    local command = { 'zk', '--notebook-dir=' .. root, '--working-dir=' .. root, 'list', '--quiet', '--format', '{{path}}\t{{title}}' }
    if query ~= '' then vim.list_extend(command, { '--match', query }) end

    process = vim.system(command, { text = true }, function(result)
      vim.schedule(function()
        if not is_current_search(querytick) then return end
        if result.code ~= 0 then
          vim.notify('zk note search: ' .. vim.trim(result.stderr or 'search failed'), vim.log.levels.WARN)
          return
        end

        local items = {}
        for line in (result.stdout or ''):gmatch('[^\n]+') do
          local path, title = line:match('^(.-)\t(.*)$')
          if path then
            table.insert(items, {
              text = format_note_title_and_id(title, path),
              path = vim.fs.joinpath(root, path),
            })
          end
        end
        pick.set_picker_items(items, { do_match = false, querytick = querytick })
      end)
    end)
  end

  pick.start({
    source = {
      name = 'Search notes',
      cwd = root,
      items = function()
        picker_buffer = pick.get_picker_state().buffers.main
        return {}
      end,
      match = function(_, _, query)
        if process then process:kill() end
        local querytick = pick.get_querytick()
        pick.set_picker_items({}, { do_match = false, querytick = querytick })
        -- Debounce CLI searches while typing; stale timers fail the querytick check.
        vim.defer_fn(function() search_zk_index(table.concat(query), querytick) end, 150)
      end,
    },
  })
end

return M
