---
title: Hide the side panel in Google Slides
layout: post
tags: [tools]
description: "Maximize the space you have to edit slides."
---

Ever want to close that slide panel in Google Slides so you can get more screen space?  This
bookmarklet will do the trick.

Drag the bookmarklet below to your bookmarks. When you're working on your
presentation, simply click it to hide (or show) the slide panel:

<a class="button"
   href="javascript:(function (){var e=document.getElementById('filmstrip');e.style.display=(e.style.display=='')?'none':'';})();void(0)"
   onclick="void(0)">Toggle Slide Panel</a> ←  drag this button to your bookmarks

<div class="gallery">
  <a href="/images/slides-before.png" data-gallery="slides"
     title="Normal Google Slide view with side panel for scrolling through slides.">
     <img src="/images/slides-before.png"></a>
  <a href="/images/slides-after.png" data-gallery="slides"
     title="Hiding the side panel gives more room."></a>
</div>
You'll notice that it simply hides the panel but doesn't refresh the screen
layout to reclaim that space previously filled by the side panel.  Adjust the
window or the notes tray and it'll immediately fill in.  Do you know a good
way to fix this or force a refresh?

If you refresh the page, the panel will reappear.  This bookmarklet doesn't do
anything permanent to Google Slides.

I've also found the text format reset keyboard shortcut useful: "Ctrl + \\".
Since a lot of my presentations are imported Microsoft PowerPoint, the notes
text is often all wonky. "Ctrl + A" followed by "Ctrl + \\" selects all the
text and resets it to baseline.  Note: Ctrl &rarr; Cmd for Mac OSX

When you're writing notes you can hit Esc a couple of times to back out from
edit mode to navigation mode where you can use the arrow keys to move between
slides.

Any tips you'd like to add?

{% include gallery.html %}
