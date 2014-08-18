---
title: Developing for the TI86 z80
layout: default
---

# Beginner

- [Number Bases](beginner/numb.htm) - Learn how to understand and convert
  between the different number systems such as binary and hexadecimal. Make
  your calculator do all the work.
- [z80 Processor](beginner/z80p.htm) - History and specifications of the z80
  processor. What's really behind the games.
- [TI86 Specs](beginner/ti86.htm) - Basic information about the TI86 and its
  ROM versions. Also some info on the LCD.
- [Format and Compiling](beginner/form.htm) - Start coding. Get the necessary
  tools to get you on your way. Walk through creating your very first program
  and running it.
- [Oh, No! It Crashed!](beginner/ohno.htm) - What to do when it freezes up on
  you. A step-by-step diagnosis.
- [TI-BASIC versus Asm](beginner/ti-b.htm) - A simple chart to show you
  equivalent tasks in z80 asm and the old TI-BASIC.
- [Aliases](beginner/alia.htm) - Equates and include files. Download the
  hottest include files around. Make your own equates.
- [Registers](beginner/regi.htm) - How to store and manipulate values.
- [Instructions](beginner/inst.htm) - Start working up your own
  programs. Learn the basic syntax of assembler instructions. A great place to
  reference all those little mnemonics and what they do.
- [Flags and Conditions](beginner/flag.htm) - `If` statements.
- [Math](beginner/math.htm) - Learn the basics of simple math routines like
  multiplying, dividing, adding, and subtracting.
