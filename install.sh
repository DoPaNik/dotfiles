#!/usr/bin/env bash
# Provision a Mac from this repository. Safe to run repeatedly: every step
# checks the current state first and only changes what differs.
#
#   ./install.sh                 run all provisioning steps
#   ./install.sh shell git       run selected steps only
#   ./install.sh update          upgrade packages, runtimes and Oh My Zsh
#   ./install.sh --dry-run       show what would change, change nothing
#   ./install.sh --list          list the steps

set -euo pipefail

# The scripts use BSD flags (stat -f, mktemp -t). Put the system tools first,
# even if the calling shell prefers GNU coreutils (see zsh/tools.zsh).
PATH="/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR

# shellcheck source=lib/common.sh
. "$DOTFILES_DIR/lib/common.sh"

ALL_STEPS="preflight homebrew packages shell git mise macos system"
# Only run when named explicitly
EXTRA_STEPS="update"

usage() {
  sed -n '2,10p' "$0" | sed 's/^# \{0,1\}//'
}

list_steps() {
  local s file desc
  for s in $ALL_STEPS $EXTRA_STEPS; do
    file=$(ls "$DOTFILES_DIR"/steps/*-"$s".sh)
    desc=$(sed -n '2s/^# //p' "$file")
    case " $EXTRA_STEPS " in *" $s "*) desc="$desc (only when named)" ;; esac
    printf '  %-10s %s\n' "$s" "$desc"
  done
}

steps=""
while [ $# -gt 0 ]; do
  case $1 in
    -n|--dry-run) DRY_RUN=1 ;;
    -l|--list) list_steps; exit 0 ;;
    -h|--help) usage; exit 0 ;;
    -*) die "unknown option: $1" ;;
    *)
      case " $ALL_STEPS $EXTRA_STEPS " in
        *" $1 "*) steps="$steps $1" ;;
        *) die "unknown step: $1 (see --list)" ;;
      esac ;;
  esac
  shift
done
steps=${steps:-$ALL_STEPS}

[ "$(id -u)" -ne 0 ] || die "do not run as root; steps ask for sudo themselves"

# Make Homebrew available for every step, even on the very first run
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

current_step=""
# Report the failing step once, when set -e aborts the run
# shellcheck disable=SC2154 # rc is assigned inside the trap
trap 'rc=$?; if [ $rc -ne 0 ] && [ -n "$current_step" ]; then error "step \"$current_step\" failed (exit $rc)"; fi' EXIT

[ "$DRY_RUN" = 1 ] && warn "dry-run: nothing will be changed"

for step in $steps; do
  current_step=$step
  # shellcheck source=/dev/null
  . "$(ls "$DOTFILES_DIR"/steps/*-"$step".sh)"
done
current_step=""

summary
