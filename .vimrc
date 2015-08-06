set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'JulesWang/css.vim'
Plugin 'othree/html5.vim'
Plugin 'tComment'
Plugin 'pangloss/vim-javascript'
Plugin 'elzr/vim-json'
Plugin 'godlygeek/tabular'
Plugin 'sirtaj/vim-openscad'
Bundle 'gabrielelana/vim-markdown'
call vundle#end()
filetype plugin indent on
syntax on

set ruler
set number
set wildmenu
set hlsearch
set showcmd
set laststatus=2
set cmdheight=2
set autoindent

set paste
set expandtab
set shiftwidth=2
set softtabstop=2

set backspace=2

au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown
let g:markdown_enable_spell_checking = 0

noremap > >>
noremap < <<
vnoremap > >gv
vnoremap < <gv
