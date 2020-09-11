# To debug weird interactions, run zsh -df and then source files one-by-one.

# .f stands for dotfiles.  .f diff, .f log, .f pull, etc.
alias .f="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"

# for homebrew
export PATH="/usr/local/sbin:$PATH"

# aliases I like
alias sl=ls
dus() { du -hs "$@" | sort -rh; }

# I'm in zsh but the git completions are way worse than my old bash!
alias gb='git branch'
alias gci='git ci'
alias gcia='git cia'
alias gco='git co'
alias gd='git diff'
alias gdc='git diff --cached'
alias gdw='git diff --word-diff'
alias gd.='git diff --word-diff --word-diff-regex=.'
alias gl='git log'
alias glp='git log -p'
alias gls='git log --stat'
alias gs='git status -sb'

# calculator:
#   `$ ? 3+13*3` will print 42. Stores the result in $x.
#   `$ ? $r/6` then prints 7.
function '?' { x="$(echo "$@" | bc -l)"; echo "$x" }
alias '?'='noglob ?'  # so expressions like `? 1*2` aren't expanded by the shell

# use built-in zsh completion
# holy crap, zsh just completed "rm mardoc/shop/wes<tab>" into "rm mardoc-save/shop/wes.md"
# and then I hit return. Blew away an important file. It is not ok to change what has already been completed!
# hope this fixes it...
setopt noautomenu
setopt nomenucomplete
autoload -Uz compinit && compinit

# give me a giant, always up-to-date history file
HISTSIZE=2000 # maximum lines remembered in a session (memory)
SAVEHIST=9000 # maximum lines in the history file     (disk space)
setopt APPEND_HISTORY      # append to history
setopt INC_APPEND_HISTORY  # adds commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST # remove redundant lines first

export PATH="$HOME/bin:$PATH"

# for Visual Studio Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
export PATH="$PATH:/Applications/VSCodium.app/Contents/Resources/app/bin"


# allow abbyy to ocr this file
alias snapify='exiftool -creator="ScanSnap Manager #iX500"'


# antigen looks pretty heavy. This might suffice for now.
plugin() { 
  url="$1" 
  repo="$(basename $url)"
  if [ ! -d "$HOME/.$repo" ]; then
    echo "Missing zsh plugin. Plese run: git clone $url ~/.$repo"
  else
    source "$HOME/.$repo/$repo.zsh"
  fi
}

# Turn off minimal because it breaks zsh-autosuggestions
# (the suggestions remain visible on the command line, even if they weren't used)
# Make hitting return just show another prompt
# MNML_MAGICENTER=
# plugin https://github.com/subnixr/minimal
plugin https://github.com/zsh-users/zsh-autosuggestions
plugin https://github.com/zsh-users/zsh-syntax-highlighting
plugin https://github.com/zsh-users/zsh-history-substring-search

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

unset -f plugin

[ -f ~/.secret-aliases ] && . ~/.secret-aliases
