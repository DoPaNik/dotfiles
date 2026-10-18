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
if [ "$(sudo -n systemsetup -gettimezone 2>/dev/null | awk -F': ' '{print $2}')" = "Europe/Berlin" ]; then
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

# Show the /Volumes folder
if ls -lOd /Volumes | grep -q hidden; then
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
set_default --sudo $SU AutomaticCheckEnabled bool true
set_default --sudo $SU AutomaticDownload bool true
set_default --sudo $SU CriticalUpdateInstall bool true
set_default --sudo $SU ConfigDataInstall bool true

# Turn on app auto-update (App Store)
set_default --sudo /Library/Preferences/com.apple.commerce AutoUpdate bool true
unset SU
