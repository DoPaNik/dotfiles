#!/usr/bin/env bash
# Oh My Zsh, Starship and the zsh dotfiles

section "Shell"

# ~/.dotfiles always points at this checkout, wherever it lives
if [ "$DOTFILES_DIR" = "$HOME/.dotfiles" ]; then
  unchanged "repo is ~/.dotfiles"
else
  link_file "$DOTFILES_DIR" "$HOME/.dotfiles"
fi

if [ -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
  unchanged "Oh My Zsh"
else
  # --unattended: no shell switch, no prompt; --keep-zshrc: we link our own
  run env RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended --keep-zshrc
  changed "Oh My Zsh installed"
fi

link_file "$DOTFILES_DIR/home/.zprofile" "$HOME/.zprofile"
link_file "$DOTFILES_DIR/home/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/home/.config/starship.toml" "$HOME/.config/starship.toml"

has starship || warn "starship not installed yet (packages step)"

if [ "$(dscl . -read "$HOME" UserShell | awk '{print $2}')" = /bin/zsh ]; then
  unchanged "login shell /bin/zsh"
else
  run chsh -s /bin/zsh
  changed "login shell set to /bin/zsh"
fi
