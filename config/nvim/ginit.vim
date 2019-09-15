" Apparently my GUI settings go in here.

colorscheme boxuk-contrast
hi CursorLineNr guifg=#658c9c guibg=#030304 gui=NONE
hi LineNr guifg=#33474f guibg=#07080a gui=NONE

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

" Keybinds to switch font sizes
nnoremap <Leader>1 :GuiFont Source\ Code\ Pro:h11<CR>
nnoremap <Leader>2 :GuiFont Source\ Code\ Pro:h14<CR>
