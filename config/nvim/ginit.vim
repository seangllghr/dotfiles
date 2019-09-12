" Apparently my GUI settings go in here.

colorscheme boxuk-contrast

if exists('g:GtkGuiLoaded') 
	call rpcnotify(1, 'Gui', 'Font', 'Fira Code 16')
	call rpcnotify(1, 'Gui', 'Option', 'Tabline', 0)
el
	Guifont Source\ Code\ Pro:h14
  GuiTabline 0
endif

if !exists('g:GtkGuiLoaded')
  set lines=40 columns=85
endif

" highlight ColorColumn ctermbg=darkgray guibg=gray18
highlight Pmenu guibg=gray16
