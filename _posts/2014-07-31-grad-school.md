---
layout: post
title: "Grad school: What I wish I did"
---

You're only stupid enough to get a PhD once.  Here are some lessons learned
and advice.

## Work on important projects

Whatever you do, make sure it's worth it.  You want your time and energy to
make a difference.  It's so easy to work on projects that are technically
feasible but have no consequence on the world.  This will be some of the most
focused and productive years of your life, so make them count.

At the start, you're likely to get swept up in some "awesome" project your
advisor or a senior student dreams up.  This may seem like a grind and you
might not be able to step out.  If that's the case, then keep at it and keep
your eyes open for opportunities to breakout in new interesting directions.
Use the experience to learn your tools.

[Richard Hamming][] gave a famous lecture entitled
["You and your research"][hamming-txt] ([video][hamming-vid]).  I highly
recommend pouring over his advice.  Among the many gems in there, one I want
to highlight here is how he would have lunch with people from other
departments.  Often he would raise the question "What are the important
problems in your field?"  And soon after that he would prod by asking why they
weren't working on the important problems?  Questions like this get under your
skin.  He wasn't welcomed at the lunch table anymore.


## Follow rockstars

Study their techniques and writing.  Try to distill why they are successful.
Maybe you can find a way to relate your work to theirs and forge a joint
project.  Have a list of rockstars both inside and outside your field.

Every year when the Nobel Prize is announced, understand the technique it
highlights enough that you can explain its significance to friends and family.


## Choose your advisor carefully

This will in large part determine what you work on, how stable funding is, and
overall how friendly the lab will be.  Your advisor can control a lot of
factors outside your control.

Find a young and hungry advisor.  It's good for the advisor to have a few
years at your school already so you can ask around for others' impressions and
enjoy the benefit of an established pipeline of projects already up and
running.  It's also good for the advisor to be a few years out from tenure so
they are hungry for work and willing to roll up their sleeves to help.

Probably above all else, you want an advisor you get along with, one you'd
enjoy grabbing beers with.  Ask their students and other faculty for
impressions.  If your advisor picks up the tab, that's a good sign that
funding is secure.

Review their publication record.  Do the topics interest you?  Does the
quality match your expectations?

Later, when it comes to your committee, that's the opportunity to get more
seasoned professors involved to help make introductions.

Don't just jump at the first professor offering funding.  Take your time here
and seek the advice of others.



## Create a blog

You're now a knowledge worker and your personal website is your brand.  Treat
it like an investment: early work pays dividends as you build up a valuable
resources for those following in your footsteps.  Don't wait until your final
years to advertise yourself.

More important than building a public image, writing is a great way to evolve
your thinking, to vet ideas, and practice effective communication.  It's also
a great way to show your advisor what you've been up to.

In some fields, there's of course the need to not give away your ideas to
competitors, but I wager you can still put valuable information in the public.



## Use source control

