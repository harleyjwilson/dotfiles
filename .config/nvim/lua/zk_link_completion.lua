local M = {}

--- Reuse mini.pairs closing brackets when accepting a zk wiki link completion.
function M.reuse_existing_wikilink_closers(items)
  if vim.bo.filetype ~= 'markdown' then return items end

  -- The completion base has been removed by Neovim at this point, so the
  -- characters after the cursor are the auto-paired closing brackets.
  local col = vim.api.nvim_win_get_cursor(0)[2]
  if vim.api.nvim_get_current_line():sub(col + 1, col + 2) ~= ']]' then return items end

  for _, item in ipairs(items) do
    local client = item.client_id and vim.lsp.get_client_by_id(item.client_id)
    local edit = item.textEdit
    if client and client.name == 'zk' and edit and type(edit.newText) == 'string'
      and edit.newText:match('^%[%[.*%]%]$') then
      edit.newText = edit.newText:sub(1, -3)
    end
  end
  return items
end

return M
