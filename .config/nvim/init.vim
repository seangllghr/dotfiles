" I'm writing a new config based on my .vimrc. I may later decide to blow it
" away and do something totally different.

set background=dark
set nocompatible
filetype off
set noswapfile
set smartcase

" Colorschemes I like:
" colorscheme desert		" Very muted dark with black-on-white status
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

let &colorcolumn="80"
highlight ColorColumn ctermbg=black guibg=gray18
highlight Pmenu ctermbg=darkgray

" Buffer handling
set switchbuf=useopen,newtab

" Autocommands
autocmd!
au FocusLost * :wa
au WinEnter * if (bufname('') !~ '^NERD_tree') && (winwidth(0) < 85) | vertical resize 85 | endif
au WinLeave * set nowrap
au WinEnter * set wrap
au WinEnter * set lbr
au BufRead,BufNewFile *.md setlocal spell
au BufRead,BufNewFile *.txt setlocal spell
au BufRead,BufNewFile *.html setlocal spell
" Jump to last cursor position on reopen
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
augroup pandoc_syntax
	au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  au BufNewFile,BufFilePre,BufRead *.md setlocal textwidth=80
augroup END

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

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'townk/vim-autoclose'
Plug 'ryanoasis/vim-devicons'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'

Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Plug 'valloric/youcompleteme'
call plug#end()

if !exists('g:gui_oni')
	" NERDTree
	map <C-n> :NERDTreeToggle<cr>
	let g:NERDTreeMouseMode = 3
	let g:NERDTreeShowLineNumbers = 1

	" Airline
	let g:airline#extensions#tabline#enabled = 1
	let g:airline_theme = 'minimalist'
endif

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlighn = 'left'

" Deoplete
let g:deoplete#enable_at_startup = 1
