---
title: Wikipedia Tricks
layout: post
keywords: wikipedia, javascript, themes
---

<img class="thumb" src="/images/wikipedia.png"> [Wikipedia](//wikipedia.org)
can be a little clumsy to navigate.  These three tricks will enable you to
read articles more efficiently by simplifying the interface, streamlining
image viewing, and enabling pop-up link previews.

To use these, you'll need to [create a Wikipedia account][account] so you can
save settings to your profile.  Once you have an account, Wikipedia lets you
choose among a few default themes ("skins") on the
[preference page][preferences].  I recommend using Vector (the default) since
it's clean and modern looking ([preview]), and it'll be required the
first trick below.

In addition to setting a global theme, Wikipedia also lets you directly modify
source files for both the global site (regardless of theme selected) and
source files for the particular theme selected.  These files are either
[JavaScript](https://en.wikipedia.org/wiki/JavaScript) for code or
[CSS](https://en.wikipedia.org/wiki/Css) for color/font settings.

* global [common.js] and [common.css]
* theme-specific [vector.js] and [vector.css]


  [skins]:       https://www.mediawiki.org/wiki/Manual:Skins
  [account]:     https://en.wikipedia.org/wiki/Wikipedia:Why_create_an_account%3F
  [preferences]: https://en.wikipedia.org/wiki/Special:Preferences#mw-prefsection-rendering
  [common.js]:   https://en.wikipedia.org/wiki/Special:MyPage/common.js
  [common.css]:  https://en.wikipedia.org/wiki/Special:MyPage/common.css
  [vector.js]:   https://en.wikipedia.org/wiki/Special:MyPage/vector.js
  [vector.css]:  https://en.wikipedia.org/wiki/Special:MyPage/vector.css
  [preview]:     https://en.wikipedia.org/wiki/Jean-Jacques_Rousseau?useskin=vector



Simplify the interface
----------------------

The default Wikipedia page layout has a sidebar that takes up a good chunk of
the screen and that means less room for the important stuff: text and images.

[WideSkin][WideSkin] moves the left sidebar panel into the toolbar.  WideSkin
only works with the Vector theme.  Follow the instructions to make two
modifications to your user theme files: adding an import statement to your
custom [vector.js], and adding a few new CSS tags to your custom [vector.css]
file.

<div class="gallery">
  <a href="/images/wikipedia-tricks-full.png" data-gallery="wiki"
     title="Using the WideSkin theme reclaims the wasted space on the left. Those rarely used links are now in a toolbar dropdown.">
     <img src="/images/wikipedia-tricks-full.png"></a>
  <a href="/images/wikipedia-tricks-full-before.png" data-gallery="wiki"
     title="Default Wikipedia has a sidebar on the left that takes up valuable screen real estate."></a>
</div>




Streamline image viewing
------------------------

With the default Wikipedia, images always require two hops: clicking on the
image brings up the File page where you click again to see the full resolution
image.  Then you have to click the Back button to return to your page.

Skip all of that by setting up [LightBox][LightBox] so a single click brings
up the image full resolution, and clicking or hitting any key will close it.

<div class="gallery">
  <a href="/images/wikipedia-tricks-image.png" data-gallery="wiki"
     title="With LighbBox enabled, clicking on an image immediately brings it up full screen.  Any keypress or click returns you to the article.">
     <img src="/images/wikipedia-tricks-image.png"></a>
  <a href="/images/wikipedia-tricks-image-before.png" data-gallery="wiki"
     title="With default Wikipedia, clicking on an image takes you to a separate page for that file.  You have to click a second time to see the full image."></a>
</div>

Wikipedia also has its own built-in alternative [MediaViewer][MediaViewer] but
I've found it to be clunky.



Pop-up link previews
--------------------

Exploring any new topic on Wikipedia can be a rabbit trail, and I'm often left
with a dozen new tabs open to other pages on Wikipedia.  The cluttered tabs
are not really necessary because often I just could have read the first
paragraph to get an idea before continuing on with the original article.

Enter [Hovercards][Hovercards].  Hover the mouse over any link to another
Wikipedia article and a small pop-up appears with the first few sentences.
I've found this lets me move more quickly through articles.  Enable Hovercards
from the [Beta Preferences page][beta].


<div class="gallery">
  <a href="/images/wikipedia-tricks-hover.png" data-gallery="wiki"
     title="Hovering over any link to another Wikipedia article creates a popup with the first few sentences and key image.">
     <img src="/images/wikipedia-tricks-hover.png"></a>
</div>


  [WideSkin]: https://en.wikipedia.org/wiki/User:Blue-Haired_Lawyer/Wide_Skin
  [LightBox]: https://en.wikipedia.org/wiki/User:Malcolmj1/SimpleLightbox
  [MediaViewer]: https://www.mediawiki.org/wiki/Multimedia/About_Media_Viewer
  [Hovercards]: https://www.mediawiki.org/wiki/Beta_Features/Hovercards
  [beta]: https://en.wikipedia.org/wiki/Special:Preferences#mw-prefsection-betafeatures

Any other tips and tricks you find useful?


{% include gallery.html %}
