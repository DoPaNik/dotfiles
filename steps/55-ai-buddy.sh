#!/usr/bin/env bash
# Build and install AI Buddy (desktop avatar for AI usage) from its own repo

section "AI Buddy"

AI_BUDDY_DIR=${AI_BUDDY_DIR:-$HOME/Documents/Github/ai-buddy}
AI_BUDDY_REPO=${AI_BUDDY_REPO:-git@github.com:DoPaNik/ai-buddy.git}
AI_BUDDY_APP="$HOME/Applications/AIBuddy.app"

if [ ! -d "$AI_BUDDY_DIR/.git" ]; then
  if [ "$DRY_RUN" = 1 ]; then
    run git clone "$AI_BUDDY_REPO" "$AI_BUDDY_DIR"
    changed "clone $AI_BUDDY_REPO (build follows on a real run)"
    return 0
  fi
  if git clone --quiet "$AI_BUDDY_REPO" "$AI_BUDDY_DIR"; then
    changed "cloned $AI_BUDDY_REPO"
  else
    skipped "could not clone $AI_BUDDY_REPO (repo missing or no access)"
    return 0
  fi
fi

# The full Xcode is needed; the Command Line Tools alone cannot build apps.
if ! xcodebuild -version >/dev/null 2>&1; then
  skipped "Xcode missing: install it from the App Store, open it once, then run this step again"
  return 0
fi
if ! has xcodegen; then
  skipped "xcodegen not installed yet (packages step)"
  return 0
fi

# `make install` stamps the commit into the app, so only rebuild when it changed.
head=$(git -C "$AI_BUDDY_DIR" rev-parse --short HEAD)
installed=$(plutil -extract AIBuddyCommit raw -o - "$AI_BUDDY_APP/Contents/Info.plist" 2>/dev/null || true)
if [ "$installed" = "$head" ]; then
  unchanged "AI Buddy $head installed"
else
  if [ -n "$(git -C "$AI_BUDDY_DIR" status --porcelain)" ]; then
    warn "ai-buddy has uncommitted changes, they are built as well"
  fi
  info "installed: ${installed:-none}, repo: $head"
  run make -C "$AI_BUDDY_DIR" install
  changed "AI Buddy built and installed to $AI_BUDDY_APP ($head)"
fi
unset head installed
