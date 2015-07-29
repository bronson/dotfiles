# This file sets up a quality Bash environment both on Linux and OSX.

# TODO: something in here screws up filename completion, i.e. "30 for 30"
# TODO: sort out what should be in .profile and what should be in .bashrc
#       bash manpage, in the INVOCATION section
# TODO: set a timeout on the prompt git stuff, it can take forever on macosx

# .f stands for dotfiles.  .f diff, .f log, .f pull, etc.
alias .f="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"
complete -o default -o nospace -F _git .f



#
#     Environment
#

# my home dir is behind a symlink, sometimes bash doesn't recognize this.
# force the prompt to show the home dir when you're home.
[ "$PWD" != "$HOME" ] && [ "$PWD" -ef "$HOME" ] && cd

export LESS="--RAW-CONTROL-CHARS"    # interpret any embedded ansi escapes
export PAGER='less'                  # use less to view manpages, etc
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" # let less show non-text files too
export PS1="\\u@\\h \\w\\$ "          # simple prompt shows user, host and path
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/Dropbox/bin" ] && export PATH="$HOME/Dropbox/bin:$PATH"
[ -d "/usr/local/heroku/bin" ] && export PATH="$PATH:/usr/local/heroku/bin"

# Disable annoying ~ expansion
# http://www.linuxquestions.org/questions/linux-software-2/how-to-stop-bash-from-replacing-%7E-with-home-username-643162/#post3162026
_expand() { return 0; }
__expand_tilde_by_ref() { return 0; }

# flush commans to ~/.bash_history immediately and use a git-friendly bash prompt
[ "$PS1" ] && source ~/.bash_prompt
PROMPT_COMMAND="history -a; prompt_function"


#
#     Colors
#

if [ -x /usr/bin/dircolors ]; then
    # use ~/.dircolors if user has specified one
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# --exclude-dir isn't supported on OSX Lion and Brew doesn't make it easy to fix.
#     --exclude-dir=.git --exclude-dir=.svn --exclude-dir=log
export GREP_OPTIONS='--color=auto --exclude=tags --exclude=TAGS --exclude=*.min.js'



#
#     History
#

shopt -s histappend                         # Append to history file instead of overwriting
shopt -s cmdhist                            # store multiline commands as 1 line
shopt -s checkwinsize                       # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
unset HISTFILESIZE                          # keep unlimited history


#
#     Aliases
#

alias ..='cd ..'
alias ...='cd ../..'

alias sl=ls
alias l='ls -CF'
alias la='ls -A'
alias ll='ls -lF'
alias lla='ls -alF'

alias tf='tail -f'
alias gu='bundle exec guard -n false'
alias jk='jekyll --auto --server'
alias gv=gvim
alias gvi=gvim

alias gre=grep    # darn you vim's :gre command
alias mak=make    # and :mak

alias MP='make program' # for avr parts
alias MPA='make program DEBUGGING=always'
alias MPP='make program ENVIRONMENT=production'

# calculator: "? 3+13*3" will print 42
# TODO: any way to store the output in a bash variable?
? () { echo "$*" | bc -l; }


#
#      Git Aliases
#
# How this works: https://github.com/bronson/dotfiles/issues/1

