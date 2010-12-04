" vimsy's .vimrc
"
" Don't use abbreviations!  Spelling things out makes grepping easy.

" Let Pathogen bring in all the plugins
filetype on
filetype off
call pathogen#runtime_append_all_bundles()

filetype indent plugin on
syntax on



" basics

set nocompatible      " tends to make things work better
set showcmd           " show incomplete cmds down the bottom
set showmode          " show current mode down the bottom

set incsearch         " find the next match as we type the search
set hlsearch          " hilight searches by default
set nowrap            " by default, dont wrap lines (see <leader>w)
set showmatch         " briefly jump to matching }] when typing
set nostartofline     " don't jump to start of line as a side effect (i.e. <<)

set scrolloff=3       " lines to keep visible before and after cursor
set sidescrolloff=7   " columns to keep visible before and after cursor
set sidescroll=1      " continuous horizontal scroll rather than jumpy

set laststatus=2      " always display status line even if only one window is visible.
set updatetime=1000   " reduce updatetime so current tag in taglist is highlighted faster
set autoread          " suppress warnings when git,etc. changes files on disk.
set nrformats=alpha,hex " C-A/C-X works on dec, hex, and chars (not octal so no leading 0 ambiguity)

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set backspace=indent,eol,start "allow backspacing over everything in insert mode
set history=1000               "store lots of :cmdline history

set hidden          " allow buffers to go into the background without needing to save

set visualbell      " don't beep constantly, it's annoying.
set t_vb=           " and don't flash the screen either (terminal anyway...
set guioptions-=T   " hide gvim's toolbar by default
" set guifont=Inconsolata\ Medium\ 10
" set guifont=* to bring up a font selector, set guifont? to see result

" search for a tags file recursively from cwd to /
set tags=.tags,tags;/

" Store swapfiles in a single directory.
set directory=~/.vim/swap,~/tmp,/var/tmp/,tmp



" indenting, languages

set expandtab         " use spaces instead of tabstops
set smarttab          " use shiftwidth when hitting tab instead of sts (?)
set autoindent        " try to put the right amount of space at the beginning of a new line
set shiftwidth=2
set softtabstop=2

" autocmd FileType ruby setlocal shiftwidth=2 softtabstop=2
" ruby includes ! and ? in method names (array.empty?)
autocmd FileType ruby setlocal iskeyword+=!,?

let mapleader=" "


" fixes

" Make the escape key bigger, keyboards move it all over.
map <F1> <Esc>
imap <F1> <Esc>

" <C-L> redraws the screen and also turns off highlighting the current search
" NO, it conflicts with moving to different windows.
" nnoremap <C-L> :nohlsearch<CR><C-L>

" add a keybinding to toggle paste mode
nnoremap <leader>p :set paste!<CR>:set paste?<CR>

" make ' jump to saved line & column rather than just line.
" http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '

" make Y yank to the end of the line (like C and D).  Use yy to yank the entire line.
" Upside: feels more natural.  Downside: not stock vi/vim.
nmap Y y$

" Make the quickfix window wrap no matter the setting of nowrap
au BufWinEnter * if &buftype == 'quickfix' | setl wrap | endif


" Make Alt-Arrows switch between windows (like C-W h, etc)
" nmap <silent> <A-Up> :wincmd k<CR>
" nmap <silent> <A-Down> :wincmd j<CR>
" nmap <silent> <A-Left> :wincmd h<CR>
" nmap <silent> <A-Right> :wincmd l<CR>

" Make Control-direction switch between windows (like C-W h, etc)
nmap <silent> <C-k> :wincmd k<CR>
nmap <silent> <C-j> :wincmd j<CR>
nmap <silent> <C-h> :wincmd h<CR>
nmap <silent> <C-l> :wincmd l<CR>


" color schemes

" desert is too low contrast
" slate is great except comments are horrible
" adaryn is very close to the solaris/emacs I used at OpenTV
" nice: breeze, evening, navajo-night
colorscheme evening


" Plugins:

runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)


" BUNDLE: git://github.com/scrooloose/nerdtree.git
nmap <leader>d :NERDTreeToggle<cr>
nmap <leader>D :NERDTreeFind<cr>


" BUNDLE: git://github.com/scrooloose/nerdcommenter.git

" add a space between the comment delimiter and text
let NERDSpaceDelims=1

