" I'm writing a new config based on my .vimrc. I may later decide to blow it
" away and do something totally different.

function ResizePane()
  let hmax = max([winwidth(0), float2nr(&columns*0.66), 90])
  let vmax = max([winheight(0), float2nr(&lines*0.66), 25])
  exe "vertical resize" . (min([hmax, 140]))
  exe "resize" . (min([vmax,60]))
endfunction

set background=dark
set nocompatible
filetype off
set noswapfile
set smartcase

" Add autoload to runtime path
set runtimepath+=$HOME/.config/nvim/autoload

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

" Load 16-bit default colorscheme and change some of the irritating colors
colorscheme dim
highlight clear ColorColumn
highlight clear SpellBad
highlight clear SpellLocal
highlight clear SpellCap
let &colorcolumn="80"
highlight ColorColumn ctermbg=16
highlight SpellBad cterm=underline,italic ctermfg=196
highlight SpellLocal cterm=italic ctermfg=44
highlight SpellCap cterm=underline,italic ctermfg=44

" let base16colorspace=256

" Buffer handling
set switchbuf=useopen,newtab

" Autocommands
autocmd!
au FocusLost * :wa
au WinLeave * set nowrap
au WinEnter * set wrap
au WinEnter * set lbr
" Jump to last cursor position on reopen
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
augroup pandoc_syntax
	au! BufNewFile,BufFilePre,BufRead *.md set filetype=markdown.pandoc
  au BufNewFile,BufFilePre,BufRead *.md setlocal textwidth=80
  au BufRead,BufNewFile *.md setlocal spell
augroup END
augroup dos_plaintext
  au BufRead,BufNewFile *.txt setlocal textwidth=80
  au BufRead,BufNewFile *.txt setlocal spell
  au BufRead,BufNewFile *.txt setlocal fileformat=dos
augroup END
augroup evolution_email
  au BufRead,BufNewFile /tmp/evo* setlocal textwidth=71
  au BufRead,BufNewFile /tmp/evo* setlocal spell
augroup END
augroup qutebrowser_formfield
  au BufRead,BufNewFile /tmp/qutebrowser* setlocal textwidth=80
  au BufRead,BufNewFile /tmp/qutebrowser* set filetype=html
  au BufRead,BufNewFile /tmp/qutebrowser* setlocal spell
augroup html
  au BufNewFile,BufRead *.html setlocal textwidth=80
  au BufNewFile,BufRead *.html setlocal spell
  au BufNewFile,BufRead *.html source ~/.local/share/nvim/site/autoload/closetag.vim
augroup END
augroup latex
  au BufRead,BufNewFile *.tex setlocal spell
  au BufRead,BufNewFile *.tex setlocal textwidth=80
augroup END
augroup java
  au BufRead,BufNewFile *.java setlocal tabstop=3
  au BufRead,BufNewFile *.java setlocal softtabstop=3
  au BufRead,BufNewFile *.java setlocal shiftwidth=3
  au BufRead,BufNewFile *.java setlocal expandtab
augroup END
augroup firenvim
  au BufEnter *.com_*.txt colorscheme bold-light
  au BufEnter outlook.office.com_*.txt colorscheme bold
augroup END

" Mappings
let mapleader = '\'
nnoremap <tab> %
vnoremap <tab> %
nnoremap <C-h> <C-w>h:call ResizePane()<CR>
nnoremap <C-j> <C-w>j:call ResizePane()<CR>
nnoremap <C-k> <C-w>k:call ResizePane()<CR>
nnoremap <C-l> <C-w>l:call ResizePane()<CR>
nnoremap <Leader>] :w<CR>:bn<CR>
nnoremap <Leader>[ :w<CR>:bp<CR>

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
Plug 'lervag/vimtex'
Plug 'alvan/vim-closetag'
Plug 'https://bitbucket.org/natemaia/vim-jinx'
Plug 'rainglow/vim'
Plug 'glacambre/firenvim'
" Plug 'chriskempson/base16-vim'

" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

" Plug 'valloric/youcompleteme'
call plug#end()

if !exists('g:gui_oni')
	" NERDTree
	map <C-n> :NERDTreeToggle<cr>
	let g:NERDTreeMouseMode = 3
	let g:NERDTreeShowLineNumbers = 1
  let g:NERDTreeWinSize = 35

	" Airline
	let g:airline#extensions#tabline#enabled = 1
	let g:airline_theme = 'minimalist'
endif

let g:airline_powerline_fonts = 1

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = ''
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDDefaultAlighn = 'left'

" Deoplete
let g:deoplete#enable_at_startup = 1

" Firenvim config. So I can write in Firefox with Neovim. What a world...
let g:firenvim_config = {
    \ 'localSettings': {
        \ '.*': {
            \ 'selector': 'textarea',
            \ 'priority': 0,
        \ }
    \ }
\ }
