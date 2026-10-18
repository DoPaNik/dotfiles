#!/usr/bin/env bash
# Settings for individual apps

# iTerm 2: don’t display the annoying prompt when quitting
set_default com.googlecode.iterm2 PromptOnQuit bool false

# Activity Monitor: show the main window, CPU usage in the Dock icon,
# all processes, sorted by CPU usage
set_default --app "Activity Monitor" com.apple.ActivityMonitor OpenMainWindow bool true
set_default --app "Activity Monitor" com.apple.ActivityMonitor IconType int 5
set_default --app "Activity Monitor" com.apple.ActivityMonitor ShowCategory int 0
set_default --app "Activity Monitor" com.apple.ActivityMonitor SortColumn string "CPUUsage"
set_default --app "Activity Monitor" com.apple.ActivityMonitor SortDirection int 0

# TextEdit: plain text mode for new documents, open and save as UTF-8
set_default com.apple.TextEdit RichText bool false
set_default com.apple.TextEdit PlainTextEncoding int 4
set_default com.apple.TextEdit PlainTextEncodingForWrite int 4

# QuickTime Player: auto-play videos when opened
set_default com.apple.QuickTimePlayerX MGPlayMovieOnOpen bool true

# Photos: prevent opening automatically when devices are plugged in
set_default --host com.apple.ImageCapture disableHotPlug bool true
