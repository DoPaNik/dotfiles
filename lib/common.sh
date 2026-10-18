#!/usr/bin/env bash
# Shared helpers for install.sh and steps/*.sh.
# Compatible with the stock /bin/bash 3.2 of macOS (no associative arrays,
# no empty-array expansion under `set -u`).

DRY_RUN=${DRY_RUN:-0}
COUNT_CHANGED=0
COUNT_UNCHANGED=0
COUNT_SKIPPED=0
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
# Newline separated list of apps to restart after macOS settings changed
RESTART_APPS=""
NEEDS_LOGOUT=0

if [ -t 1 ]; then
  C_RESET=$'\033[0m'; C_DIM=$'\033[2m'; C_BLUE=$'\033[34m'
  C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'; C_RED=$'\033[31m'
else
  C_RESET=""; C_DIM=""; C_BLUE=""; C_GREEN=""; C_YELLOW=""; C_RED=""
fi

# --------------------------------- LOGGING -----------------------------------
section()   { printf '\n%s==> %s%s\n' "$C_BLUE" "$*" "$C_RESET"; }
info()      { printf '    %s\n' "$*"; }
warn()      { printf '%s  ! %s%s\n' "$C_YELLOW" "$*" "$C_RESET" >&2; }
error()     { printf '%s  x %s%s\n' "$C_RED" "$*" "$C_RESET" >&2; }
changed()   { COUNT_CHANGED=$((COUNT_CHANGED + 1));     printf '%s  ~ %s%s\n' "$C_GREEN" "$*" "$C_RESET"; }
unchanged() { COUNT_UNCHANGED=$((COUNT_UNCHANGED + 1)); printf '%s  = %s%s\n' "$C_DIM" "$*" "$C_RESET"; }
skipped()   { COUNT_SKIPPED=$((COUNT_SKIPPED + 1));     printf '%s  - %s%s\n' "$C_YELLOW" "$*" "$C_RESET"; }

die() { error "$*"; exit 1; }

# Run a command, or only print it in dry-run mode
run() {
  if [ "$DRY_RUN" = 1 ]; then
    printf '%s    [dry-run] %s%s\n' "$C_DIM" "$*" "$C_RESET"
  else
    "$@"
  fi
}

has() { command -v "$1" >/dev/null 2>&1; }

# Fail early if sudo is needed but no password was given yet
require_sudo() {
  [ "$DRY_RUN" = 1 ] && return 0
  sudo -n true 2>/dev/null && return 0
  info "Administrator password required:"
  sudo -v || die "sudo failed"
}

restart_app() {
  case $'\n'"$RESTART_APPS"$'\n' in
    *$'\n'"$1"$'\n'*) ;;
    *) RESTART_APPS="${RESTART_APPS:+$RESTART_APPS$'\n'}$1" ;;
  esac
}

restart_apps() {
  [ -z "$RESTART_APPS" ] && return 0
  section "Restarting affected apps"
  local app
  while IFS= read -r app; do
    if pgrep -xq "$app"; then
      run killall "$app" || true
      [ "$DRY_RUN" = 1 ] || info "restarted $app"
    fi
  done <<EOF
$RESTART_APPS
EOF
  RESTART_APPS=""
}

# ---------------------------------- FILES ------------------------------------

# Move an existing file into the backup directory, keeping its path below $HOME
backup_path() {
  local target=$1 rel dest
  rel=${target#"$HOME"/}
  dest="$BACKUP_DIR/$rel"
  run mkdir -p "$(dirname "$dest")"
  run mv "$target" "$dest"
  info "backup: $target -> $dest"
}

# link_file SOURCE TARGET: symlink TARGET to SOURCE, backing up whatever was there
link_file() {
  local src=$1 dst=$2
  [ -e "$src" ] || die "link source missing: $src"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    unchanged "link $dst"
    return 0
  fi
  if [ -e "$dst" ] || [ -L "$dst" ]; then
    backup_path "$dst"
  fi
  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  changed "link $dst -> $src"
}

# ------------------------------ macOS DEFAULTS --------------------------------

# Map our short type names to `defaults read-type` and plutil names
_type_name() {
  case $1 in
    bool) echo boolean ;; int) echo integer ;; float) echo float ;; string) echo string ;;
    *) die "unknown type: $1" ;;
  esac
}

_plutil_flag() {
  case $1 in
    bool) echo -bool ;; int) echo -integer ;; float) echo -float ;; string) echo -string ;;
    *) die "unknown type: $1" ;;
  esac
}

# Compare a value read back from defaults/plutil with the wanted one
_same_value() {
  local type=$1 current=$2 wanted=$3
  case $type in
    bool)
      case $wanted in true) wanted=1 ;; false) wanted=0 ;; esac
      case $current in true) current=1 ;; false) current=0 ;; esac
      [ "$current" = "$wanted" ] ;;
    int|float)
      awk -v a="$current" -v b="$wanted" 'BEGIN { exit !(a == b && a != "") }' ;;
    *)
      [ "$current" = "$wanted" ] ;;
  esac
}

