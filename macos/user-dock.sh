#!/usr/bin/env bash
# shellcheck disable=SC2086 # $F/$D expand to "--app <name>" on purpose
# Dock, Mission Control and hot corners

D="--app Dock"

# Enable highlight hover effect for the grid view of a stack (Dock)
set_default $D com.apple.dock mouse-over-hilite-stack bool true

# Set the icon size of Dock items to 36 pixels
set_default $D com.apple.dock tilesize int 36

# Change minimize/maximize window effect
set_default $D com.apple.dock mineffect string "scale"

# Minimize windows into their application’s icon
set_default $D com.apple.dock minimize-to-application bool true

# Enable spring loading for all Dock items
set_default $D com.apple.dock enable-spring-load-actions-on-all-items bool true

# Show indicator lights for open applications in the Dock
set_default $D com.apple.dock show-process-indicators bool true

# Show only open applications in the Dock, without pinned default apps
set_default $D com.apple.dock static-only bool true
set_default_array $D com.apple.dock persistent-apps

# Don’t animate opening applications from the Dock
set_default $D com.apple.dock launchanim bool false

# Speed up Mission Control animations
set_default $D com.apple.dock expose-animation-duration float 0.1

# Don’t group windows by application in Mission Control
set_default $D com.apple.dock expose-group-by-app bool false

# Don’t automatically rearrange Spaces based on most recent use
set_default $D com.apple.dock mru-spaces bool false

# Automatically hide and show the Dock, without delay and animation
set_default $D com.apple.dock autohide bool true
set_default $D com.apple.dock autohide-delay float 0
set_default $D com.apple.dock autohide-time-modifier float 0

# Make Dock icons of hidden applications translucent
set_default $D com.apple.dock showhidden bool true

# Don’t show recent applications in Dock
set_default $D com.apple.dock show-recents bool false

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# 14: Quick Note
# Top left → Mission Control, top right → Desktop, bottom left → Screen saver
set_default $D com.apple.dock wvous-tl-corner int 2
set_default $D com.apple.dock wvous-tl-modifier int 0
set_default $D com.apple.dock wvous-tr-corner int 4
set_default $D com.apple.dock wvous-tr-modifier int 0
set_default $D com.apple.dock wvous-bl-corner int 5
set_default $D com.apple.dock wvous-bl-modifier int 0

unset D
