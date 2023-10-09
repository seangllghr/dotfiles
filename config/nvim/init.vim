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
Plug 'morhetz/gruvbox'

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

" Gruvbox apparently requires quite the call, and some stuff to tweak colors
autocmd vimenter * ++nested colorscheme gruvbox

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX) && getenv('TERM_PROGRAM') != 'Apple_Terminal')
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif

let g:gruvbox_contrast_dark = "hard"
let g:gruvbox_color_column = "bg2"

" Neovide-related GUI settings
if exists("g:neovide")
  set guifont=FiraCode\ Nerd\ Font:h11
endif
