# This file sets up a quality Bash environment both on Linux and OSX.

# TODO: something in here screws up filename completion, i.e. "30 for 30"
# TODO: sort out what should be in .profile and what should be in .bashrc
#       bash manpage, in the INVOCATION section
# TODO: set a timeout on the prompt git stuff, it can take forever on macosx

alias dotgit="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"
complete -o default -o nospace -F _git dotgit



#
#     Environment
#

# my home dir is behind a symlink, sometimes bash doesn't recognize this.
# force the prompt to show the home dir when you're home.
[ "$PWD" != "$HOME" ] && [ "$PWD" -ef "$HOME" ] && cd

export LESS="--RAW-CONTROL-CHARS"    # interpret any embedded ansi escapes
export PAGER='less'                  # use less to view manpages, etc
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)" # let less show non-text files too
export PS1="\\u@\h \\w\\$ "          # simple prompt shows user, host and path
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/Dropbox/bin" ] && export PATH="$HOME/Dropbox/bin:$PATH"

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

export GREP_OPTIONS='--color=auto --exclude=tags --exclude=TAGS --exclude-dir=.git --exclude-dir=.svn --exclude-dir=log --exclude=*.min.js'



#
#     History
#

shopt -s histappend                         # Append to history file instead of overwriting
shopt -s cmdhist                            # store multiline commands as 1 line
shopt -s checkwinsize                       # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
export HISTCONTROL="ignoreboth"             # store duplicate lines once, ignore lines beginning with a space
export HISTIGNORE="&:ls:[bf]g:exit:%[0-9]"  # ignore simple commands
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

alias gre=grep    # darn you vim's :gre command
alias tf='tail -f'


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
    alias $1="git $2 $3"
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
__git_shortcut  gf    fetch
__git_shortcut  gl    log
__git_shortcut  glp   log -p
__git_shortcut  gls   log --stat
alias gs='git status -sb' # no completion for git status



alias jk='jekyll --auto --server'

if [ -f /bin/vi ] && [ -f /usr/bin/vim ]; then
  # Fedora 14 is friggin weird: can't use /bin/vi and can't remove it either
  alias vi=/usr/bin/vim
fi

# calculator: "? 3+13*3" will print 42
? () { echo "$*" | bc -l; }


#
#     OSX Hacks
#

if [ "Darwin" == "$(uname)" ]; then

    export LSCOLORS="ExGxBxDxCxEgEdxbxgxcxd"
    export CLICOLOR=true


    export BREW_HOME=/usr/local                          # recommended location

    export PATH="$BREW_HOME/sbin/:$PATH"                 # brew
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"   # macports
    export PATH="$PATH:/usr/local/mysql/bin"             # default osx mysql dmg


    # if newer bash is installed by brew or ports, use its completion
    [ -f /opt/local/etc/bash_completion ] && source /opt/local/etc/bash_completion
    [ -f $BREW_HOME/etc/bash_completion ] && source $BREW_HOME/etc/bash_completion

    alias vi=/Applications/MacVim.app/Contents/MacOS/Vim
    alias vim=/Applications/MacVim.app/Contents/MacOS/Vim
    alias gvim=mvim

fi



#
#     Completion
#

# Install the bash-completion package on MacOS X using port or brew.
if [ -f /opt/local/etc/bash_completion ]; then
  source /opt/local/etc/bash_completion
elif [ -n "$BREW_HOME" ] && [ -f "$BREW_HOME/etc/bash_completion" ]; then
  source "$BREW_HOME/etc/bash_completion"
elif [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi

# For some reason macports git doesn't install its completion file.
if [ -f /opt/local/share/doc/git-core/contrib/completion/git-completion.bash ]; then
  source /opt/local/share/doc/git-core/contrib/completion/git-completion.bash
fi



#
#     Rails
#

. ~/.bash-rails
alias Rails=rails   # darn you Rails.vim
complete -o default -o nospace -F _rails Rails
alias r=rails
complete -o default -o nospace -F _rails r


#
#     node.js
#

[ -d ~/.nvm ] && . ~/.nvm/nvm.sh
which npm >/dev/null 2>&1 && . <(npm completion | cat)  # https://github.com/isaacs/npm/issues/1066
export PATH="node_modules/.bin:$PATH"

#
#     Ruby
#

# load rvm if it's available
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -r $rvm_path/scripts/completion ]] && . $rvm_path/scripts/completion

alias gemset='rvm gemset'
complete -o default -o nospace -F _rvm gemset

# Bundler can be a right pain at times
alias be='bundle exec'



#
#     Vim
#

export EDITOR='vim'
# use gvim instead of terminal vim to edit bundles
export GEM_EDITOR=gvim BUNDLER_EDITOR=gvim


#
#     Private Customizations
#

[ -f ~/.bashrc-private ] && . ~/.bashrc-private

