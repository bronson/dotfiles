" vimsy's .vimrc
"
" Don't use abbreviations!  Spelling things out makes grepping easy.
" After installing this .vimrc, run vim-update-bundles to install the
" plugins: https://github.com/bronson/vim-update-bundles


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
set autowrite         " write buffers before invoking :make, :grep etc.
set nrformats=alpha,hex " C-A/C-X works on dec, hex, and chars (not octal so no leading 0 ambiguity)

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing

set backspace=indent,eol,start "allow backspacing over everything in insert mode
set history=1000               "store lots of :cmdline history

set hidden          " allow buffers to go into the background without needing to save

let g:is_posix = 1  " vim's default is archaic bourne shell, bring it up to the 90s.

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

" wish I could make mapleader be space but vim waits for a second
" every time you hit the space key.
" <Plug>DiscretionaryEnd
" let mapleader=" "


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
" 'q' inside quickfix window closes it (like nerdtree, bufexplorer, etc)
au BufWinEnter * if &buftype == 'quickfix' | map q :cclose<CR> | endif


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

" quicker to navigate the quickfix window, just control-n, control-p
nmap <silent> <C-n> :cn<CR>
nmap <silent> <C-p> :cp<CR>

" color schemes

" desert is too low contrast
" slate is great except comments are horrible
" adaryn is very close to the solaris/emacs I used at OpenTV
" nice: breeze, evening, navajo-night
colorscheme evening


" highlight rspec keywords properly
" modified from tpope and technicalpickles: https://gist.github.com/64635
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function


" Plugins:

runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)


" BUNDLE: git://github.com/scrooloose/nerdtree.git
nmap <Space>d :NERDTreeToggle<cr>
nmap <Space>D :NERDTreeFind<cr>


" BUNDLE: git://github.com/scrooloose/nerdcommenter.git
" Use Control-/ to toggle comments
map <C-/> <plug>NERDCommenterToggle<CR>
" And Command-/ works on the Mac
map <D-/> <plug>NERDCommenterToggle<CR>
" And C-/ produces C-_ on most terminals
map <C-_> <plug>NERDCommenterToggle<CR>


" BUNDLE: git://github.com/tpope/vim-surround.git
" tell surround not to break the visual s keystroke (:help vs)
xmap S <Plug>Vsurround

" BUNDLE: git://github.com/majutsushi/tagbar.git
nmap <Space>l :TagbarToggle<cr>

" BUNDLE: git://github.com/vim-scripts/bufexplorer.zip.git
nmap <Space>b :BufExplorer<cr>

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
" BUNDLE: git://github.com/bronson/vim-runtest.git
"
"    text objects    :he text-objects
" TODO: rewrite ruby-block-conv to use textobj-rubyblock
" BUNDLE: git://github.com/bronson/vim-ruby-block-conv.git
" BUNDLE: git://github.com/kana/vim-textobj-user.git
" Ruby text objects: ar, ir
" BUNDLE: git://github.com/nelstrom/vim-textobj-rubyblock.git
" Paramter text objects (between parens and commas): aP, iP
" BUNDLE: git://github.com/vim-scripts/Parameter-Text-Objects.git
" indent text objects: ai, ii, (include line below) aI, iI
"   ai,ii work best for Python, aI,II work best for Ruby/C/Perl
" BUNDLE: git://github.com/michaeljsmith/vim-indent-object.git

" BUNDLE: git://github.com/godlygeek/tabular.git

" BUNDLE: git://github.com/tpope/vim-endwise.git
" BUNDLE: git://github.com/tpope/vim-repeat.git

" BUNDLE: git://github.com/tpope/vim-fugitive.git
" TODO: this prompt seems to cause huge delays with big repos on MacOS X
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

" BUNDLE: git://github.com/ervandew/supertab.git

" BUNDLE: git://github.com/bronson/vim-visual-star-search.git
" BUNDLE: git://github.com/bronson/vim-trailing-whitespace.git
" BUNDLE: git://github.com/bronson/vim-toggle-wrap.git

" BUNDLE: git://github.com/Raimondi/YAIFA.git
" verbosity=1 allows you to check YAIFA's results by running :messages
let g:yaifa_verbosity = 0

" BUNDLE: git://github.com/vim-scripts/AutoTag.git
" BUNDLE: git://github.com/robgleeson/vim-markdown-preview.git


" The Ruby debugger only works in mvim!  It won't work in a terminal.
" BUNDLE: git://github.com/astashov/vim-ruby-debugger.git
" let g:ruby_debugger_debug_mode = 1
let g:ruby_debugger_progname = 'mvim'   " TODO: how to autodetect this?
" Use Eclipse-like keystrokes: F5=step, F6=next, F7=return
" If on a Mac you must hit Fn-F5 or switch "Use all F1..." in Keyboard control panel.
" Also, the Mac seems to eat most Control-Fkeys so use Shift-Fkey as a synonym.
noremap <F5>    :call g:RubyDebugger.step()<CR>
noremap C-<F5>  :call g:RubyDebugger.continue()<CR>
noremap S-<F5>  :call g:RubyDebugger.continue()<CR>
noremap <F6>    :call g:RubyDebugger.next()<CR>
noremap C-<F6>  :call g:RubyDebugger.continue()<CR>
noremap S-<F6>  :call g:RubyDebugger.continue()<CR>
noremap <F7>    :call g:RubyDebugger.finish()<CR>
noremap C-<F7>  :call g:RubyDebugger.exit()<CR>
noremap S-<F7>  :call g:RubyDebugger.exit()<CR>


" Syntax Files:
" BUNDLE: git://github.com/pangloss/vim-javascript.git
" BUNDLE: git://github.com/vim-scripts/jQuery.git
" BUNDLE: git://github.com/tsaleh/vim-shoulda.git
" BUNDLE: git://github.com/tpope/vim-git.git
" BUNDLE: git://github.com/tpope/vim-cucumber.git
" BUNDLE: git://github.com/tpope/vim-haml.git
" should move back to hallison or plasticboy markdown when they pick up new changes
" BUNDLE: git://github.com/gmarik/vim-markdown.git
" BUNDLE: git://github.com/timcharper/textile.vim.git
" BUNDLE: git://github.com/kchmck/vim-coffee-script.git
" BUNDLE: git://github.com/ajf/puppet-vim.git
" BUNDLE: git://github.com/bdd/vim-scala.git

" Color Schemes:
" BUNDLE: git://github.com/tpope/vim-vividchalk.git
" BUNDLE: git://github.com/wgibbs/vim-irblack.git

" TODO: BUNDLE: git://github.com/hallettj/jslint.vim.git
" TODO: BUNDLE: git://github.com/ecomba/vim-ruby-refactoring.git
" TODO: BUNDLE: git://github.com/scrooloose/syntastic.git
" TODO: BUNDLE: git://github.com/int3/vim-extradite.git
" TODO: BUNDLE: git://github.com/rson/vim-conque.git
" TODO: the only decent gdb frontend looks to be pyclewn?
