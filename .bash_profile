[[ $- == *i* ]] && [ -f ~/.bashrc ] && source ~/.bashrc

[ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

# Added by Nix installer
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi
