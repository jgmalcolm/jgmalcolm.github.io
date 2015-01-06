---
title: "Mac OS X Tweaks"
tags: tools
---

Some tweaks to get rid of Mac OSX animations and make the UI feel a little
snappier.  Copy and paste these into your terminal (`#` lines are ignored
comments).

    defaults write -g NSAutomaticWindowAnimationsEnabled -bool NO; killall Dock
    defaults write -g NSToolbarFullScreenAnimationDuration -float 0
    defaults write -g NSBrowserColumnAnimiationSpeedMultiplier -float 0
    defaults write com.apple.dock expose-animation-duration -int 0
    defaults write com.apple.dock autohide-time-modifer -float 0
    defaults write com.apple.dock autohide-delay -float 0
