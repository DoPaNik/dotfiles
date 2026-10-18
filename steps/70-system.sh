#!/usr/bin/env bash
# System-wide macOS settings (sudo), see macos/system.sh

section "System settings (sudo)"

require_sudo
# shellcheck source=../macos/system.sh
. "$DOTFILES_DIR/macos/system.sh"
