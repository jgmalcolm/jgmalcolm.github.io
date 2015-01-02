---
title: "OSX Tweaks"
tags: tools
---

Some tweaks to get rid of Mac OSX animations and make the UI feel a little
snappier.

    $ defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool NO; killall Dock
    $ defaults write com.apple.dock expose-animation-duration -int 0
    $ defaults write -g NSToolbarFullScreenAnimationDuration -float 0
    $ defaults write -g NSBrowserColumnAnimiationSpeedMultiplier -float 0
    $ defaults write com.apple.dock autohide-time-modifer -float 0
    $ defaults write com.apple.dock autohide-delay -float 0