-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", {desc="Jump to Left Window"},opts)
keymap("n", "<C-j>", "<C-w>j", {desc="Jump to Top Window"},opts)
keymap("n", "<C-k>", "<C-w>k", {desc="Jump to Bottom Window"},opts)
keymap("n", "<C-l>", "<C-w>l", {desc="Jump to Right Window"},opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", {desc="Resize Window Up" }, opts)
keymap("n", "<C-Down>", ":resize +2<CR>", {desc="Resize Window Down"}, opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", {desc="Resize Window Left"}, opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", {desc="Resize Window Right"},opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>",  {desc="Next Buffer"},opts)
keymap("n", "<S-h>", ":bprevious<CR>", {desc="Prev Buffer"},opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", {desc="Toggle Search Highlight" },opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", {desc="Close Buffer"},opts)

-- Better paste
keymap("v", "p", '"_dP', {desc="Paste"}, opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Plugins --
-- Whichkey
keymap("n", "?", ":WhichKey<CR>", {desc="Whichkey" },opts)

-- NvimTree
keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Explorer" }, opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find Files" }, opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", { desc = "Find Text" }, opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", { desc = "Projects" }, opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Buffers" }, opts)

-- Comment
keymap(
	"n",
	"<leader>/",
	"<cmd>lua require('Comment.api').toggle.linewise.current()<CR>",
	{ desc = "Toggle Comments" },
	opts
)
keymap(
	"x",
	"<leader>/",
	'<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
	{ desc = "Toggle Comments" }
)

-- DAP
keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", {desc="Toggle Breakpoint"}, opts)
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", {desc="Continue"},opts)
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", {desc="Step Into"},opts)
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", {desc="Step Over"},opts)
keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", {desc="Step Out"}, opts)
-- keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
-- keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", { desc = "Toggle DAPUI"}, opts)
keymap("n", "<leader>dt", "<cmd>lua require'dap'.terminate()<cr>", {desc="Terminate"}, opts)
