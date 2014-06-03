if has("gui_macvim")
  set guifont=Menlo\ Regular:h16
  " set guifont=Inconsolata-g:h11
  " set guifont=Inconsolata\ Medium\ 10
  " set guifont=* to bring up a font selector, set guifont? to see result
  macmenu &File.New\ Window key=<nop>
  map <D-n> :cn<CR>
  macmenu &File.Print key=<nop>
  map <D-p> :cp<CR>
endif

set t_vb= " don't flash the screen for visualbell (:he vb)
colorscheme evening

" it's handy to show where the cursor is
set cursorline
set cursorcolumn
