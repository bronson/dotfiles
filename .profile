# if we're running bash then run .bashrc
if [ -n "$BASH_VERSION" ]; then
    [ -f ~/.bashrc ] && source ~/.bashrc
fi
[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"
