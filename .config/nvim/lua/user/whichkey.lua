local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  key_labels = {
    -- override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    -- ["<space>"] = "SPC",
    ["<leader>"] = "SPC",
    -- ["<cr>"] = "RET",
    -- ["<tab>"] = "TAB",
  },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  window = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "center", -- align columns left, center or right
  },
  ignore_missing = false, -- enable this to hide mappings for which you didn't specify a label
  hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers_blacklist = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    i = { "j", "k" },
    v = { "j", "k" },
  },
  -- disable the WhichKey popup for certain buf types and file types.
  -- Disabled by deafult for Telescope
  disable = {
    buftypes = {},
    filetypes = { "TelescopePrompt" },
  },
}
local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local m_opts = {
  mode = "n", -- NORMAL mode
  prefix = "m",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local m_mappings = {
  -- a = { "<cmd>silent BookmarkAnnotate<cr>", "Annotate" },
  -- c = { "<cmd>silent BookmarkClear<cr>", "Clear" },
  -- b = { "<cmd>silent BookmarkToggle<cr>", "Toggle" },
  -- m = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "Harpoon" },
  -- ["."] = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "Harpoon Next" },
  -- [","] = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "Harpoon Prev" },
  -- l = { "<cmd>lua require('user.bfs').open()<cr>", "Buffers" },
  -- j = { "<cmd>silent BookmarkNext<cr>", "Next" },
  -- s = { "<cmd>Telescope harpoon marks<cr>", "Search Files" },
  -- k = { "<cmd>silent BookmarkPrev<cr>", "Prev" },
  -- S = { "<cmd>silent BookmarkShowAll<cr>", "Prev" },
  -- -- s = {
  -- --   "<cmd>lua require('telescope').extensions.vim_bookmarks.all({ hide_filename=false, prompt_title=\"bookmarks\", shorten_path=false })<cr>",
  -- --   "Show",
  -- -- },
  -- x = { "<cmd>BookmarkClearAll<cr>", "Clear All" },
  -- [";"] = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "Harpoon UI" },
}

local mappings = {
  -- ["1"] = "which_key_ignore",
  -- a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Action" },
  -- b = { "<cmd>Telescope buffers<cr>", "Buffers" },
  -- e = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
  -- v = { "<cmd>vsplit<cr>", "vsplit" },
  -- h = { "<cmd>split<cr>", "split" },
  -- w = { "<cmd>w<CR>", "Write" },
  -- -- h = { "<cmd>nohlsearch<CR>", "No HL" },
  -- q = { '<cmd>lua require("user.functions").smart_quit()<CR>', "Quit" },
  -- ["/"] = { '<cmd>lua require("Comment.api").toggle.linewise.current()<CR>', "Comment" },
  -- -- ["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  -- c = { "<cmd>Bdelete!<CR>", "Close Buffer" },
  --
  -- -- :lua require'lir.float'.toggle()
  -- -- ["f"] = {
  -- --   "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
  -- --   "Find files",
  -- -- },
  -- -- ["F"] = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
  -- -- P = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
  -- -- ["R"] = { '<cmd>lua require("renamer").rename()<cr>', "Rename" },
  -- -- ["z"] = { "<cmd>ZenMode<cr>", "Zen" },
  -- ["gy"] = "Link",
  --
  -- B = {
  --   name = "Browse",
  --   i = { "<cmd>BrowseInputSearch<cr>", "Input Search" },
  --   b = { "<cmd>Browse<cr>", "Browse" },
  --   d = { "<cmd>BrowseDevdocsSearch<cr>", "Devdocs" },
  --   f = { "<cmd>BrowseDevdocsFiletypeSearch<cr>", "Devdocs Filetype" },
  --   m = { "<cmd>BrowseMdnSearch<cr>", "Mdn" },
  -- },
  --
  -- p = {
  --   name = "Packer",
  --   c = { "<cmd>PackerCompile<cr>", "Compile" },
  --   i = { "<cmd>PackerInstall<cr>", "Install" },
  --   s = { "<cmd>PackerSync<cr>", "Sync" },
  --   S = { "<cmd>PackerStatus<cr>", "Status" },
  --   u = { "<cmd>PackerUpdate<cr>", "Update" },
  -- },
  --
  -- o = {
  --   name = "Options",
  --   c = { '<cmd>lua vim.g.cmp_active=false<cr>', "Completion off" },
  --   C = { '<cmd>lua vim.g.cmp_active=true<cr>', "Completion on" },
  --   w = { '<cmd>lua require("user.functions").toggle_option("wrap")<cr>', "Wrap" },
  --   r = { '<cmd>lua require("user.functions").toggle_option("relativenumber")<cr>', "Relative" },
  --   l = { '<cmd>lua require("user.functions").toggle_option("cursorline")<cr>', "Cursorline" },
  --   s = { '<cmd>lua require("user.functions").toggle_option("spell")<cr>', "Spell" },
  --   t = { '<cmd>lua require("user.functions").toggle_tabline()<cr>', "Tabline" },
  --
  -- },
  --
  -- -- s = {
  -- --   name = "Split",
  -- --   s = { "<cmd>split<cr>", "HSplit" },
  -- --   v = { "<cmd>vsplit<cr>", "VSplit" },
  -- -- },
  --
  -- s = {
  --   name = "Session",
  --   s = { "<cmd>SaveSession<cr>", "Save" },
  --   r = { "<cmd>RestoreSession<cr>", "Restore" },
  --   x = { "<cmd>DeleteSession<cr>", "Delete" },
  --   f = { "<cmd>Autosession search<cr>", "Find" },
  --   d = { "<cmd>Autosession delete<cr>", "Find Delete" },
  --   -- a = { ":SaveSession<cr>", "test" },
  --   -- a = { ":RestoreSession<cr>", "test" },
  --   -- a = { ":RestoreSessionFromFile<cr>", "test" },
  --   -- a = { ":DeleteSession<cr>", "test" },
  -- },
  --
  -- r = {
  --   name = "Replace",
  --   r = { "<cmd>lua require('spectre').open()<cr>", "Replace" },
  --   w = { "<cmd>lua require('spectre').open_visual({select_word=true})<cr>", "Replace Word" },
  --   f = { "<cmd>lua require('spectre').open_file_search()<cr>", "Replace Buffer" },
  -- },
  --
  d = {
    name = "Debug",
  --   b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
  --   c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
  --   i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
  --   o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
  --   O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
  --   r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
  --   l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
  --   u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
  --   x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
  },
  --
  -- -- nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
  -- -- nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
  -- -- require("dapui").open()
  -- -- require("dapui").close()
  -- -- require("dapui").toggle()
  --
  f = { name = "Find" },
  l = { name = "LSP" },
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
  ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', "Comment" },
  s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
  -- z = { "<cmd>TZNarrow<cr>", "Narrow" },
}

which_key.setup(setup)
which_key.register(mappings, opts)
which_key.register(vmappings, vopts)
which_key.register(m_mappings, m_opts)
