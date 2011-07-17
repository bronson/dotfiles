" vimsy's .vimrc
"
" Don't use abbreviations!  Spelling things out makes grepping easy.
" After installing this .vimrc, run vim-update-bundles to install the
" plugins: https://github.com/bronson/vim-update-bundles

set nocompatible
filetype on   " work around stupid osx bug
filetype off

" set up Vundle
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
" Tell Vim to ignore BundleCommand until vundle supports it
com! -nargs=? BundleCommand


filetype indent plugin on
syntax on


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
" include ! and ? in Ruby method names so you can hit ^] on a.empty?
autocmd FileType ruby setlocal iskeyword+=!,?

" TODO? Turn on jquery syntax highlighting in jquery files
" autocmd BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery

" TODO?  save: marks from '10 files, "100 lines in each register
"  :20 lines of command history, % the bufer list, and put it all in ~/.viminfo
" set viminfo='10,\"100,:20,%,n~/.viminfo

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

Bundle 'https://github.com/gmarik/vundle'

Bundle 'https://github.com/scrooloose/nerdtree'
nmap <Space>d :NERDTreeToggle<cr>
nmap <Space>D :NERDTreeFind<cr>

Bundle 'https://github.com/scrooloose/nerdcommenter'
" Use Control-/ to toggle comments
map <C-/> <plug>NERDCommenterToggle<CR>
" And Command-/ works on the Mac
map <D-/> <plug>NERDCommenterToggle<CR>
" And C-/ produces C-_ on most terminals
map <C-_> <plug>NERDCommenterToggle<CR>

Bundle 'https://github.com/tpope/vim-surround'
" tell surround not to break the visual s keystroke (:help vs)
xmap S <Plug>Vsurround

Bundle 'https://github.com/majutsushi/tagbar'
nmap <Space>l :TagbarToggle<cr>

Bundle 'https://github.com/vim-scripts/bufexplorer.zip'
nmap <Space>b :BufExplorer<cr>

Bundle 'git://git.wincent.com/command-t.git'
" ensure we compile with the system ruby if rvm is installed
BundleCommand 'if which rvm >/dev/null 2>&1; then rvm system exec rake make; else rake make; fi'
nmap <silent> <C-Space> :CommandT<CR>
nmap <silent> <C-@> :CommandT<CR>
" let g:CommandTCancelMap = ['<C-c>', '<Esc>', '<C-Space>', '<C-@>']
" let g:CommandTSelectPrevMap = ['<C-p>', '<C-k>', '<Up>', '<ESC>OA']
" let g:CommandTSelectNextMap = ['<C-n>', '<C-j>', '<Down>', '<ESC>OB']
let g:CommandTMatchWindowAtTop = 1

Bundle 'https://github.com/bronson/vim-closebuffer'
Bundle 'https://github.com/vim-ruby/vim-ruby'
Bundle 'https://github.com/tpope/vim-rails'
Bundle 'https://github.com/tpope/vim-rake'
Bundle 'https://github.com/vim-scripts/a.vim'
Bundle 'https://github.com/msanders/snipmate.vim'
Bundle 'https://github.com/scrooloose/snipmate-snippets'
Bundle 'https://github.com/vim-scripts/IndexedSearch'
Bundle 'https://github.com/bronson/vim-runtest'
"
"    text objects    :he text-objects
" TODO: rewrite ruby-block-conv to use textobj-rubyblock
Bundle 'https://github.com/bronson/vim-ruby-block-conv'
Bundle 'https://github.com/kana/vim-textobj-user'
" Ruby text objects: ar, ir
Bundle 'https://github.com/nelstrom/vim-textobj-rubyblock'
" Paramter text objects (between parens and commas): aP, iP
Bundle 'https://github.com/vim-scripts/Parameter-Text-Objects'
" indent text objects: ai, ii, (include line below) aI, iI
"   ai,ii work best for Python, aI,II work best for Ruby/C/Perl
Bundle 'https://github.com/michaeljsmith/vim-indent-object'

