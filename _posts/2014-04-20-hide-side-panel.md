---
title: Hide the side panel in Google Slides
layout: post
---

Ever want to close that slide panel in Google Slides so you can get more screen space?  This
bookmarklet will do the trick.

Drag the bookmarklet below to your bookmarks. When you're working on your
presentation, simply click it to hide (or show) the slide panel:

<a class="btn btn-primary btn-lg"
   href="javascript:(function (){var e=document.getElementById('filmstrip');e.style.display=(e.style.display=='')?'none':'';})();void(0)"
   onclick="void(0)">Toggle Slide Panel</a> ←  drag this button to your bookmarks

You'll notice that it simply hides the panel but doesn't refresh the screen
layout to reclaim that space previously filled by the side panel.  Adjust the
window or the notes tray and it'll immediately fill in.  Anyone know a good
way to fix this or force a refresh?

<img style="width:50%;display:inline" src="/images/panel-shown.png"><img style="width:50%;display:inline" src="/images/panel-hidden.png">

If you refresh the page, the panel will reappear.  This bookmarklet doesn't do
anything permanent to Google Slides.

I've also found the text format reset keyboard shortcut useful: "Cmd + \\".
Since a lot of my presentations are imported Microsoft PowerPoint, the notes
text is often all wonky. "Cmd + A" followed by "Cmd + \\" selects all the text
and resets it to baseline.

When you're writing notes you can hit Esc a couple of times to back out from
edit mode to navigation mode where you can use the arrow keys to move between
slides.

Any tips you'd like to add?
