[[ $- == *i* ]] && [ -f ~/.bashrc ] && source ~/.bashrc

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# added by Anaconda3 5.0.0 installer
export PATH="/Users/bronson/anaconda3/bin:$PATH"

# Added by Nix installer
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
