#!/usr/bin/env bash
# Check macOS, CPU, Command Line Tools and admin rights

section "Preflight"

[ "$(uname -s)" = Darwin ] || die "this repository only supports macOS"
info "macOS $(sw_vers -productVersion) on $(uname -m)"
[ "$(uname -m)" = arm64 ] || warn "not Apple Silicon: paths assume /opt/homebrew"

if xcode-select -p >/dev/null 2>&1; then
  unchanged "Command Line Tools ($(xcode-select -p))"
else
  run xcode-select --install || true
  die "Command Line Tools are being installed. Re-run ./install.sh when the installer has finished."
fi

if id -Gn | tr ' ' '\n' | grep -qx admin; then
  unchanged "user $(id -un) is admin"
else
  die "user $(id -un) is not an administrator"
fi
