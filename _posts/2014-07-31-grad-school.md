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
recommend pouring over his advice.  Among the gems in there, one I want
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
highlights enough that you can explain its significance to friends and
family.  Same goes for the Fields Medal, Turing Award, etc.


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


## Don't take classes

You'll have some minimal requirements.  Get those out of the way as fast as
possible.  You will be way more productive once you can spend 100% of your
brainpower on research, instead of breaking to go to some random class.  At
this point, with all that's available online, a top student can teach
themselves anything necessary.  Your advisor can point out most of your
deficiencies; ask her what you should take classes in, and what to avoid.

It's fine to "drop in" on a few lectures here and there that you enjoy, but
don't delude yourself into actually taking the course to learn.  Classes,
especially those at the grad level, have you jumping through hoops to complete
ethereal homework assignments and cramming for exams when you could be putting
that energy into a publication that will advance your career.  To broaden your
horizons, attend some seminar lectures, drop in on some specific classes, have
lunch with a particular professor, ask your advisor to point you in the right
direction, let yourself wander on the internet for a few hours.  But don't
consign yourself to a static lecture every Wednesday afternoon.

If you're really interested in something, approach the professor personally
and ask for any lecture notes or a book recommendation, and then block off
several days to work through the first few chapters and associated problems --
no research, just working through the book and Wikipedia..  Come back to their
office for help.  I would wager that a professor watching you do this would be
ecstatic to see a student with such diligence and true interest.  You'll
likely learn more out of a few focused days rather than some sprinkled one
hour lectures and a final.

Invest in yourself and understanding how you learn, so that you can forever
after teach yourself anything you want.


## Put everything under version control

Version control is like today's version of the lab notebook: a record of
everything tried.  Version control both code and data.  This way every
experiment is repeatable:  every experiment is uniquely identified by a
[SHA](http://git-scm.com/book/ch6-1.html#A-SHORT-NOTE-ABOUT-SHA-1) indicating
a specific version of the code and data.  If you're using a database,
[get your database under version control](http://blog.codinghorror.com/get-your-database-under-version-control/).
Put your papers in source control.  Don't put source code in Dropbox.

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
accept/reject suggested edits.
[Several platforms](http://tex.stackexchange.com/a/1654) exist for
collaborating with LaTeX documents.  [Mendeley](http://mendeley.com/) lets you
share papers among colleagues and quickly assemble bibliographies in MS Word.
[Authorea](https://authorea.com/users/3/articles/3904/_show_article) is a
project to make it easier to interact and share scientific ideas.

Any time you're dealing with code -- your own or from a colleague -- you want
to get that done in source control.  Suppose an older grad student hands you a
code base, if it wasn't through github or such, them immediately (before you
make any edits) put the files into a fresh repo.  Unzip and make that the
initial commit.  Only after that initial commit should you make any changes to
get the code to run, e.g. changing hard coded values/parameters.


## Every project needs its own page

Every project should have its own online page where people can learn more.  At
a minimum this should have the paper itself, but consider making available
code/data for those wishing to replicate/extend your work, high resolution
figures, any slides or poster you created, full citation already formated for
BibTeX or similar, etc.  Make it easy for those wishing to learn more and
extend your work.  Maybe some student wants to present your work to his/her
lab group, so having a ready-made slide deck makes this easy.  This is a great
way to [spread the word about your code][spread] and there are many benefits
to [open sourcing everything][preston-werner].  You're more likely to get
cited and for others to build upon your results.  When you package up code,
set it up so it runs right out of the box on some sample image/data.

Make it accessible to the non-technical readers too.  Your research was likely
funded by taxpayers, so make some effort to dumb it down some.  Make it easy
for anyone to quickly grasp the importance of your result and the basic
technique.

  [spread]: https://hacks.mozilla.org/2013/05/how-to-spread-the-word-about-your-code
  [preston-werner]: http://tom.preston-werner.com/2011/11/22/open-source-everything.html


## Contribute to Wikipedia

Evangelize about your research area.  Link it into other relevant topics.
Link to seminal research and online resources.  Provide a road map for newbies
and generations to come.  This will help you organize your own thoughts and
mental map of the research landscape.  See [how to customize Wikipedia]({% post_url 2014-04-26-wikipedia-tricks %}).


## Papers and publishing

Figure out your target conferences and journals, and then obsess over those.
Skim the last few years proceedings to get an idea of where the bar is at and
what's hot.  Some journals have [RSS feeds][lankton-rss] so you can keep up.

Pick some target conferences and workshops (ones with great locations!) and
work backward from those submission dates.  Put them on your calendar.  Map
out the Program Committee members, and be sure you're familiar with their
interests and cite their papers where relevant.  A PC member will easily frown
upon a paper that fails to mention their relevant work.

Increase your network and chance of publication by teaming up with colleagues.
Each of you submits as a primary author but have the other as coauthor (with
appropriate contribution).  Hopefully at least one of you gets a paper
accepted.

Know what a "Win" looks like to your advisor.  Where do they want to publish?
What do they need to move their own career forward?


{% comment %}

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
  - industry vs postdoc [r01-rate], [phd-positions]
  - consulting http://www.shawnlankton.com/2009/08/getting-a-consulting-job-0
  - Hamming

{% endcomment %}

## What can I say I learned from it all?

I learned how to frame and solve problems.  I no longer fear a research paper
or get intimidated by big fancy science.  When faced with the uncertainty of
new topic, I can come up with a research plan and milestones.  I can develop
convincing experiments.  And I can craft an efficient and comprehensive
writeup.


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
[Richard Hamming]: https://en.wikipedia.org/wiki/Richard_Hamming
[hamming-txt]: http://www.cs.virginia.edu/~robins/YouAndYourResearch.html "Richard Hamming: You and Your Research (text)"
[hamming-vid]: https://www.youtube.com/watch?v=a1zDuOPkMSw "Richard Hamming: You and Your Research (video)"
[r01-rate]: https://twitter.com/balajis/status/466395475479134208
[phd-positions]: http://www.nature.com/nbt/journal/v31/n10/full/nbt.2706.html
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
