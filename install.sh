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
# ln -s $PWD $HOME/.dotfiles

# # Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
if [ -e "$HOME/.zshrc"] then
  if [ -f "$HOME/.zshrc"] then
    rm -f $HOME/.zshrc
  else 
    unlink $HOME/.zshrc
  fi
fi
# ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

# # Removes .mackup.cfg from $HOME (if it exists) and symlinks the Mackup config file to the home directory
# rm -rf $HOME/.mackup.cfg
# ln -s $HOME/.dotfiles/.mackup.cfg $HOME/.mackup.cfg

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos