#!/usr/bin/env bash
# Install formulae, casks and fonts from the Brewfile

section "Packages (Brewfile)"

if ! has brew; then
  skipped "brew not available (run the homebrew step first)"
  return 0
fi

BREWFILE="$DOTFILES_DIR/Brewfile"

if brew bundle check --file="$BREWFILE" --no-upgrade >/dev/null 2>&1; then
  unchanged "all Brewfile entries installed"
else
  info "missing entries:"
  brew bundle check --file="$BREWFILE" --no-upgrade --verbose 2>&1 | sed -n 's/^→ /      /p' || true
  # --no-upgrade: only install what is missing, updates stay a separate decision
  run brew bundle install --file="$BREWFILE" --no-upgrade
  changed "Brewfile installed"
fi

# Report (never remove) packages that are installed but not in the Brewfile
extra=$(brew bundle cleanup --file="$BREWFILE" 2>/dev/null | grep -vE '^(Would|Run )' || true)
if [ -n "$extra" ]; then
  warn "installed but not in Brewfile (add them or run: brew bundle cleanup --force):"
  printf '%s\n' "$extra" | sed 's/^/      /' >&2
fi
