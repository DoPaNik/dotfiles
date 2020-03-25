#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Install "Oh My Zsh"
if test ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh"; then
  sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install Zsh-Syntay-Hightligting Custom Plugin
if test ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

# # Link Dotfiles to my $HOME
DOTFILES="$HOME/.dotfiles"
if [ ! \( -d "$DOTFILES" \) ];
then
  echo "Creating symlink $DOTFILES -> $PWD  "
  ln -s $PWD $DOTFILES 
fi

# # Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
ZSHRC="$HOME/.zshrc"
if [ -e "$ZSHRC" ];
then
  if [ -f "$ZSHRC" ];
  then
    echo "Deleting $ZSHRC ..."
    rm -f $ZSHRC
  else
    echo "Unlinking $ZSHRC ..."
    unlink $ZSHRC
  fi
else
  echo "$ZSHRC not found"
fi
echo "Creating symlink $ZSHRC -> $HOME/.dotfiles/.zshrc"
ln -s $HOME/.dotfiles/.zshrc $ZSHRC

# # Removes .mackup.cfg from $HOME (if it exists) and symlinks the Mackup config file to the home directory
MACKUPCFG="$HOME/.mackup.cfg"
if [ -e "$MACKUPCFG" ];
then
  if [ -f "$MACKUPCFG" ];
  then
    echo "Deleting $MACKUPCFG ..."
    rm -f $MACKUPCFG
  else
    echo "Unlinking $ZSHRC ..."
    unlink $MACKUPCFG
  fi
else
  echo "$MACKUPCFG not found"
fi
echo "Creating symlink $MACKUPCFG -> $HOME/.dotfiles/.mackup.cfg"
ln -s $HOME/.dotfiles/.mackup.cfg $MACKUPCFG

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos