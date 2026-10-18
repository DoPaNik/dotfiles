#!/usr/bin/env bash
# Language runtimes via mise (Python, Node.js)

section "mise"

link_file "$DOTFILES_DIR/home/.config/mise/config.toml" "$HOME/.config/mise/config.toml"

if ! has mise; then
  skipped "mise not installed yet (packages step)"
  return 0
fi

missing=$(mise ls --global --missing 2>/dev/null || true)
if [ -z "$missing" ]; then
  unchanged "all global mise tools installed"
else
  printf '%s\n' "$missing" | sed 's/^/      /'
  run mise install
  changed "mise tools installed"
fi
