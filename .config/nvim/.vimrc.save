" vim:fileencoding=utf-8:foldmethod=marker

" Plugin Loader {{{

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf'
Plug 'preservim/nerdtree' 
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'

call plug#end()

" }}}

" General Settings {{{

" Turn syntax highlighting on
syntax on

" Set \t to 4 spaces
set tabstop=4

" Set tab key to 4 spaces
set softtabstop=4

" Set tabs to expand to 4 spaces
set expandtab

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" Add numbers to each line on the left-hand side
set number

" Enable type file detection. Vim will be able to try to detect the type of file in use
filetype on

" Set search result highlighting 
set hls

" Set partial search result highlighting
set is

" Use system clipboard
set clipboard=unnamedplus

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" This rule creates an exception to use tabs instead of spaces
" for a makefile.
autocmd Filetype make setlocal noexpandtab

" Sets a verticle column after x amount of characters to prevent a line being
" too long.
set colorcolumn=78

" }}}

" Mappings {{{

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Open NERDTree with <CR>n
nnoremap <C-n> :NERDTree<CR>

" }}}

" Plugin Settings {{{

" NerdTREE settings

" Start NERDTree when Vim is started without file arguments.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" }}}
