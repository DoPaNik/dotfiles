#!/usr/bin/env bash
# General UI/UX, based on https://mths.be/macos

# Set highlight color to green (format since Big Sur: "R G B Name")
set_default NSGlobalDomain AppleHighlightColor string "0.752941 0.964706 0.678431 Green"

# Set sidebar icon size to medium
set_default NSGlobalDomain NSTableViewDefaultSizeMode int 2

# Always show scrollbars
# Possible values: `WhenScrolling`, `Automatic` and `Always`
set_default NSGlobalDomain AppleShowScrollBars string "Always"

# Disable the over-the-top focus ring animation
set_default NSGlobalDomain NSUseAnimatedFocusRing bool false

# Increase window resize speed for Cocoa applications
set_default NSGlobalDomain NSWindowResizeTime float 0.001

# Expand save panel by default
set_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode bool true
set_default NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 bool true

# Expand print panel by default
set_default NSGlobalDomain PMPrintingExpandedStateForPrint bool true
set_default NSGlobalDomain PMPrintingExpandedStateForPrint2 bool true

# Save to disk (not to iCloud) by default
set_default NSGlobalDomain NSDocumentSaveNewDocumentsToCloud bool false

# Automatically quit printer app once the print jobs complete
set_default com.apple.print.PrintingPrefs "Quit When Finished" bool true

# Display ASCII control characters using caret notation in standard text views
set_default NSGlobalDomain NSTextShowsControlCharacters bool true

# Disable Resume system-wide
set_default com.apple.systempreferences NSQuitAlwaysKeepsWindows bool false

# Disable automatic termination of inactive apps
set_default NSGlobalDomain NSDisableAutomaticTermination bool true

# Disable automatic capitalization, smart dashes, period substitution,
# smart quotes and auto-correct as they're annoying when typing code
set_default NSGlobalDomain NSAutomaticCapitalizationEnabled bool false
set_default NSGlobalDomain NSAutomaticDashSubstitutionEnabled bool false
set_default NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled bool false
set_default NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled bool false
set_default NSGlobalDomain NSAutomaticSpellingCorrectionEnabled bool false

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to the desktop, as PNG, without window shadow
set_default --app SystemUIServer com.apple.screencapture location string "${HOME}/Desktop"
set_default --app SystemUIServer com.apple.screencapture type string "png"
set_default --app SystemUIServer com.apple.screencapture disable-shadow bool true