Version control both code and data.  This way every experiment is repeatable:
the [SHA](http://git-scm.com/book/ch6-1.html#A-SHORT-NOTE-ABOUT-SHA-1) for
indicates a specific state of code and data.  If you're using a database,
[get your database under version control](http://blog.codinghorror.com/get-your-database-under-version-control/).
Put your papers in source control.

This is a great way to show your advisor you're working: point him to the
commit log.  But of course, just making commits do not mean you're being
productive.

Get your research group collaborating this way.  It's a great way to ensure
proper hand-offs of code and projects between students.  If you need private
repos to keep work confidential (pre-publication?), then ask your advisor to
spring for it.
[GitHub](https://github.com/blog/1840-improving-github-for-science) is making
strides to support academics.

Other great ways to collaborate may include using Google docs for real-time
collaboration between coauthors or drafting.  You can now track changes and
accept/reject suggested edits.  [writeLaTeX](https://www.writelatex.com)
provides similar functionality specifically for LaTeX documents.
[Mendeley](http://mendeley.com/) lets you share papers among colleagues and
quickly assemble bibliographies in MS Word.
[Authorea](https://authorea.com/users/3/articles/3904/_show_article) is a
project to make it easier to interact and share scientific ideas.


{% comment %}

## Publish code
  - every paper has an SHA
  - [spread the word about your code][spread]
  - open source http://tom.preston-werner.com/2011/11/22/open-source-everything.html

## Every project needs its own page
  - for the lay and technical
  - papers
    - .TeX
    - figures -> presentations
    - BibTeX
  - code & ?data
    - reproducible experiments!
  - more likely to get cited
  - more likely for others to build upon

## Contribute to Wikipedia
  - provide a road map for newbies and generations to come
  - promote important discoveries and techniques
  - organize your own thoughts

## Papers and publishing
  - work backward from conference location
  - read papers from last year's conference in which you want to publish
    - know the bar
    - [lankton-rss]
  - be sure to cite relevant members of program committee
  - co-authorship, friends
  - know what a "win" looks like to your advisor
    - what does he/she need from you to move their career forward?

## Writing
  - http://www.shawnlankton.com/2008/02/use-that-sweet-spot
  - http://www.shawnlankton.com/2007/09/formula-to-write-a-paper

## Productivity
  - top students
  - focus
  - time
  - balance

Hamming:

> Knowledge and productivity are like compound interest. Given two people of
> approximately the same ability and one person who works ten percent more
> than the other, the latter will more than twice outproduce the former. The
> more you know, the more you learn; the more you learn, the more you can do;
> the more you can do, the more the opportunity - it is very much like
> compound interest.


## Thesis
  - repurpose the intro into book chapters (advisor connections)

## Defense

## Career
  - industry vs postdoc [r01-rate]
  - consulting http://www.shawnlankton.com/2009/08/getting-a-consulting-job-0
  - Hamming

## What can I say I learned from it all?
  - problem solving
  - no fear or intimidation of ideas or science
  - develop a long term research plan with milestones
  - develop convincing experiments
  - persuasive writing

{% endcomment %}

## My story

I completed a PhD in medical imaging and computer vision with the Department
of [Electrical & Computer Engineering](http://ece.gatech.edu) at Georgia Tech.
My advisors provided excellent guidance and support in both life and academia:
[Yogesh Rathi][] (co-advisor) and [Allen Tannenbaum][] (co-advisor).  My
committee included some of the most superb scientists I have ever worked with:
[Tony Yezzi][], [Patricio Vela][], and [Sylvain Bouix][].  I had the
opportunity to focus on diffusion MRI as a research fellow at
[Brigham and Women's Hospital][pnl].  You can see more about the
[techniques][projects] and [papers][] we developed.

During the course of all of that, I worked with fellow students
[Gallagher Pryor][] and [John Melonakos][] to build [Jacket][] and
[ArrayFire][], both software libraries for high performance technical
computing.  I'm now pursuing a lifelong dream as a medical student in Atlanta.

[Yogesh Rathi]: http://pnl.bwh.harvard.edu/people/profiles/rathi.html
[Allen Tannenbaum]: https://en.wikipedia.org/wiki/Allen_Tannenbaum
[Tony Yezzi]: http://www.ece.gatech.edu/faculty-staff/fac_profiles/bio.php?id=116
[Patricio Vela]: http://www.ece.gatech.edu/faculty-staff/fac_profiles/bio.php?id=139
[Sylvain Bouix]: http://pnl.bwh.harvard.edu/people/profiles/bouix.html
[pnl]: http://pnl.bwh.harvard.edu
[projects]: /pubs/research.html
[papers]: /pubs
[Gallagher Pryor]: http://thecrontab.net
[John Melonakos]: http://notonlyluck.com
[AccelerEyes]: https://en.wikipedia.org/wiki/AccelerEyes
[ArrayFire]: http://www.arrayfire.com
[Jacket]: https://en.wikipedia.org/wiki/Jacket_(software)

[lankton-rss]: http://www.shawnlankton.com/2009/07/rss-feeds-for-scientific-journals "RSS Feeds for Scientific Journals"
[spread]: https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code
[Richard Hamming]: https://en.wikipedia.org/wiki/Richard_Hamming
[hamming-txt]: http://www.cs.virginia.edu/~robins/YouAndYourResearch.html "Richard Hamming: You and Your Research (text)"
[hamming-vid]: https://www.youtube.com/watch?v=a1zDuOPkMSw "Richard Hamming: You and Your Research (video)"
[r01-rate]: https://twitter.com/balajis/status/466395475479134208
[wikitricks]: /wikipedia-tricks "Wikipedia Tricks"
[leone]: http://www.cs.cmu.edu/afs/cs.cmu.edu/user/mleone/web/how-to.html "Collected Advice on Research and Writing"
[3sins]: http://www.cs.cmu.edu/~jrs/sins.html "Three Sins of Authors in Computer Science and Math"
[shewchuk]: http://www.cs.berkeley.edu/~jrs/speaking.html "Giving an Academic Talk"
[ramsey]: http://www.cs.tufts.edu/~nr/students/writing.html "Resources for Writers"
[mankiw]: http://gregmankiw.blogspot.com/2006/05/advice-for-grad-students.html "Greg Mankiw&#39;s Blog: Advice for Grad Students"
[shivers-thesis]: http://www.ccs.neu.edu/home/shivers/diss-advice.html
[shivers-guns]: http://www.ccs.neu.edu/home/shivers/autoweapons.html
[shivers-ack]: http://scsh.net/docu/html/man.html
[shivers-defense]: http://www.ccs.neu.edu/home/shivers/grad-advice.html
[might-defense]: http://matt.might.net/articles/phd-defense-tips
[might-productivity]: http://matt.might.net/articles/productivity-tips-hints-hacks-tricks-for-grad-students-academics
