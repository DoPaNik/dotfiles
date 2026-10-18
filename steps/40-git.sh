#!/usr/bin/env bash
# Git configuration (identity lives in ~/.gitconfig.local)

section "Git"

link_file "$DOTFILES_DIR/home/.gitconfig" "$HOME/.gitconfig"
link_file "$DOTFILES_DIR/home/.config/git/ignore" "$HOME/.config/git/ignore"

if [ -f "$HOME/.gitconfig.local" ]; then
  unchanged "$HOME/.gitconfig.local"
else
  skipped "$HOME/.gitconfig.local missing, create it with your identity:"
  info "  git config --file ~/.gitconfig.local user.name  \"Your Name\""
  info "  git config --file ~/.gitconfig.local user.email \"you@example.com\""
fi

# Optional identity for repos below ~/Documents/business/DOPAmin/ (see includeIf)
if [ -f "$HOME/.gitconfig.dopamin" ]; then
  unchanged "$HOME/.gitconfig.dopamin"
else
  skipped "$HOME/.gitconfig.dopamin missing, DOPAmin repos use the default identity"
  info "  git config --file ~/.gitconfig.dopamin user.email \"you@dopamin.example\""
fi
