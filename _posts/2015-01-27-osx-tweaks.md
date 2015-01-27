---
title: "Mac OS X Tweaks"
tags:
- tools
description: "Mac OSX tweaks for a snappier feel."
---

Some tweaks to get rid of a few Mac OSX window animations for a snappier feel.
Copy and paste these into your terminal (`#` lines are ignored comments).

    defaults write -g NSAutomaticWindowAnimationsEnabled -bool NO; killall Dock
    defaults write -g NSToolbarFullScreenAnimationDuration -float 0
    defaults write -g NSBrowserColumnAnimiationSpeedMultiplier -float 0
    defaults write -g NSScrollViewRubberbanding -int 0
    defaults write com.apple.dock expose-animation-duration -float 0
    defaults write com.apple.dock autohide-time-modifer -float 0
    defaults write com.apple.dock autohide-delay -float 0
