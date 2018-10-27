" This .vimrc has been copied from my nvim config at .config/nvim/init.vim
" The goal is to create a functional, stripped-down gvim for use as an
" external editor in other programs.

set background=dark
set nocompatible
" filetype off
set noswapfile
set smartcase

" Colorschemes I like:
colorscheme desert		" Very muted dark with black-on-white status
" colorscheme industry	" Like desert, but better contrast
" colorscheme koehler		" Higher contrast. Default statusbar is ugly
" colorscheme murphy		" Nice, muted dark with kelly-green statusbars
" colorscheme pablo			" Very dark, super low-contrast comments
" colorscheme peachpuff	" Muted and moody. A little like desert
" colorscheme ron				" High contrast dark pastel
" colorscheme slate			" High con dark pastel. Comments... ++yellow.
" colorscheme torte			" Low-con dark pastel. Not bad

" Some settings from my vimrc:
set mouse=a
set number
set relativenumber
set lbr!
set tabstop=2 softtabstop=2 expandtab shiftwidth=2
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set nohlsearch
set spelllang=en_us
set guioptions-=m  "menu bar
set guioptions-=T  "toolbar
set guioptions-=r  "scrollbar
set guifont=Fira\ Code\ Regular\ 14
set spell

let &colorcolumn="80"

" Buffer handling
set switchbuf=useopen,newtab

" Autocommands
autocmd!
au FocusLost * :wa
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.txt setlocal spell
au BufRead,BufNewFile *.html setlocal spell

" Jump to last cursor position on reopen
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif

" Mappings
let mapleader = '\'
nnoremap <tab> %
vnoremap <tab> %
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Tame strange behaviour
nnoremap <leader><space> :noh<cr>

" Let's try this at the end of the file
syntax on
highlight ColorColumn ctermbg=black guibg=gray18
highlight Pmenu ctermbg=darkgray
if has('gui_running')
  set lines=30 columns=85
endif

" Since nvim handles all of the interesting stuff, Gvim is just for editing
" for other programs (namely Evolution, but also Firefox?). Thus, setup
" rational line-handling depending on launching program.

if expand('%:t')[0:2] ==? "evo"
  setlocal textwidth=80
else
  nnoremap j gj
  nnoremap k gk
endif