# set_default [--host] [--sudo] [--app NAME] DOMAIN KEY TYPE VALUE
#   Writes a top-level preference only if it differs (value or type).
#   --host  use -currentHost    --sudo  write with sudo (system domains)
#   --app   restart this app at the end if the value changed
set_default() {
  local host="" sudo_cmd="" app=""
  while [ $# -gt 0 ]; do
    case $1 in
      --host) host="-currentHost"; shift ;;
      --sudo) sudo_cmd="sudo"; shift ;;
      --app)  app=$2; shift 2 ;;
      *) break ;;
    esac
  done
  local domain=$1 key=$2 type=$3 value=$4 current current_type label
  label="$domain $key"
  # shellcheck disable=SC2086 # $host is intentionally unquoted (empty or one flag)
  current=$(defaults $host read "$domain" "$key" 2>/dev/null) || current=""
  # shellcheck disable=SC2086
  current_type=$(defaults $host read-type "$domain" "$key" 2>/dev/null | awk '{print $3}') || current_type=""
  if [ "$current_type" = "$(_type_name "$type")" ] && _same_value "$type" "$current" "$value"; then
    unchanged "$label"
    return 0
  fi
  # shellcheck disable=SC2086
  run $sudo_cmd defaults $host write "$domain" "$key" "-$type" "$value"
  changed "$label: ${current:-<unset>} -> $value"
  [ -n "$app" ] && restart_app "$app"
  return 0
}

# set_default_array [--app NAME] DOMAIN KEY [VALUE ...]
#   Writes a string array only if it differs. No values = empty array.
set_default_array() {
  local app=""
  if [ "${1:-}" = "--app" ]; then app=$2; shift 2; fi
  local domain=$1 key=$2 current wanted v
  shift 2
  wanted="["
  for v in "$@"; do wanted="$wanted\"$v\","; done
  wanted="${wanted%,}]"
  current=$(defaults export "$domain" - 2>/dev/null | plutil -extract "$key" json -o - - 2>/dev/null) || current=""
  if [ "$current" = "$wanted" ]; then
    unchanged "$domain $key"
    return 0
  fi
  run defaults write "$domain" "$key" -array "$@"
  changed "$domain $key: ${current:-<unset>} -> $wanted"
  [ -n "$app" ] && restart_app "$app"
  return 0
}

# set_pref_path [--app NAME] DOMAIN KEY.PATH TYPE VALUE
#   Sets a nested preference (dicts inside dicts). Goes through
#   `defaults export/import` so cfprefsd does not overwrite the change, and
#   creates missing parent dictionaries (PlistBuddy "Set" could not).
set_pref_path() {
  local app=""
  if [ "${1:-}" = "--app" ]; then app=$2; shift 2; fi
  local domain=$1 keypath=$2 type=$3 value=$4 current tmp parent part
  current=$(defaults export "$domain" - 2>/dev/null | plutil -extract "$keypath" raw -o - - 2>/dev/null) || current=""
  if [ -n "$current" ] && _same_value "$type" "$current" "$value"; then
    unchanged "$domain $keypath"
    return 0
  fi
  if [ "$DRY_RUN" = 1 ]; then
    run "set $domain $keypath = $value"
  else
    tmp=$(mktemp -t dotfiles-pref)
    defaults export "$domain" "$tmp" 2>/dev/null || plutil -create xml1 "$tmp"
    # Create missing parent dictionaries one level at a time
    parent=""
    local IFS_OLD=$IFS; IFS=.
    # shellcheck disable=SC2086 # split the key path on dots
    set -- $keypath
    IFS=$IFS_OLD
    while [ $# -gt 1 ]; do
      part=$1; shift
      parent="${parent:+$parent.}$part"
      plutil -extract "$parent" raw -o /dev/null "$tmp" 2>/dev/null \
        || plutil -insert "$parent" -dictionary "$tmp" 2>/dev/null \
        || plutil -insert "$parent" -xml '<dict/>' "$tmp"
    done
    plutil -replace "$keypath" "$(_plutil_flag "$type")" "$value" "$tmp"
    defaults import "$domain" "$tmp"
    rm -f "$tmp"
  fi
  changed "$domain $keypath: ${current:-<unset>} -> $value"
  [ -n "$app" ] && restart_app "$app"
  return 0
}

# set_pmset KEY VALUE: power setting for all power sources (Mac Studio = AC only)
set_pmset() {
  local key=$1 value=$2 current
  current=$(pmset -g custom | awk -v k="$key" '$1 == k { print $2; exit }')
  if [ "$current" = "$value" ]; then
    unchanged "pmset $key"
    return 0
  fi
  run sudo pmset -a "$key" "$value"
  changed "pmset $key: ${current:-<unset>} -> $value"
}

# summary: print counters at the end of a run
summary() {
  section "Summary"
  info "${COUNT_CHANGED} changed, ${COUNT_UNCHANGED} unchanged, ${COUNT_SKIPPED} skipped"
  [ "$DRY_RUN" = 1 ] && info "dry-run: nothing was changed"
  [ "$NEEDS_LOGOUT" = 1 ] && warn "Some settings only take effect after logging out and in again."
  return 0
}
