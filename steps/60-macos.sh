#!/usr/bin/env bash
# macOS user settings (no sudo), see macos/*.sh

section "macOS settings"

# Quit System Settings so it does not overwrite what we change
[ "$DRY_RUN" = 1 ] || osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

for f in "$DOTFILES_DIR"/macos/user-*.sh; do
  info "${C_DIM}$(basename "$f")${C_RESET}"
  # shellcheck source=/dev/null
  . "$f"
done

restart_apps
