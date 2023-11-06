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
ZSH_SYNTAX_HIGHLIGHTING_DIR="${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
if [ -d "$ZSH_SYNTAX_HIGHLIGHTING_DIR" ]; then
  if [ -z "$(ls -A $ZSH_SYNTAX_HIGHLIGHTING_DIR)" ]; then
    echo "Empty"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  else
    echo "Not Empty"
    cd $ZSH_SYNTAX_HIGHLIGHTING_DIR && git pull
  fi

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
    echo "Unlinking $MACKUPCFG ..."
    unlink $MACKUPCFG
  fi
else
  echo "$MACKUPCFG not found"
fi
echo "Creating symlink $MACKUPCFG -> $HOME/.dotfiles/.mackup.cfg"
ln -s $HOME/.dotfiles/.mackup.cfg $MACKUPCFG

# Simplify opw agent path
AGENT_DIR="$HOME/.1password"
AGENT="$AGENT_DIR/agent.sock"
if [ ! -L $AGENT ]; then
  mkdir -p $AGENT_DIR
  echo "Creating symlink to 1password agent socket "
  ln -s $HOME/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock $AGENT
fi

#Setup link for Terminal Theme
if [ ! -L "$HOME/init" ]; then
  ln -s $HOME/.dotfiles/init $HOME/init
fi

# Set macOS preferences
# We will run this last because this will reload the shell
#source .macos
