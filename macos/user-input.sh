#!/usr/bin/env bash
# Keyboard, mouse, language and region

# Disable "natural" (Lion-style) scrolling
set_default NSGlobalDomain com.apple.swipescrolldirection bool false

# Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)
# Since macOS 13 the "Keyboard navigation" switch writes 2
set_default NSGlobalDomain AppleKeyboardUIMode int 2

# Disable press-and-hold for keys in favor of key repeat
set_default NSGlobalDomain ApplePressAndHoldEnabled bool false

# Set the fastest keyboard repeat rate and shortest delay the UI offers
set_default NSGlobalDomain KeyRepeat int 2
set_default NSGlobalDomain InitialKeyRepeat int 15

# English UI with German formats (dates, numbers, currency, metric units)
before=$COUNT_CHANGED
set_default_array NSGlobalDomain AppleLanguages "en-DE" "de-DE"
set_default NSGlobalDomain AppleLocale string "en_DE"
set_default NSGlobalDomain AppleMeasurementUnits string "Centimeters"
set_default NSGlobalDomain AppleMetricUnits bool true
# shellcheck disable=SC2034 # read by summary() in lib/common.sh
[ "$COUNT_CHANGED" -gt "$before" ] && NEEDS_LOGOUT=1
unset before
