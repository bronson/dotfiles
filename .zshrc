# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
#
# git clone https://github.com/subnixr/minimal .minimal

# .f stands for dotfiles.  .f diff, .f log, .f pull, etc.
alias .f="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"

# for homebrew
export PATH="/usr/local/sbin:$PATH"

# aliases I like
alias sl=ls
dus() { du -hs "$@" | sort -rh; }

# I'm in zsh but the git completions are way worse than my old bash!
alias gs='git status -sb'
alias gl='git log'
alias glp='git log -p'
alias gls=glg
alias gpl='git pull'

# calculator: "? 3+13*3" will print 42
# TODO: can I store bc's output in a shell variable?
function '?' { echo "$@" | bc -l; }
alias '?'='noglob ?'


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

plugin https://github.com/subnixr/minimal
plugin https://github.com/zsh-users/zsh-autosuggestions

unset -f plugin


# allow abbyy to ocr this file
alias snapify='exiftool -creator="ScanSnap Manager #iX500"'

