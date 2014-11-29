---
title: "What do I use?"
layout: post
description: "A list of tools I use daily to work efficiently, stay focused, and keep organized."
tags: tools
---

The right mix of tools can save you hours a week, or cost you hours.  I'm
always looking for better ways of doing things and new ways of getting
leverage.  Here are lists of the hardware, software, and services I use daily.

## Hardware
* [Macbook Air 11"](http://www.apple.com/macbook-air) with
  [thin padded case][acme case]
* [iPhone 5][iphone] apps:
  * [Instapaper] -- instead of reading everything at the moment, I queue up
    articles to read later using their [bookmarklet][insta-bookmarklet] and
    [Kindle integration][insta-kindle].
  * [Echophon Pro] for twitter - I found this better than twitter's own client and integrates with Instapaper.
  * [Sleep Cycle] to wake me up gently at just the right time
  * for Facebook and news, I just use Safari.  I want to use Chrome, but Apple
    insists on Safari as the default browser
    ([reminiscent of Internet Explorer bundling][msft]).
* [Kindle Paperwhite][kindle] for carrying around a small library of
  interesting books and articles.  The backlit screen is fantastic in low
  light.  I got the 3G model which has come in handy fetching new books while
  traveling in the US and abroad.  Integrates with [Instapaper][instapaper].
* sound:
  * stationary listening:
    [Audéo earbuds] - expensive but
    superb sound and snug fit (sidenote: might be interesting to
    [benchmark them][bench])
  * listening on the go:  [Jarv NMotion Sport Wireless Bluetooth] - good
    sound, excellent price, great for commute and cordless jogging (despite
    the description saying not good for jogging, they're fine)

  [bench]: http://www.audiocheck.net/soundtests_headphones.php
  [acme case]: http://www.amazon.com/gp/product/B007AK6QBA/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B007AK6QBA&linkCode=as2&tag=jgmalcolm-20&linkId=PDK4MX2ZIQ6RCJTY
  [Audéo earbuds]: http://www.amazon.com/gp/product/B003V9QDXK/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B003V9QDXK&linkCode=as2&tag=jgmalcolm-20&linkId=MDT4Q76B4IQOY4BF
  [Jarv NMotion Sport Wireless Bluetooth]: http://www.amazon.com/gp/product/B00JAAJ1F6/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00JAAJ1F6&linkCode=as2&tag=jgmalcolm-20&linkId=MC3Y54SMJGTYZ5Q3

## Software
* [Chrome](https://www.google.com/intl/en_US/chrome/browser/) web browser with extensions:
  * [µBlock] to knock out advertisements
  * [LastPass] to keep all my passwords safe, quickly log me into sites, and fill out tedious forms
  * [Google Drive Offline][offline] to enable editing documents and slides without internet
  * [Google Quick Scroll] to jump right to the interesting bits of an article based on your Google search terms
  * [Facebook bookmarklet][fb] to share pages with friends and family.
  * [RescueTime](//rescuetime.com) to track where I'm spending time (Facebook, email, school-related, ...)
  * [Gmail Offline] to work with email offline (be sure to also install [background sync][GmailSync])
  * [Vimium] to quickly navigate and search pages without moving to the mouse or arrow keys
* [Spectacle](http://spectacleapp.com) to move and resize windows with hot keys
* [MenuMeters] to keep an eye on CPU, memory, internet speed, etc.
* [Witch] to switch between the individual windows of an application (Mac OSX
  only lets you switch between full applications with Command+Tab, and
  Command+` between windows within one application; Witch lets you switch
  between individual windows in separate applications, just like Windows)
* [Airfoil] to route Chrome, YouTube, and any audio from my laptop to [Bose Airplay][bose] speakers
* [Caffeine] to keep my Mac from going to sleep while I'm presenting or surfing
* [F.lux] to alter my laptop's screen colors to the time of day (blue light is
  bad at night).  If you're on a Chromebook then use [G.lux].
* [SelfControl] (Mac) and [ColdTurkey] (Win) to keep me off facebook, email, and the news when I need to be productive
* [TotalTerminal] for quick full-screen access to the command line.
* Emacs/vim/bash/screen/git.  Browse my
  [dot files](https://github.com/jgmalcolm/dotfiles).

[Vimium]: https://chrome.google.com/webstore/detail/vimium/dbepggeogbaibhgnhhndojpepiihcmeb
[Gmail Offline]: https://support.google.com/mail/answer/1306847?hl=en&ref_topic=3397997
[GmailSync]: https://chrome.google.com/webstore/detail/gmail-offline-sync-optimi/dncjnngcblhgeeocnhmmihpanahkjbmi/

## Services
* [Google Apps](http://www.google.com/enterprise/apps/business) - get Gmail, Calendar, Drive, etc all using my own domain (jgmalcolm.com)
  * <a href="javascript:(function(){var a=encodeURIComponent(location.href)+escape('\x0A'+'\x0A')+encodeURIComponent((!!document.getSelection)?document.getSelection():(!!window.getSelection)?window.getSelection():document.selection.createRange().text);var u='http://mail.google.com/mail/?view=cm&ui=2&tf=0&fs=1&su='+encodeURIComponent(document.title)+'&body='+a;if(u.length >= 2048){window.alert('Please select less text');return;}window.open(u,'gmail','height=640,width=840');console.debug(a)})();void(0);">send the current page/quote</a>
  * learn shortcuts to [quickly add events][calender]
  * find out which company has sold your email address with this [Gmail trick][gmail]
* [Wikipedia interface tricks][wikipedia] to navigate and view images more efficiently
* [IFTTT] - I use facebook and twitter to share articles with friends and
  family.  IFTTT records all my [tweets][ifttt-tweets] and
  [facebook posts][ifttt-fb] so I can keep track of interesting articles.
  It's also setup to [cross post][ifttt-fb2tw] facebook article shares over to
  twitter, so I don't have to post to both accounts.  I use the
  [Facebook bookmarklet][fb] to quickly post.


## Bookmarklets

Instead of installing browser extensions that constantly chew up resources,
bookmarklets are efficient for simple tasks.  Each of these is a little
snippet of JavaScript.  To use one, drag it to your Bookmarks (toolbar).

* post the current page on <a href="javascript:var d=document,f='https://www.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1367542561&u='+e(l.href)+'&t='+e(d.title);1;try{if (!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=726,height=536'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)">Facebook</a> or <a href="javascript:(function()%7Bwindow.twttr%3Dwindow.twttr%7C%7C%7B%7D%3Bvar D%3D550,A%3D450,C%3Dscreen.height,B%3Dscreen.width,H%3DMath.round((B/2)-(D/2)),G%3D0,F%3Ddocument,E%3Bif(C>A)%7BG%3DMath.round((C/2)-(A/2))%7Dwindow.twttr.shareWin%3Dwindow.open(%27http://twitter.com/share%27,%27%27,%27left%3D%27%2BH%2B%27,top%3D%27%2BG%2B%27,width%3D%27%2BD%2B%27,height%3D%27%2BA%2B%27,personalbar%3D0,toolbar%3D0,scrollbars%3D1,resizable%3D1%27)%3BE%3DF.createElement(%27script%27)%3BE.src%3D%27http://platform.twitter.com/bookmarklets/share.js%3Fv%3D1%27%3BF.getElementsByTagName(%27head%27)%5B0%5D.appendChild(E)%7D())%3B">Twitter</a> or send via <a href="javascript:(function(){var a=encodeURIComponent(location.href)+escape('\x0A'+'\x0A')+encodeURIComponent((!!document.getSelection)?document.getSelection():(!!window.getSelection)?window.getSelection():document.selection.createRange().text);var u='http://mail.google.com/mail/?view=cm&ui=2&tf=0&fs=1&su='+encodeURIComponent(document.title)+'&body='+a;if(u.length >= 2048){window.alert('Please select less text');return;}window.open(u,'gmail','height=640,width=840');console.debug(a)})();void(0);">Gmail</a>
* send this page to <a href="javascript:function iprl5()%7Bvar d%3Ddocument,z%3Dd.createElement(%27scr%27%2B%27ipt%27),b%3Dd.body,l%3Dd.location%3Btry%7Bif(!b)throw(0)%3Bd.title%3D%27(Saving...) %27%2Bd.title%3Bz.setAttribute(%27src%27,l.protocol%2B%27//www.instapaper.com/j/gFzynNNmWmlP%3Fa%3Dread-later%26u%3D%27%2BencodeURIComponent(l.href)%2B%27%26t%3D%27%2B(new Date().getTime()))%3Bb.appendChild(z)%3B%7Dcatch(e)%7Balert(%27Please wait until the page has loaded.%27)%3B%7D%7Diprl5()%3Bvoid(0)">Instapaper</a>
* create a blank <a href="//docs.google.com/document/create?hl=en">Google Doc</a> or <a href="//spreadsheets.google.com/ccc?new&hl=en">Sheet</a> in current window (Control/Command + click for new window)



[TotalTerminal]: http://totalterminal.binaryage.com
[ifttt-tweets]: https://ifttt.com/recipes/175480-all-your-tweets-in-a-google-spreadsheet
[ifttt-fb]: https://ifttt.com/recipes/175481-save-links-i-share-on-facebook-to-a-google-drive-spreadsheet
[ifttt-fb2tw]: https://ifttt.com/recipes/175482-new-link-post-by-you-then-you-tweet-the-link
[msft]: https://en.wikipedia.org/wiki/United_States_v._Microsoft_Corp.
[wikipedia]: {% post_url 2014-04-26-wikipedia-tricks %}
[Sleep Cycle]: http://www.sleepcycle.com
[kindle]: http://www.amazon.com/gp/product/B00JG8LDC6/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00JG8LDC6&linkCode=as2&tag=jgmalcolm-20&linkId=JF4GKGOEQ2GOTYBJ
[Instapaper]: http://instapaper.com
[insta-bookmarklet]: https://www.instapaper.com/save
[insta-kindle]: https://www.instapaper.com/apps
[Echophon Pro]: http://www.echofon.com
[iphone]: https://www.apple.com/iphone
[fb]: https://www.facebook.com/share_options.php
[gmail]: http://gmailblog.blogspot.com/2008/03/2-hidden-ways-to-get-more-from-your.html
[calender]: https://support.google.com/calendar/answer/36604
[Adblock]: https://chrome.google.com/webstore/detail/adblock/gighmmpiobklfepjocnamgkkbiglidom
[µBlock]: https://chrome.google.com/webstore/detail/%C2%B5block/cjpalhdlnbpafiamejdnhcphjbkeiagm
[LastPass]: https://chrome.google.com/webstore/detail/lastpass-free-password-ma/hdokiejnpimakedhajhdlcegeplioahd
[offline]: https://support.google.com/drive/answer/2375012
[Google Quick Scroll]: https://chrome.google.com/webstore/detail/google-quick-scroll/okanipcmceoeemlbjnmnbdibhgpbllgc
[MenuMeters]: http://www.ragingmenace.com/software/menumeters
[Witch]: http://manytricks.com/witch
[Airfoil]: https://www.rogueamoeba.com/airfoil
[bose]: http://www.amazon.com/gp/product/B0090Z3QD4/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B0090Z3QD4&linkCode=as2&tag=jgmalcolm-20&linkId=7RRGBSYFGX4EC4U3
[Caffeine]: http://lightheadsw.com/caffeine
[F.lux]: https://justgetflux.com
[G.lux]: https://chrome.google.com/webstore/detail/glux/hinolicfmhnjadpggledmhnffommefaf
[SelfControl]: http://selfcontrolapp.com
[ColdTurkey]: http://getcoldturkey.com
[IFTTT]: http://ifttt.com
