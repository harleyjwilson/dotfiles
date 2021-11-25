" BASIC SETUP:

" Disable compatibility with vi which can cause unexpected issues.
set nocompatible

" Enable type file detection. Vim will be able to try to detect the type of file in use.
filetype on

" Enable plugins and load plugin for the detected file type.
filetype plugin on

" Load an indent file for the detected file type.
filetype indent on

" Turn syntax highlighting on.
syntax on

" Add numbers to each line on the left-hand side.
set number

" PLUGINS ---------------------------------------------------------------- {{{

" NerdTREE filesystem plug in
call plug#begin()
Plug 'preservim/nerdtree'
call plug#end()



" }}}

" PLUGINS SETTINGS ---------------------------------------------------------------- {{{

" NerdTREE settings
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif




" }}}

" MAPPINGS --------------------------------------------------------------- {{{

" Type jj to exit insert mode quickly.
inoremap jj <Esc>

" }}}
