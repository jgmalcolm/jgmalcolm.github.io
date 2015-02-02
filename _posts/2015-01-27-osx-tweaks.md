---
title: "Mac OS X Tweaks"
layout: post
tags:
- tools
description: "Simple changes for a snappier feel."
---

Some tweaks to get rid of a few Mac OSX window animations for a snappier feel.
Copy and paste these into your terminal (`#` lines are ignored comments).

<pre>
# disable new window animation ([details](http://osxdaily.com/2011/07/25/disable-the-new-window-animation-in-mac-os-x-lion/))
defaults write -g NSAutomaticWindowAnimationsEnabled -bool NO; killall Dock

# disable toolbar in fullscreen
defaults write -g NSToolbarFullScreenAnimationDuration -float 0

# scrolling Finder column view
defaults write -g NSBrowserColumnAnimiationSpeedMultiplier -float 0

# rubber band effect
defaults write -g NSScrollViewRubberbanding -int 0

# Dock animations
defaults write com.apple.dock expose-animation-duration -float 0
defaults write com.apple.dock autohide-time-modifer -float 0
defaults write com.apple.dock autohide-delay -float 0
</pre>
