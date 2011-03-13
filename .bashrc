# This file sets up a quality Bash environment both on Linux and OSX.

# TODO: sort out what should be in .profile and what should be in .bashrc
#       bash manpage, in the INVOCATION section
# TODO: set a timeout on the prompt git stuff, it can take forever on macosx

alias dotgit="git --work-tree=$HOME --git-dir=$HOME/.dotfiles.git"



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

[ -f /etc/bash_completion ] && source /etc/bash_completion
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

# Disable annoying ~ expansion
# http://www.linuxquestions.org/questions/linux-software-2/how-to-stop-bash-from-replacing-%7E-with-home-username-643162/#post3162026
_expand() { return 0; }
__expand_tilde_by_ref() { return 0; }

[ "$PS1" ] && source ~/.bash_prompt



#
#     Colors
#

if [ -x /usr/bin/dircolors ]; then
    # use ~/.dircolors if user has specified one
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

export GREP_OPTIONS='--color=auto'



#
#     History
#

shopt -s histappend                         # Append to history file instead of overwriting
shopt -s cmdhist                            # store multiline commands as 1 line
shopt -s cdspell                            # spelling error correction
shopt -s checkwinsize                       # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
export HISTCONTROL="ignoreboth"             # store duplicate lines once, ignore lines beginning with a space
export HISTIGNORE="&:ls:[bf]g:exit:%[0-9]"  # ignore simple commands
export HISTFILESIZE=5000                    # history file size

# this doesn't seem to work, might have to switch to zsh
# export PROMPT_COMMAND="history -n; history -a" # store & reload history every time prompt is displayed, http://briancarper.net/blog/248/


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

alias gre=grep
alias tf='tail -f'

alias ga='git add'
alias gb='git b'
alias gco='git checkout'
alias gci='git commit'
alias gd='git diff'
alias gl='git log'
alias glp='git log -p'
alias gls='git log --stat'
alias gs='git s'

if [ -f /bin/vi ] && [ -f /usr/bin/vim ]; then
  # Fedora 14 is friggin weird: can't use /bin/vi and can't remove it either
  alias vi=/usr/bin/vim
fi

# calculator: "? 10*2+3" will print 23
? () { echo "$*" | bc -l; }



#
#     Completion
#

# This file sets up bash completion on all platforms.  Linux should work out
# of the box but you'll need to 'port install bash-completion' on MacOS X.

[ -f /etc/bash_completion ] && source /etc/bash_completion


# For some reason macports git doesn't install its completion file.
[ -f /opt/local/share/doc/git-core/contrib/completion/git-completion.bash ] && \
  source /opt/local/share/doc/git-core/contrib/completion/git-completion.bash


# if newer bash is installed by brew or ports, use its completion
[ -f /opt/local/etc/bash_completion ] && source /opt/local/etc/bash_completion
[ -f $BREW_HOME/etc/bash_completion ] && source $BREW_HOME/etc/bash_completion

# allow completion to work with .git command too, if completion is loaded
type -t _git > /dev/null && complete -o default -o nospace -F _git "$dotgit_cmd"



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
#     Ruby
#

# load rvm if it's available
[ -s ~/.rvm/scripts/rvm ] && source ~/.rvm/scripts/rvm

# Launch macvim on the mac, otherwise gvim
if [ "$(uname)" = "Darwin" ]; then
  export GEM_EDITOR=mvim BUNDLER_EDITOR=mvim
else
  export GEM_EDITOR=gvim BUNDLER_EDITOR=gvim
fi



#
#     node.js
#

if [ -d ~/.nvm ]; then
  . ~/.nvm/nvm.sh
  # start using the most recent node immediately
  nvm use "$(nvm ls | tail -1 | cut -d ' ' -f 1)" > /dev/null
  # install the npm completion file
  . "$(npm explore npm pwd 2>/dev/null)"/npm-completion.sh
fi


#
#     Vim
#

export EDITOR='vim'

# use vim as the manpage reader too: nicer colors and navigation.
export MANPAGER='sh -c "col -bx | view - -c \":set ft=man noml\" -c \":nmap q :q<CR>\""'
# Sets up the alias to manipulate the dotfiles.
# Needs to run late, after setting up completion.



#
#     Private Customizations
#

[ -f ~/.bashrc-private ] && . ~/.bashrc-private

