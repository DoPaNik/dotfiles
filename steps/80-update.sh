#!/usr/bin/env bash
# Upgrade Homebrew packages, mise runtimes and Oh My Zsh

section "Update"

if has brew; then
  run brew update --quiet
  # Casks that update themselves (auto_updates) are left to the apps
  outdated=$(brew outdated --quiet 2>/dev/null || true)
  if [ -z "$outdated" ]; then
    unchanged "Homebrew packages up to date"
  else
    printf '%s\n' "$outdated" | sed 's/^/      /'
    run brew upgrade
    changed "Homebrew: $(printf '%s\n' "$outdated" | wc -l | tr -d ' ') packages upgraded"
  fi
else
  skipped "brew not available"
fi

if has mise; then
  outdated=$(mise outdated --json 2>/dev/null || echo "{}")
  if [ "$outdated" = "{}" ]; then
    unchanged "mise tools up to date"
  else
    mise outdated 2>/dev/null | sed 's/^/      /' || true
    run mise upgrade
    changed "mise tools upgraded"
  fi
else
  skipped "mise not available"
fi

OMZ_DIR="$HOME/.oh-my-zsh"
if [ -d "$OMZ_DIR/.git" ]; then
  git -C "$OMZ_DIR" fetch --quiet origin 2>/dev/null || true
  behind=$(git -C "$OMZ_DIR" rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo 0)
  if [ "$behind" -eq 0 ]; then
    unchanged "Oh My Zsh up to date"
  else
    run env ZSH="$OMZ_DIR" zsh -f "$OMZ_DIR/tools/upgrade.sh"
    changed "Oh My Zsh: $behind commits"
  fi
else
  skipped "Oh My Zsh not installed"
fi
unset outdated behind OMZ_DIR
