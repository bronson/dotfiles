" vimsy's .vimrc
"
" Don't use abbreviations!  Spelling things out makes grepping easy.
" After installing this .vimrc, run vim-update-bundles to install the
" plugins: https://github.com/bronson/vim-update-bundles


set nocompatible
filetype on   " work around stupid osx bug
filetype off


" Use Vundle to manage runtime paths
"set rtp+=~/.vim/bundle/vundle/
"call vundle#rc()
" Tell Vim to ignore BundleCommand until vundle supports it
"com! -nargs=? BundleCommand
"Bundle 'https://github.com/gmarik/vundle'


" stub out Vundle directives because we're using Pathogen
com! -nargs=? Bundle
com! -nargs=? BundleCommand
" or use Pathogen to manage runtime paths
Bundle 'tpope/vim-pathogen'
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()


filetype indent plugin on
syntax on


call yankstack#setup() " need to call before defining any yank/paste keybindings

set encoding=utf-8 fileencodings= " use utf8 by default
set showcmd           " show incomplete cmds down the bottom
set showmode          " show current mode down the bottom
set report=0          " always report # of lines changed

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
set wildignore=*.o,*.obj,*/tmp/*,*.so,*~ "stuff to ignore when tab completing

set backspace=indent,eol,start "allow backspacing over everything in insert mode
set history=1000               "store lots of :cmdline history

set hidden          " allow buffers to go into the background without needing to save

let g:is_posix = 1  " vim's default is archaic bourne shell, bring it up to the 90s.

set visualbell      " don't beep constantly, it's annoying.
set t_vb=           " and don't flash the screen either (terminal anyway...
set guioptions-=T   " hide gvim's toolbar by default
" see .gvimrc for font settings

" search for a tags file recursively from cwd to /
set tags=.tags,tags;/

" Store swapfiles in a single directory.
set directory=~/.vim/swap,~/tmp,/var/tmp/,tmp

set number


" indenting, languages

set expandtab         " use spaces instead of tabstops
set smarttab          " use shiftwidth when hitting tab instead of sts (?)
set autoindent        " try to put the right amount of space at the beginning of a new line
set shiftwidth=2
set softtabstop=2
set splitbelow        " when splitting, cursor should stay in bottom window

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


" if you :e a file whose parent directories don't exist, run ":mk."
" HM, I don't like this.  makes /m wait forever before returning results.
" http://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
" cnoremap mk. !mkdir -p <c-r>=expand("%:h")<cr>/
command! Mk execute "!mkdir -p " . shellescape(expand('%:h'), 1)


" Vim "Mistakes":

" make ' jump to saved line & column rather than just line.
" http://items.sjbach.com/319/configuring-vim-right
nnoremap ' `
nnoremap ` '
" make Y yank to the end of the line (like C and D).  Use yy to yank the entire line.
nmap Y y$

" don't complain on some obvious fat-fingers
nmap :W :w
nmap :W! :w!
nmap :Q :q
nmap :Q! :q!
nmap :Qa :qa
nmap :Wq! :wq!
nmap :WQ! :wq!


" Make the quickfix window wrap no matter the setting of nowrap
autocmd BufWinEnter * if &buftype == 'quickfix' | setl wrap | endif
" 'q' inside quickfix window closes it (like nerdtree, bufexplorer, etc)
autocmd BufWinEnter * if &buftype == 'quickfix' | map q :cclose<CR> | endif
" quicker to navigate the quickfix window, just control-n, control-p
nmap <silent> <D-n> :cn<CR>
nmap <silent> <D-p> :cp<CR>



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


" highlight rspec keywords properly
" modified from tpope and technicalpickles: https://gist.github.com/64635
autocmd BufRead *_spec.rb syn keyword rubyRspec describe context it specify it_should_behave_like before after setup subject its shared_examples_for shared_context let
highlight def link rubyRspec Function


" if no files specified, or a directory is specified, start with netrw showing
autocmd VimEnter * if !argc() | Explore | endif
autocmd VimEnter * if isdirectory(expand('<afile>')) | Explore | endif

nmap <Space>e :Explore .<cr>
nmap <Space>E :edit .<cr>



"
"          Plugins
"

runtime macros/matchit.vim  " enable vim's built-in matchit script (make % bounce between tags, begin/end, etc)


" Text Manipulation:

Bundle 'https://github.com/tpope/vim-commentary'
xmap <C-/> <Plug>Commentary
xmap <D-/> <Plug>Commentary
xmap <C-_> <Plug>Commentary
nmap <C-/> <Plug>CommentaryLine
nmap <D-/> <Plug>CommentaryLine
nmap <C-_> <Plug>CommentaryLine

Bundle 'https://github.com/tpope/vim-surround'
Bundle 'https://github.com/tpope/vim-endwise'

" Bundle 'https://github.com/Valloric/YouCompleteMe'
" Bundle 'https://github.com/SirVer/ultisnips'
" Bundle 'https://github.com/honza/vim-snippets'
" " this kinda sucks (YCM should just allow return) but oh well
" let g:UltiSnipsExpandTrigger = "<c-j>"
" let g:UltiSnipsJumpForwardTrigger = "<c-j>"
" let g:UltiSnipsJumpBackwardTrigger = "<c-k>"


" Navigation And Searching:

Bundle 'https://github.com/kien/ctrlp.vim'
" except caching continually gets completions wrong, even when I hit F5
let g:ctrlp_use_caching = 0
" let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_match_window = 'min:4,max:72'
" use ag to generate ctrlp list since it obeys .gitignore
let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
nmap <Space>b :CtrlPBuffer<cr>


Bundle 'https://github.com/rking/ag.vim'
set grepprg=ag\ --nogroup\ --nocolor
" hit K to do a recursive grep of the word under the cursor (probably no need, \* will do it better?)
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>

Bundle 'https://github.com/tpope/vim-unimpaired'
Bundle 'https://github.com/vim-scripts/a.vim'

Bundle 'https://github.com/majutsushi/tagbar'
nmap <Space>l :TagbarToggle<cr>

Bundle 'https://github.com/bronson/vim-visual-star-search'


" Utilities:

Bundle 'https://github.com/tpope/vim-fugitive'
" make :gs and :Gs pull up git status
cabbrev <expr> gs ((getcmdtype() == ':' && getcmdpos() <= 3) ? 'Gstatus' : 'gs')
command! Gs Gstatus

" NO Bundle 'https://github.com/airblade/vim-gitgutter'
" highlight link GitGutterAdd DiffAdd
" highlight link GitGutterChange DiffChange
" highlight link GitGutterDelete DiffDelete

Bundle 'https://github.com/tpope/vim-vinegar'

Bundle 'https://github.com/bronson/vim-closebuffer'
Bundle 'https://github.com/vim-ruby/vim-ruby'
Bundle 'https://github.com/tpope/vim-rails'
Bundle 'https://github.com/tpope/vim-bundler'
Bundle 'https://github.com/tpope/vim-rake'

Bundle 'https://github.com/vim-scripts/IndexedSearch'
Bundle 'https://github.com/maxbrunsfeld/vim-yankstack'
let g:yankstack_map_keys = 0
nmap <Space>p <Plug>yankstack_substitute_older_paste
nmap <Space>P <Plug>yankstack_substitute_newer_paste

Bundle 'https://github.com/sjl/gundo.vim'
Bundle 'https://github.com/tpope/vim-repeat'

" TODO: would I rather use https://github.com/tpope/vim-sleuth ?
Bundle 'https://github.com/Raimondi/YAIFA'
" verbosity=1 allows you to check YAIFA's results by running :messages
let g:yaifa_verbosity = 0

" Bundle: https://github.com/scrooloose/syntastic
let g:syntastic_check_on_open=1
let g:syntastic_html_tidy_ignore_errors=[" proprietary attribute \"ng-"]
"
" TODO: can vim-unimpaired replace this plugin?
Bundle 'https://github.com/bronson/vim-toggle-wrap'


" Text Objects:

" TODO: rewrite ruby-block-conv to use textobj-rubyblock
Bundle 'https://github.com/bronson/vim-ruby-block-conv'
Bundle 'https://github.com/glts/vim-textobj-comment'
Bundle 'https://github.com/kana/vim-textobj-user'
" Ruby text objects: ar, ir
Bundle 'https://github.com/nelstrom/vim-textobj-rubyblock'
" Paramter text objects (between parens and commas): a, / i,
Bundle 'https://github.com/sgur/vim-textobj-parameter'
" indent text objects: ai, ii, (include line below) aI, iI
"   ai,ii work best for Python, aI,II work best for Ruby/C/Perl
Bundle 'https://github.com/michaeljsmith/vim-indent-object'
" ay,iy for the currently syntax highlighted item
Bundle 'https://github.com/kana/vim-textobj-syntax'
" av,iv for the variable segment (between _ or camelCase)
Bundle 'https://github.com/Julian/vim-textobj-variable-segment'
" au,iu for a url   # TODO: make 'go' work on visual mode, and also on the mac, maybe use xolox/vim-misc
Bundle 'https://github.com/jceb/vim-textobj-uri'


" Syntax Files:

Bundle 'https://github.com/bronson/Arduino-syntax-file'
Bundle 'https://github.com/pangloss/vim-javascript'
Bundle 'https://github.com/vim-scripts/jQuery'
Bundle 'https://github.com/tpope/vim-git'
Bundle 'https://github.com/plasticboy/vim-markdown'
let g:vim_markdown_folding_disabled=1
Bundle 'https://github.com/kchmck/vim-coffee-script'
Bundle 'https://github.com/AndrewRadev/vim-eco'
Bundle 'https://github.com/ajf/puppet-vim'
Bundle 'https://github.com/groenewege/vim-less'
Bundle 'https://github.com/slim-template/vim-slim'


" Appearance:

Bundle 'https://github.com/bling/vim-airline'
Bundle 'https://github.com/bronson/vim-crosshairs'
Bundle 'https://github.com/bronson/vim-trailing-whitespace'


" Color Schemes:

Bundle 'https://github.com/tpope/vim-vividchalk'
Bundle 'https://github.com/wgibbs/vim-irblack'
Bundle 'https://github.com/altercation/vim-colors-solarized'
Bundle 'https://github.com/cespare/zenburn'
Bundle 'https://github.com/jgdavey/vim-railscasts'
Bundle 'https://github.com/vim-scripts/twilight'
Bundle 'https://github.com/vim-scripts/Guardian'
Bundle 'https://github.com/chriskempson/base16-vim'
Bundle 'https://github.com/chriskempson/vim-tomorrow-theme'
Bundle 'https://github.com/croaky/vim-colors-github'



" TODO: a path textobject?  vi/, va/
" TODO: Bundle: https://github.com/hallettj/jslint.vim
" TODO: Bundle: https://github.com/ecomba/vim-ruby-refactoring
" TODO: Bundle: https://github.com/int3/vim-extradite
" TODO: Bundle: https://github.com/rson/vim-conque
" TODO: the only decent gdb frontend looks to be pyclewn?
" TODO: another bufclose, how did I not find this?  https://github.com/vim-scripts/BufClose.vim
"
" Can I throw a visual select around the most recent paste?
" Is this something yankstack can do?


" from https://github.com/nelstrom/dotfiles/blob/448f710b855970a8565388c6665a96ddf4976f9f/vimrc
command! Path :call EchoPath()
function! EchoPath()
  echo join(split(&path, ","), "\n")
endfunction

command! TagFiles :call EchoTags()
function! EchoTags()
  echo join(split(&tags, ","), "\n")
endfunction



" Random Personal Stuff:
" hitting :MP will make and program the firmware
command! MP make program
command! MPA make program DEBUGGING=always
command! MPP make program ENVIRONMENT=production


" some goddamn plugin is messing this up?
set textwidth=0