__define_git_completion () {
eval "
    _git_$2_shortcut () {
        COMP_LINE=\"git $2\${COMP_LINE#$1}\"
        let COMP_POINT+=$((4+${#2}-${#1}))
        COMP_WORDS=(git $2 \"\${COMP_WORDS[@]:1}\")
        let COMP_CWORD+=1

        local cur words cword prev
        _get_comp_words_by_ref -n =: cur words cword prev
        _git_$2
    }
"
}

__git_shortcut () {
    type _git_$2_shortcut &>/dev/null || __define_git_completion $1 $2
    local args=${@: 3}
    alias $1="git $2 $args"
    complete -o default -o nospace -F _git_$2_shortcut $1
}

__git_shortcut  ga    add
__git_shortcut  gb    branch
__git_shortcut  gba   branch -a
__git_shortcut  gco   checkout
__git_shortcut  gci   commit -v
__git_shortcut  gcia  commit '-a -v'
__git_shortcut  gd    diff
__git_shortcut  gdc   diff --cached
__git_shortcut  gds   diff --stat
__git_shortcut  gl    log
__git_shortcut  glp   log -p
__git_shortcut  gls   log --stat
alias gs='git status -sb'   # no completion necessary
alias gsa='git stash apply'



if [ "Darwin" == "$(uname)" ]; then

#
#     OSX Hacks
#

    export LSCOLORS="GxGxBxDxCxEgEdxbxgxcxd"
    export CLICOLOR=true


    export BREW_HOME=/usr/local                          # recommended location

    export PATH="$BREW_HOME/bin:/usr/local/sbin:$PATH"                  # brew
    export PATH="$PATH:/usr/local/mysql/bin"             # default osx mysql dmg


    command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/etc/bash_completion" ] && source "$(brew --prefix)/etc/bash_completion"
    command -v brew >/dev/null 2>&1 && [ -f "$(brew --prefix)/etc/bash_completion.d" ] && source "$(brew --prefix)/etc/bash_completion.d"

    alias gvim=mvim

    # I alias gs to git status, no idea why homebrew doesn't allow full name
    alias ghostscript=/usr/local/bin/gs

else

#
#   emulate some things that osx gets right

    alias open=xdg-open
    alias mvim=gvim

fi



#
#     Completion
#

# Install the bash-completion package on MacOS X using port or brew.
#if [ -f /etc/bash_completion ]; then
  #source /etc/bash_completion
#fi
if [ -f /usr/local/etc/bash_completion.d/git-completion.bash ]; then
  source /usr/local/etc/bash_completion.d/git-completion.bash
fi

# For some reason macports git doesn't install its completion file.
if [ -f /opt/local/share/doc/git-core/contrib/completion/git-completion.bash ]; then
  source /opt/local/share/doc/git-core/contrib/completion/git-completion.bash
fi

#
#     node.js
#

[ -d ~/.nvm ] && . ~/.nvm/nvm.sh
export PATH="node_modules/.bin:$HOME/node_modules/.bin:$PATH"

# https://lists.gnu.org/archive/html/bug-bash/2006-01/msg00018.html
# and OMG Yosemite is still using bash 3.2.53??  Bash 4 was 5 years ago.
# which npm >/dev/null 2>&1 && . <(npm completion)
if which npm >/dev/null 2>&1; then 
  npm completion > /tmp/apple-bash-sucks-$$
  . /tmp/apple-bash-sucks-$$
  rm -f /tmp/apple-bash-sucks-$$
fi

# which grunt >/dev/null 2>&1 && . <(grunt --completion=bash)
if which grunt >/dev/null 2>&1; then 
  grunt --completion=bash > /tmp/apple-bash-sucks-$$
  . /tmp/apple-bash-sucks-$$
  rm /tmp/apple-bash-sucks-$$
fi


#
#     Ruby
#

# switching to chruby...
[ -f /usr/local/share/chruby/chruby.sh ]       && source /usr/local/share/chruby/chruby.sh
[ -f /usr/local/share/chruby/auto.sh ]         && source /usr/local/share/chruby/auto.sh
[ -f /usr/local/share/chruby-default-gems.sh ] && source /usr/local/share/chruby-default-gems.sh
# do everything I can think of to make rdoc go away
export RUBY_CONFIGURE_OPTS=--disable-install-doc
ruby-install() { /usr/local/bin/ruby-install "$@" -- --disable-install-rdoc; }

# Bundler can be a right pain at times
alias be='bundle exec'
alias bepre='bundle exec rake assets:precompile'
alias r=rails
alias rg='rails generate'
alias rr='bundle exec rspec'
alias rs='sh -c "rm -rf tmp/cache log/development.log && rails server"'
alias rc='rails console'


#
#     Editors
#

export EDITOR='vim'
# use gvim instead of terminal vim to edit bundles
export GEM_EDITOR=gvim BUNDLER_EDITOR=gvim

export ATOM_REPOS_HOME="$HOME"  # otherwise apm clones to ~/github


#
#     Etc
#

export PGDATA='/usr/local/var/postgres'
export DOCKER_HOST='tcp://127.0.0.1:4243'


#
#     Private Customizations
#

[ -f ~/.bashrc-private ] && . ~/.bashrc-private
