---
title: Google Slides - Hide the slide panel
layout: post
description: JavaScript bookmarklet to toggle display of the slide panel.
---

Ever want to close that slide panel so you can get more screen space?  This
JavaScript bookmarklet will toggle its display.

Drag the bookmarklet below to your Bookmarks Bar. Then simply click it when
you’re working on your presentation and want to hide or show the slide panel:

<p class="bookmarklet_exbox group">
<a href="javascript:(function (){var e=document.getElementById('filmstrip');e.style.display=(e.style.display=='')?'none':'';})();void(0)"
class="bookmarklet"
onclick="return explain_bookmarklet();"
>Toggle Slide Panel</a>

You'll notice that it simply hides the panel but doesn't refresh the screen.
Adjust the window or

If you refresh the page, the panel will reappear.  This bookmarklet doesn't do
anything permanent to Google Slides.

I've found the text format reset keyboard shortcut useful: "Cmd + \".  Since a
lot of my presentations are imported Microsoft PowerPoint, the notes text is
often all wonky. "Cmd + A" followed by "Cmd + \" selects all the text and
resets it to baseline.

Other interesting bookmarklets to study

javascript:var d=document,f='https://www.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1367542561&u='+e(l.href)+'&t='+e(d.title);1;try{if (!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=726,height=536'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)

javascript:function iprl5()%7Bvar d%3Ddocument,z%3Dd.createElement(%27scr%27%2B%27ipt%27),b%3Dd.body,l%3Dd.location%3Btry%7Bif(!b)throw(0)%3Bd.title%3D%27(Saving...) %27%2Bd.title%3Bz.setAttribute(%27src%27,l.protocol%2B%27//www.instapaper.com/j/gFzynNNmWmlP%3Fa%3Dread-later%26u%3D%27%2BencodeURIComponent(l.href)%2B%27%26t%3D%27%2B(new Date().getTime()))%3Bb.appendChild(z)%3B%7Dcatch(e)%7Balert(%27Please wait until the page has loaded.%27)%3B%7D%7Diprl5()%3Bvoid(0)



TODO consider .parentElement


TODO: force redraw
