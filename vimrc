" General
set nocompatible " Don't try and work with vi
set showmode
set autoread " Update when file changed externally
set ruler " cursor location
set cursorline " highlight current line
set undolevels=500 " Undo history
set undofile
set undodir=~/.vim/undofiles
set number " Show line numbers
set showmatch " Show matching bracket
syntax enable
colorscheme monokai
hi Normal ctermbg=none
hi NonText ctermbg=none
hi LineNr ctermbg=none
set encoding=utf-8
set expandtab " Use spaces
set smarttab
set backspace=indent,eol,start " allow backspacing over everything in insert mode
set nobackup
set textwidth=88
set hidden " Don't close buffer when window closes

" Go up/down visual lines not by wrappedl lines
nnoremap j gj
nnoremap k gk
nnoremap <up> g<up>
nnoremap <down> g<down>

" 1 tab == 4 spaces
set shiftwidth=4
set tabstop=4
set softtabstop=4

set ai " Auto indent
set si " Smart indent
set wrap " Wrap lines

" Searching
set ignorecase
set smartcase " Case sensitive if capitals in string
set incsearch
set hlsearch
" press F8 to turn the search results highlight off
noremap <F8> :nohl<CR>
inoremap <F8> <Esc>:nohl<CR>a

" Spellcheck toggle
noremap <F6> :setlocal spell! spelllang=en_gb<CR>
inoremap <F6> <C-o>:setlocal spell! spelllang=en_gb<CR>
