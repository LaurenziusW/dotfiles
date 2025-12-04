cd ~/dotfiles/uke/bin

for f in uke-*; do
  xattr -r -d com.apple.quarantine "$f"
done

xattr -d com.apple.quarantine ~/dotfiles/uke/bin/*


# Reclaim ownership of your dotfiles and state directories
sudo chown -R $(whoami) ~/dotfiles/uke ~/.local/state/uke ~/.config/skhd ~/.config/yabai ~/.config/hypr ~/.local/bin/uke*

# Remove existing zsh configs (stow will replace them)
rm -f ~/.zshrc ~/.zprofile

# Manually link the zsh config (NO SUDO!)
cd ~/dotfiles/uke/stow
stow -R -t ~ zsh

# Clear the quarantine attribute
xattr -d com.apple.quarantine ~/dotfiles/uke/bin/* 2>/dev/null || true