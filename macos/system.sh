#!/usr/bin/env bash
# System-wide settings, all need sudo (sourced by steps/70-system.sh)

# Mute the startup chime (Apple Silicon)
if [ "$(nvram StartupMute 2>/dev/null | awk '{print $2}')" = "%01" ]; then
  unchanged "nvram StartupMute"
else
  run sudo nvram StartupMute=%01
  changed "nvram StartupMute -> %01"
fi

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
set_default --sudo /Library/Preferences/com.apple.loginwindow AdminHostInfo string HostName

# Show language menu in the top right corner of the boot screen
set_default --sudo /Library/Preferences/com.apple.loginwindow showInputMenu bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
if [ "$(readlink /etc/localtime)" = "/var/db/timezone/zoneinfo/Europe/Berlin" ]; then
  unchanged "timezone Europe/Berlin"
elif run sudo systemsetup -settimezone "Europe/Berlin" >/dev/null; then
  changed "timezone -> Europe/Berlin"
else
  warn "could not set timezone (Terminal may need Full Disk Access)"
fi

###############################################################################
# Energy saving (Mac Studio: AC power only)                                   #
###############################################################################

# Restart automatically on power loss
set_pmset autorestart 1

# Sleep the display after 5 minutes, never put the machine to sleep
set_pmset displaysleep 5
set_pmset sleep 0

# Restart automatically if the computer freezes
if sudo -n systemsetup -getrestartfreeze 2>/dev/null | grep -q ': On'; then
  unchanged "restart after freeze"
elif run sudo systemsetup -setrestartfreeze on >/dev/null; then
  changed "restart after freeze -> on"
else
  warn "could not enable restart after freeze (Terminal may need Full Disk Access)"
fi

# SMB client (see `man nsmb.conf`), installed from macos/nsmb.conf:
#   signing_required=no   do not require signing (faster NAS transfers)
#   protocol_vers_map=6   SMB2 + SMB3 only, SMB1 disabled
#   streams=yes           allow alternate data streams (default)
# Takes effect for new connections, so reconnect mounted shares.
NSMB_SRC="$DOTFILES_DIR/macos/nsmb.conf"
if cmp -s "$NSMB_SRC" /etc/nsmb.conf; then
  unchanged "/etc/nsmb.conf"
else
  if [ -e /etc/nsmb.conf ]; then
    run mkdir -p "$BACKUP_DIR/etc"
    run cp /etc/nsmb.conf "$BACKUP_DIR/etc/nsmb.conf"
    info "backup: /etc/nsmb.conf -> $BACKUP_DIR/etc/nsmb.conf"
  fi
  run sudo install -m 644 -o root -g wheel "$NSMB_SRC" /etc/nsmb.conf
  changed "/etc/nsmb.conf (reconnect SMB shares to apply)"
fi
unset NSMB_SRC

# Show the /Volumes folder
if stat -f %Sf /Volumes | grep -q hidden; then
  run sudo chflags nohidden /Volumes
  changed "/Volumes visible"
else
  unchanged "/Volumes visible"
fi

###############################################################################
# Software updates                                                            #
###############################################################################

SU=/Library/Preferences/com.apple.SoftwareUpdate
# Check, download and install security updates and system data files
# The update daemon rewrites its plist and may drop AutomaticCheckEnabled,
# so check and set the schedule through softwareupdate instead
if softwareupdate --schedule 2>/dev/null | grep -q 'turned on'; then
  unchanged "automatic update check"
else
  run sudo softwareupdate --schedule on >/dev/null
  changed "automatic update check -> on"
fi
set_default --sudo $SU AutomaticDownload bool true
set_default --sudo $SU CriticalUpdateInstall bool true
set_default --sudo $SU ConfigDataInstall bool true

# Turn on app auto-update (App Store)
set_default --sudo /Library/Preferences/com.apple.commerce AutoUpdate bool true
unset SU
