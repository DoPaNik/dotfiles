#!/usr/bin/env bash
# Install Homebrew if missing

section "Homebrew"

if [ -x /opt/homebrew/bin/brew ]; then
  unchanged "Homebrew $(brew --version | head -1 | awk '{print $2}')"
else
  info "Installing Homebrew (asks for your password)"
  run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  [ "$DRY_RUN" = 1 ] || eval "$(/opt/homebrew/bin/brew shellenv)"
  changed "Homebrew installed"
fi
