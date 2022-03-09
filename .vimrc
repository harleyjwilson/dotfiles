" vim:fileencoding=utf-8:foldmethod=marker

" Plugin Loader {{{

call plug#begin('~/.vim/plugged')

Plug 'preservim/nerdtree' 
Plug 'junegunn/fzf'
Plug 'tpope/vim-fugitive'

call plug#end()

" }}}

" General Settings {{{

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

" Set search result highlighting 
set hls
set is
    
" Set tabs to spaces, and tab expansion to spaces
set tabstop=4
set softtabstop=4
set expandtab

" }}}

" Mappings {{{

" Type jj to exit insert mode quickly.
" noremap jj <Esc>

" Press the space bar to type the : character in command mode.
" nnoremap <space> :

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" }}}

" Snippets {{{

" }}}

" Plugin Settings {{{

" NerdTREE settings

" }}}