Bundle 'https://github.com/godlygeek/tabular'

Bundle 'https://github.com/tpope/vim-endwise'
Bundle 'https://github.com/tpope/vim-repeat'

Bundle 'https://github.com/tpope/vim-fugitive'
" TODO: this prompt seems to cause huge delays with big repos on MacOS X
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

Bundle 'https://github.com/ervandew/supertab'

Bundle 'https://github.com/bronson/vim-visual-star-search'
Bundle 'https://github.com/bronson/vim-trailing-whitespace'
Bundle 'https://github.com/bronson/vim-toggle-wrap'

Bundle 'https://github.com/Raimondi/YAIFA'
" verbosity=1 allows you to check YAIFA's results by running :messages
let g:yaifa_verbosity = 0

Bundle 'https://github.com/vim-scripts/AutoTag'
Bundle 'https://github.com/bronson/hammer.vim'
let g:HammerQuiet = 1 " otherwise hammer complains about missing github-markup gem


" The Ruby debugger is fairly painful, enable only when you need it
"" The Ruby debugger only works in mvim!  It won't work in a terminal.
" Bundle 'https://github.com/astashov/vim-ruby-debugger'
"" let g:ruby_debugger_debug_mode = 1
"let g:ruby_debugger_progname = 'mvim'   " TODO: how to autodetect this?
"" Use Eclipse-like keystrokes: F5=step, F6=next, F7=return
"" If on a Mac you must hit Fn-F5 or switch "Use all F1..." in Keyboard control panel.
"" Also, the Mac seems to eat most Control-Fkeys so use Shift-Fkey as a synonym.
"noremap <F5>    :call g:RubyDebugger.step()<CR>
"noremap C-<F5>  :call g:RubyDebugger.continue()<CR>
"noremap S-<F5>  :call g:RubyDebugger.continue()<CR>
"noremap <F6>    :call g:RubyDebugger.next()<CR>
"noremap C-<F6>  :call g:RubyDebugger.continue()<CR>
"noremap S-<F6>  :call g:RubyDebugger.continue()<CR>
"noremap <F7>    :call g:RubyDebugger.finish()<CR>
"noremap C-<F7>  :call g:RubyDebugger.exit()<CR>
"noremap S-<F7>  :call g:RubyDebugger.exit()<CR>


" Syntax Files:
Bundle 'https://github.com/pangloss/vim-javascript'
Bundle 'https://github.com/vim-scripts/jQuery'
Bundle 'https://github.com/tsaleh/vim-shoulda'
Bundle 'https://github.com/tpope/vim-git'
Bundle 'https://github.com/tpope/vim-cucumber'
Bundle 'https://github.com/tpope/vim-haml'
" TODO: should move back to hallison or plasticboy markdown when they pick up new changes
Bundle 'https://github.com/gmarik/vim-markdown'
Bundle 'https://github.com/timcharper/textile.vim'
Bundle 'https://github.com/kchmck/vim-coffee-script'
Bundle 'https://github.com/ajf/puppet-vim'
Bundle 'https://github.com/bdd/vim-scala'
Bundle 'https://github.com/bbommarito/vim-slim'

" Color Schemes:
Bundle 'https://github.com/tpope/vim-vividchalk'
Bundle 'https://github.com/wgibbs/vim-irblack'
Bundle 'https://github.com/altercation/vim-colors-solarized'

" TODO: Bundle: https://github.com/hallettj/jslint.vim
" TODO: Bundle: https://github.com/ecomba/vim-ruby-refactoring
" TODO: Bundle: https://github.com/scrooloose/syntastic
" TODO: Bundle: https://github.com/int3/vim-extradite
" TODO: Bundle: https://github.com/rson/vim-conque
" TODO: the only decent gdb frontend looks to be pyclewn?
