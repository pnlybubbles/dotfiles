provision_links() {
  for dotfile in $(git ls-files); do
    mkdir -p "$HOME/$(dirname $dotfile)"
    ln -snfv "$(pwd)/$dotfile" "$HOME/$dotfile"
  done
}

provision_ssh() {
  ssh-keygen -t ed25519 -C "mba-m1-2020"
  pbcopy < ~/.ssh/id_ed25519.pub
  echo "Public key is stored in clipboard"
  echo "https://github.com/settings/ssh/new"
  read -p "Hit enter: "
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/id_ed25519
}

provision_zsh() {
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
  chsh -s /bin/zsh
}

provision_xcode() {
  sudo xcodebuild -license accept
  xcode-select --install
}

provision_brew() {
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
}

provision_packages() {
  # essentials
  brew install nvim nodenv direnv grep gnu-sed
  # fira-code font
  brew tap homebrew/cask-fonts
  brew install --cask font-fira-code
  # rust
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

provision_macosx() {
  # キー長押しでのキーリピートを有効化
  defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
}

link=''

case $1 in
  'link' )
    link='1'
    ;;
  * )
    ;;
esac

echo "link..."
provision_links
echo "done"

if [ ! -z $link ]; then
  exit
fi

echo "ssh..."
if [ -e "$HOME/.ssh/id_ed25519" ]; then
  echo "already done"
else
  provision_ssh
  echo "done"
fi

echo "zsh..."
provision_zsh
echo "done"

echo "xcode..."
provision_xcode
echo "done"

echo "brew..."
provision_brew
echo "done"

echo "packages..."
provision_packages
echo "done"

echo "macosx..."
provision_macosx
echo "done"

exec $SHELL -l
