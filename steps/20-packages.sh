#!/usr/bin/env bash
# Install formulae, casks and fonts from the Brewfile

section "Packages (Brewfile)"

if ! has brew; then
  skipped "brew not available (run the homebrew step first)"
  return 0
fi

BREWFILE="$DOTFILES_DIR/Brewfile"

# Homebrew only loads formulae from third-party taps that are trusted
trusted=$(brew trust --json=v1 2>/dev/null || true)
# shellcheck disable=SC2013 # tap names contain no spaces
for tap in $(sed -n "s/^tap '\([^']*\)'.*/\1/p" "$BREWFILE"); do
  if printf '%s' "$trusted" | grep -q "\"$tap\""; then
    unchanged "trusted tap $tap"
  else
    run brew trust --tap "$tap"
    changed "trusted tap $tap"
  fi
done
unset trusted tap

if brew bundle check --file="$BREWFILE" --no-upgrade >/dev/null 2>&1; then
  unchanged "all Brewfile entries installed"
else
  missing=$(brew bundle check --file="$BREWFILE" --no-upgrade --verbose 2>&1 | sed -n 's/^→ //p' || true)
  info "missing entries:"
  printf '%s\n' "$missing" | sed 's/^/      /'

  # Apps installed by hand get adopted. macOS only allows that when the
  # terminal has the "App Management" permission (no way to test it upfront).
  adopt=$(printf '%s\n' "$missing" | sed -n 's/^Cask \([^ ]*\) needs to be installed.*/\1/p')
  if [ -n "$adopt" ]; then
    # shellcheck disable=SC2086 # split the list of cask tokens
    adopt=$(brew info --json=v2 --cask $adopt 2>/dev/null | jq -r '.casks[]
      | [.artifacts[] | select(type == "object" and has("app")) | .app[]
         | if type == "string" then . else .target end][]' 2>/dev/null \
      | while IFS= read -r app; do [ -d "/Applications/$app" ] && echo "$app"; done || true)
  fi
  if [ -n "$adopt" ]; then
    warn "these apps exist already and will be adopted by Homebrew:"
    printf '%s\n' "$adopt" | sed 's/^/      /' >&2
    warn "this needs System Settings > Privacy & Security > App Management for the terminal,"
    warn "otherwise they fail with 'chgrp: Operation not permitted' (the apps stay untouched)."
  fi
  unset missing adopt
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
