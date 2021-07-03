echo "link..."
for dotfile in $(git ls-files); do
  mkdir "$HOME/$(dirname $dotfile)"
  ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
done
echo "done"

exit 1

echo "ssh..."
if [ -e "$HOME/.ssh/id_ed25519" ]; then
  echo "already done"
else
  ssh-keygen -t ed25519 -C "mba-m1-2020"
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "Public key is stored in clipboard"
  echo "https://github.com/settings/ssh/new"
  read -p "Hit enter: "
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
  echo "done"
fi

echo "zsh..."
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
chsh -s /bin/zsh
echo "done"

echo "xcode..."
sudo xcodebuild -license accept
xcode-select --install
echo "done"

echo "brew..."
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "done"

echo "packages..."
# neovim
brew install nvim nodenv
# fira-code font
brew tap homebrew/cask-fonts
brew install --cask font-fira-code
# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo "done"

echo "macosx..."
# キー長押しでのキーリピートを有効化
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
echo "done"

exec $SHELL -l
