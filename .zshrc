# .f stands for dotfiles.  .f diff, .f log, .f pull, etc.
alias .f="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"

# for homebrew
export PATH="/usr/local/sbin:$PATH"

# aliases I like
alias sl=ls
dus() { du -hs "$@" | sort -rh; }

# I'm in zsh but the git completions are way worse than my old bash!
alias gb='git branch'
alias gcia='git cia'
alias gco='git co'
alias gd='git diff'
alias gdc='git diff --cached'
alias gl='git log'
alias glp='git log -p'
alias gls='git log --stat'
alias gs='git status -sb'

# calculator: "? 3+13*3" will print 42
# TODO: can I store bc's output in a shell variable?
function '?' { echo "$@" | bc -l; }
alias '?'='noglob ?'

# use built-in zsh completion
autoload -Uz compinit && compinit

# cd into dirs by typing the name, (including .. to go up)
setopt AUTO_CD

# only complete the unambiguous part; don't complete the entire first file/dir.
unsetopt menu_complete

# give me a giant, always up-to-date history file
HISTSIZE=2000 # maximum lines remembered in a session
SAVEHIST=9000 # maximum lines in the history file
setopt SHARE_HISTORY       # share history across multiple zsh sessions
setopt APPEND_HISTORY      # append to history
setopt INC_APPEND_HISTORY  # adds commands as they are typed, not at shell exit
setopt HIST_EXPIRE_DUPS_FIRST # remove redundant lines first

# start typing a command, then hit up-arrow to search in history
# bindkey '^[[A' up-line-or-search

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

unset -f plugin

# for Visual Studio Code
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

export PATH="$HOME/bin:$PATH"

# allow abbyy to ocr this file
alias snapify='exiftool -creator="ScanSnap Manager #iX500"'
