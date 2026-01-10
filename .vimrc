let mapleader = " "

" ----- Basic sane defaults -----
set nocompatible
syntax on
filetype plugin indent on

" ----- UI -----
set number              " Show line numbers
set mouse=a             " Enable mouse
set laststatus=2        " Always show statusline

" ----- Editing behavior -----
set autoindent
set backspace=indent,eol,start
set hidden              " Allow switching buffers without saving

" ----- Search -----
set incsearch           " Show matches as you type
set hlsearch            " Highlight matches
set ignorecase
set smartcase

" ----- Clipboard -----
"http://stackoverflow.com/questions/20186975/vim-mac-how-to-copy-to-clipboard-without-pbcopy
set clipboard^=unnamed
set clipboard^=unnamedplus

" ----- Files -----
set autoread            " Reload files changed outside Vim
set noswapfile
set nobackup
set nowritebackup
set encoding=utf-8

" ----- Splits -----
set splitright
set splitbelow

" Faster updates (useful for git diffs or terminal vim)
set updatetime=300

" Completion menu behaves sensibly
set completeopt=menu,menuone

" Reduce noise
set noerrorbells
set shortmess+=c

" Leader + Arrow keys for split navigation
nnoremap <leader><Left>  <C-w>h
nnoremap <leader><Down>  <C-w>j
nnoremap <leader><Up>    <C-w>k
nnoremap <leader><Right> <C-w>l
