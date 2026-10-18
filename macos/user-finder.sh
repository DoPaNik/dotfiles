#!/usr/bin/env bash
# shellcheck disable=SC2086 # $F/$D expand to "--app <name>" on purpose
# Finder

F="--app Finder"

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
set_default $F com.apple.finder QuitMenuItem bool true

# Finder: disable window animations and Get Info animations
set_default $F com.apple.finder DisableAllAnimations bool true

# Set Desktop as the default location for new Finder windows
set_default $F com.apple.finder NewWindowTarget string "PfDe"
set_default $F com.apple.finder NewWindowTargetPath string "file://${HOME}/Desktop/"

# Show icons for hard drives, servers, and removable media on the desktop
set_default $F com.apple.finder ShowExternalHardDrivesOnDesktop bool true
set_default $F com.apple.finder ShowHardDrivesOnDesktop bool true
set_default $F com.apple.finder ShowMountedServersOnDesktop bool true
set_default $F com.apple.finder ShowRemovableMediaOnDesktop bool true

# Finder: show all filename extensions
set_default $F NSGlobalDomain AppleShowAllExtensions bool true

# Finder: show status bar and path bar
set_default $F com.apple.finder ShowStatusBar bool true
set_default $F com.apple.finder ShowPathbar bool true

# Display full POSIX path as Finder window title
set_default $F com.apple.finder _FXShowPosixPathInTitle bool true

# Keep folders on top when sorting by name
set_default $F com.apple.finder _FXSortFoldersFirst bool true

# When performing a search, search the current folder by default
set_default $F com.apple.finder FXDefaultSearchScope string "SCcf"

# Disable the warning when changing a file extension
set_default $F com.apple.finder FXEnableExtensionChangeWarning bool false

# Enable spring loading for directories, without delay
set_default NSGlobalDomain com.apple.springing.enabled bool true
set_default NSGlobalDomain com.apple.springing.delay float 0

# Avoid creating .DS_Store files on network or USB volumes
set_default com.apple.desktopservices DSDontWriteNetworkStores bool true
set_default com.apple.desktopservices DSDontWriteUSBStores bool true

# Automatically open a new Finder window when a volume is mounted
set_default com.apple.frameworks.diskimages auto-open-ro-root bool true
set_default com.apple.frameworks.diskimages auto-open-rw-root bool true
set_default $F com.apple.finder OpenWindowForNewRemovableDisk bool true

# Icon views on the desktop and in other icon views:
# item info, labels on the right, snap-to-grid, spacing and size
for view in DesktopViewSettings FK_StandardViewSettings StandardViewSettings; do
  set_pref_path $F com.apple.finder "$view.IconViewSettings.showItemInfo" bool true
  set_pref_path $F com.apple.finder "$view.IconViewSettings.arrangeBy" string grid
  set_pref_path $F com.apple.finder "$view.IconViewSettings.gridSpacing" float 100
  set_pref_path $F com.apple.finder "$view.IconViewSettings.iconSize" float 44
done
set_pref_path $F com.apple.finder DesktopViewSettings.IconViewSettings.labelOnBottom bool false
unset view

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `glyv`
set_default $F com.apple.finder FXPreferredViewStyle string "Nlsv"

# Disable the warning before emptying the Trash
set_default $F com.apple.finder WarnOnEmptyTrash bool false

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
set_pref_path $F com.apple.finder FXInfoPanesExpanded.General bool true
set_pref_path $F com.apple.finder FXInfoPanesExpanded.OpenWith bool true
set_pref_path $F com.apple.finder FXInfoPanesExpanded.Privileges bool true

# Show the ~/Library folder
if ls -lOd "$HOME/Library" | grep -q hidden; then
  run chflags nohidden "$HOME/Library"
  changed "~/Library visible"
else
  unchanged "~/Library visible"
fi

unset F
