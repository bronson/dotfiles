if has("gui_macvim")
  set guifont=Menlo\ Regular:h16
  " set guifont=Inconsolata-g:h11
  " set guifont=Inconsolata\ Medium\ 10
  " set guifont=* to bring up a font selector, set guifont? to see result
endif

set guioptions+=lLrR  " idiotic vim bug, vim 7.4.56  http://thisblog.runsfreesoftware.com/?q=Remove+scrollbars+from+Gvim
set guioptions-=lLrR  " remove scroll bars from vim windows, it's just noise

set t_vb= " don't flash the screen for visualbell (:he vb)

set background=dark

set number   " show line numbers in gui

" it's handy to show where the cursor is
" highlight CursorLine   cterm=NONE ctermbg=black ctermfg=NONE guibg=#2b2b2b guifg=NONE 
" highlight CursorColumn cterm=NONE ctermbg=black ctermfg=NONE guibg=#2b2b2b guifg=NONE 

set cursorline
