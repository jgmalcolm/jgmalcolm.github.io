---
title:
layout: post
---
javascript bookmarklet to toggle hide/show slide sidebar

cleaning up slides imported from Office: "Cmd + \" to reset formatting


javascript:var d=document,f='https://www.facebook.com/share',l=d.location,e=encodeURIComponent,p='.php?src=bm&v=4&i=1367542561&u='+e(l.href)+'&t='+e(d.title);1;try{if (!/^(.*\.)?facebook\.[^.]*$/.test(l.host))throw(0);share_internal_bookmarklet(p)}catch(z) {a=function() {if (!window.open(f+'r'+p,'sharer','toolbar=0,status=0,resizable=1,width=726,height=536'))l.href=f+p};if (/Firefox/.test(navigator.userAgent))setTimeout(a,0);else{a()}}void(0)

javascript:function iprl5()%7Bvar d%3Ddocument,z%3Dd.createElement(%27scr%27%2B%27ipt%27),b%3Dd.body,l%3Dd.location%3Btry%7Bif(!b)throw(0)%3Bd.title%3D%27(Saving...) %27%2Bd.title%3Bz.setAttribute(%27src%27,l.protocol%2B%27//www.instapaper.com/j/gFzynNNmWmlP%3Fa%3Dread-later%26u%3D%27%2BencodeURIComponent(l.href)%2B%27%26t%3D%27%2B(new Date().getTime()))%3Bb.appendChild(z)%3B%7Dcatch(e)%7Balert(%27Please wait until the page has loaded.%27)%3B%7D%7Diprl5()%3Bvoid(0)

javascript:(function (){var strip=document.getElementById('filmstrip');strip.style.display=(strip.style.display=='')?'none':'';})();void(0)


TODO: force redraw