" Use Control-/ to toggle comments
nmap <C-/> :call NERDComment(0, "toggle")<CR>
vmap <C-/> <ESC>:call NERDComment(1, "toggle")<CR>
" but most vim implementations produce Control-_ instead of Control-/:
nmap <C-_> :call NERDComment(0, "toggle")<CR>
vmap <C-_> <ESC>:call NERDComment(1, "toggle")<CR>
" and vim-gtk and vim-gnome are broken (:help vimsy-control-/)
" you can use <leader>/ to do the same things.
nmap <leader>/ :call NERDComment(0, "toggle")<CR>
vmap <leader>/ <ESC>:call NERDComment(1, "toggle")<CR>
" but maybe <leader>C is nicer to type?
nmap <leader>C  :call NERDComment(0, "toggle")<CR>
vmap <leader>C <ESC>:call NERDComment(1, "toggle")<CR>


" BUNDLE: git://github.com/tpope/vim-surround.git
" tell surround not to break the visual s keystroke (:help vs)
xmap S <Plug>Vsurround


" BUNDLE: http://github.com/vim-scripts/taglist.vim.git
nmap <leader>l :TlistToggle<cr>

" BUNDLE: http://github.com/vim-scripts/bufexplorer.zip.git

" BUNDLE: git://git.wincent.com/command-t.git
" ensure we compile with the system ruby if rvm is installed
" BUNDLE-COMMAND: if which rvm >/dev/null 2>&1; then rvm system exec rake make; else rake make; fi
nmap <silent> <C-Space> :CommandT<CR>
nmap <silent> <C-@> :CommandT<CR>
" let g:CommandTCancelMap = ['<C-c>', '<Esc>', '<C-Space>', '<C-@>']
" let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<Up>', '<ESC>OA']
" let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<Down>', '<ESC>OB']
let g:CommandTMatchWindowAtTop = 1

" BUNDLE: git://github.com/bronson/vim-closebuffer.git
" BUNDLE: git://github.com/vim-ruby/vim-ruby.git
" BUNDLE: git://github.com/tpope/vim-rails.git
" BUNDLE: git://github.com/tpope/vim-rake.git
" BUNDLE: git://github.com/vim-scripts/a.vim.git
" BUNDLE: git://github.com/msanders/snipmate.vim.git
" BUNDLE: git://github.com/scrooloose/snipmate-snippets.git
" BUNDLE: git://github.com/vim-scripts/IndexedSearch.git
" BUNDLE: git://github.com/bronson/vim-ruby-block-conv.git

" BUNDLE: git://github.com/janx/vim-rubytest.git
" taglist currently uses \l. TODO: this will need to be resolved.
map <unique> <Leader>. <Plug>RubyTestRunLast
let g:rubytest_in_quickfix = 1

" BUNDLE: git://github.com/tsaleh/vim-align.git
" The Align plugin declares a TON of maps, few of which are useful
" and some of which conflict with other mappings (like \w and \m).
let g:loaded_AlignMapsPlugin = "v41"

" BUNDLE: git://github.com/tpope/vim-endwise.git
" BUNDLE: git://github.com/tpope/vim-repeat.git

" BUNDLE: git://github.com/tpope/vim-fugitive.git
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" BUNDLE: http://github.com/ervandew/supertab.git
" BUNDLE: git://github.com/bronson/vim-visual-star-search.git
" BUNDLE: git://github.com/bronson/vim-trailing-whitespace.git
" BUNDLE: git://github.com/bronson/vim-toggle-wrap.git

" BUNDLE: git://github.com/Raimondi/YAIFA.git
" verbosity=1 allows you to check YAIFA's results by running :messages
let g:yaifa_verbosity = 0
" yaifa's default produces a 2 second delay when loading huge files.  If you
" can't figure it out in 2048 lines there's no need to churn thru 14000 more.
let g:yaifa_max_lines = 2048

" BUNDLE: http://github.com/vim-scripts/AutoTag.git

" Syntax Files:
" BUNDLE: git://github.com/vim-scripts/jQuery.git
" BUNDLE: git://github.com/tsaleh/vim-shoulda.git
" BUNDLE: git://github.com/tpope/vim-git.git
" BUNDLE: git://github.com/tpope/vim-cucumber.git
" BUNDLE: git://github.com/tpope/vim-haml.git
" BUNDLE: git://github.com/tpope/vim-markdown.git
" BUNDLE: git://github.com/timcharper/textile.vim.git
" BUNDLE: git://github.com/kchmck/vim-coffee-script.git
" Color Schemes:
" BUNDLE: git://github.com/tpope/vim-vividchalk.git
"
" # vim-ruby-debugger's directory layout doesn't work with pathogen.
" # http://tammersaleh.com/posts/the-modern-vim-config-with-pathogen#comment_348
" # :BUNDLE git://github.com/astashov/vim-ruby-debugger.git

" neat idea but I don't use it
" # BUNDLE: git://github.com/rson/vim-conque.git
