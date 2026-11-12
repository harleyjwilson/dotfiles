local M = {}
local blog_dir = vim.fn.expand('~/projects/hjw/blog')

--- Open the blog project as the current working directory and show its files.
function M.open_blog()
  if vim.fn.isdirectory(blog_dir) == 0 then
    vim.notify('Blog directory not found: ' .. blog_dir, vim.log.levels.ERROR)
    return
  end
  vim.cmd.cd(blog_dir)
  MiniFiles.open(blog_dir)
end

local function create_blog_draft(kind, title)
  local command = { 'pnpm', 'content', 'new', '--type', kind }
  if title then vim.list_extend(command, { '--title', title }) end
  vim.system(command, { cwd = blog_dir, text = true }, function(result)
    vim.schedule(function()
      if result.code ~= 0 then
        vim.notify('Create ' .. kind .. ' draft failed:\n' .. vim.trim((result.stderr or '') .. '\n' .. (result.stdout or '')), vim.log.levels.ERROR)
        return
      end
      local path = result.stdout:match('Created draft ' .. kind .. ': ([^\r\n]+)')
      if not path then
        vim.notify('Create ' .. kind .. ' draft: could not find created file in output:\n' .. (result.stdout or ''), vim.log.levels.ERROR)
        return
      end
      vim.cmd.edit(vim.fn.fnameescape(path))
    end)
  end)
end

--- Prompt for a blog post title, create a draft with the package script, and edit it.
function M.new_blog_post()
  vim.ui.input({ prompt = 'Blog post title: ' }, function(title)
    if not title or vim.trim(title) == '' then return end
    create_blog_draft('post', title)
  end)
end

--- Create today's untitled now update with the package script and edit it.
function M.new_now_post()
  create_blog_draft('now')
end

local function run_blog_command(script)
  if vim.fn.isdirectory(blog_dir) == 0 then
    vim.notify('Blog directory not found: ' .. blog_dir, vim.log.levels.ERROR)
    return
  end
  vim.cmd('botright new')
  vim.fn.termopen({ 'pnpm', script }, { cwd = blog_dir })
end

--- Run the blog package check script (TypeScript and Astro) in a terminal split.
function M.check_blog()
  run_blog_command('check')
end

--- Confirm before running the blog package deploy script in a terminal split.
function M.deploy_blog()
  vim.ui.select({ 'Cancel', 'Deploy' }, { prompt = 'Deploy blog site?' }, function(choice)
    if choice == 'Deploy' then run_blog_command('deploy') end
  end)
end

return M
