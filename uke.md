cd ~/dotfiles/uke/bin

# Beispiel für alle uke-* Binaries
for f in uke-*; do
  xattr -r -d com.apple.quarantine "$f"
done

for f in uke-*; do
  spctl --add "$PWD/$f"
done