- [Two's Compliment](beginner/twos.htm) - Negative numbers and how to use
  them.



# Intermediate

- [Logical Operators](intermediate/logi.htm) - Introduction to `and`, `or`,
  and `xor`. How to mask out bits and control binary data.
- [Miscellaneous Instructions](intermediate/misc.htm) - These don't fit in
  anywhere? `Neg`, `scf`, and others!
- [Graphics](intermediate/grap.htm) - Your one stop reference for pixel
  manipulation and sprite animation. Line-by-line walk throughs of the most
  popular graphics routines.
- [All the Flags](intermediate/allt.htm) - Besides the zero and carry flags,
  there are four others! What do they all do? Come find out!
- [Restart Commands](intermediate/rstc.htm) - Faster `call`s with the help of
  these one byte instructions used for some of the most frequent ROM calls.
- [Memory and Pages of It](intermediate/memo.htm) - Literally delve into the
  memory of your calculator. What is Consecutive Addressing and how to
  reference addresses in memory. Explore some safe areas to store data at!
- [Variables](intermediate/vari.htm) - Start off storing user input and data
  like high scores and such.
- [The Stack](intermediate/stac.htm) - Ever heard of \"Last On, First Off\"?
  Save register pairs and recall their values later with `push` and `pop`!
- [Tables and Arrays](intermediate/tabl.htm) - The famous `For` loop used in
  recursion. Take advantage of the `ix` and `iy` register pairs for lists with
  an intro into matrices!
- [Simulated 16-bit Addition](intermediate/simu.htm) - A faster method of
  adding `a` to `hl`. In time crunch areas, this beats conventional methods.
- [Random Numbers](intermediate/rand.htm) - Need a random number? This is the
  place for you! Take your pick of several different routines, all designed to
  give you a different number each time.
- [TI's ROM Calls](intermediate/romc.htm) - Why draw up your own routine when
  TI's already got a ton. Use their calls for printing text, checking
  keypresses, clearing the screen, and much much more!
- [Getkey](intermediate/_getkey.htm) - Get user input in a flash with
  `_GetKey`! This routine gives you the ability to respond to certain key
  presses. Here you'll find charts filled with key press codes with their
  equates, a handy reference!
- [Program Counter, Stack Pointer](intermediate/pcsp.htm) - Two fundamental
  registers the z80 uses to keep track of executing code.
- [Text Display](intermediate/text.htm) - Print text on the screen in an
  instant with your choice of several routines printing everything from
  individual characters to entire paragraphs. Learn how to print in standard
  or small text with a look at how to create your own
  [custom fonts](advanced/font.htm).
- [TI-BASIC versus Asm](intermediate/ti-b.htm) - A simple chart to show you
  equivalent tasks in z80 asm and the old TI-BASIC.
- [Tile Maps](intermediate/tile.htm) - Creating scenes from simple tiles.
- [Sprites](intermediate/spri.htm) - Small images at the core of any game.
- [Down-Left Bug](intermediate/down.htm) - Why does the calculator freeze when
  you press down-left?
- [The Screen](intermediate/scre.htm) - Manipulating the screen directly in
  video memory.



# Advanced

- [More Registers](advanced/inde.htm) - Now you have even more with the
  addition of a whole hidden set of registers banks. Also, learn about the
  Index and Refresh Registers.
- [Reading Keys from Port](advanced/read.htm) - Don't wait up for that slow
  `_GetKey`, scan for keys in an instant with Port 0. You can always count on
  the Ports for quick results. Also included, a handy reference table with key
  bitmasks for every key.
- [Grayscale Graphics](advanced/gray.htm) - Blend black and white to make
  gray. Check out this line-by-line analysis of one of the hottest Grayscale
  routines out there.
- [Assembler Directives](advanced/asse.htm) - Customize your source code in a
  flash with macros. Reference just about every directive available for the
  TASM Assembler.
- [On-Off](advanced/onof.htm) - Turn your calculator On or Off in a flash
  using the ports. Even put it in low power mode to conserve energy. Take a
  peek at how TI-OS turns itself On and Off.
- [Shift and Rotate](advanced/shif.htm) - Move bits left or right within a
  byte. This handy reference provides examples and graphical representations
  of what each instruction does!
- [Morphic Code](advanced/morp.htm) - Programs that edit themselves, what a
  dream! Preload code with values, manipulate routines, and more.
- [All the Ports](advanced/allp.htm) - Communicate with the z80's hardware
  behind the scenes. Change the Video Screen address, adjust the contrast,
  change the power mode, etc.
- [User Routines](advanced/user.htm) - Run your code like interrupts, fonts,
  Silent Link, etc. Create seemless customization of your TI86 with these
  integrated features.
- [Square Root Programs](advanced/squa.htm) - Take command of the many common
  tasks of TI-OS such as Parsing, Tokenizing, `_GetKey`, Graphing, and much
  much more! TI-OS lets you run your own programs before or after it performs
  these tasks. Step in and manipulate data before TI-OS gets it.
- [System Flags](advanced/syst.htm) - Want a complete listing of TI-OS' flags?
  You got it! This reference gives you everything you need to know about
  customizing the options of TI-OS from Graph Methods to Operand calculations.
- [Auto Power Down](advanced/apd.htm) - Like a screen saver, TI-OS will shut
  down after inactivity. Learn how to control this process and use it to your
  advantage.
- [Sound](advanced/soun.htm) - How to produce mono sound with a few small
  parts. These step-by-step instructions walk you through the process of
  building speakers and then programming sound into your games. You can even
  convert Wave files.
- [Simulating Key Presses](advanced/simu.htm) - Kind of like macros, have the
  TI86 think you're pushing keys and respond to them when you're not even
  touching the calculator.


# z80 Opcodes

- [Overview](opcodes/opcodes.htm)
- [Sorted by byte value](opcodes/opcodesB.htm)
- [Sorted by name](opcodes/opcodesN.htm)


# TI-OS Variables

- [TI86 Variable Manipulation](variables/ti86.htm) - Manipulating data behind
  TI-OS' back. What are the Operator Registers?
- [Variable Name Format](variables/vari.htm) - How to set-up variables' names
  in the OP Registers. Learn about the Variable Type byte with the included
  reference chart and numerous full examples.
- [Creating Variables](variables/crea.htm) - You can generate just about any
  variable type you want through these asm calls.
- [_FindSym](variables/_fin.htm) - The basis for *all* variable manipulation,
  `_FindSym` finds variable data addresses fast. A must for all who want to
  work with TI-OS variables!
- [Absolute Addressing](variables/abso.htm) - A 24-bit address? That's right!
  Since there's more than 64 kilobytes of memory, you need to be familiar with
  TI's method of absolute addressing. It's used *all* the time with TI-OS
  variables.
- [Messing with Data](variables/mess.htm) - This is the meat of the topic: How
  to manipulate the data within the TI-OS Variables! Through step-by-step
  examples, you'll learn how to edit everything from Lists and Complex
  Matrices to Real Numbers and Strings! You can even download source code for
  Tokenized, Un-Tokenized, and Assembler Programs.
- [Binary Coded Decimal](variables/bcd.htm) - Format Floating Point decimal
  numbers. Work with exponents, Complex and Real numbers, and negative
  numbers. Examples are illustrated in tables and code snippets!
- [Floating Point Stack](variables/floa.htm) - Save and recall entire Operator
  Registers just like with `push` and `pop`. You can even push entire lists
  and matrices.
- [VAT Searches](variables/vats.htm) - Learn the methodology behind the
  Variable Allocation Table and how to search through it. You can even walk
  through the line-by-line analysis of one of the hottest search routines out
  there! Learn how to make your own shell.
- [External Levels](variables/exte.htm) - Access and execute other variables
  on the calculator as level data, plug-ins, and much more. Customizable,
  full-featured programs are just around the corner.
- [OP_ Math](variables/op_m.htm) - Get an understanding of how to perform
  Floating Point math with the Operator Registers. You can even check out TI's
  own routine to input strings or values.



## Dedicated to those who taught me
<A HREF="mailto:assets@eden.rutgers.edu">Dux Gregis</A>,
<A HREF="mailto:mja@algonet.se">Jimmy M&aring;rdell</A>,
<A HREF="mailto:JayEll64@aol.com">Jay Hellrungen</A>,
<A HREF="mailto:luezma@netscape.net">Patrick Davidson</A>,
<A HREF="mailto:ComAsYuAre@aol.com">Jonah Cohen</A>,
<A HREF="mailto:kirkmeyer@bigfoot.com">Kirk Meyer</A>,
<A HREF="mailto:david@acz.org">David Phillips</A>,
<A HREF="mailto:bailela@charlie.cns.iit.edu">Alan Bailey</A>,
<A HREF="mailto:kazmet@sonic.net">Adrian Mettler</A>
