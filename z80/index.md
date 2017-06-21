---
title: z80 game development
layout: default
---

This is a collection of tutorials on developing games in z80 assembler for the
TI calculators.  While focused on the TI86, much of this applies to any
z80-based TI calculator: TI85, TI83/+, TI84/+, TI82.

- [Beginner](#beginner) - getting started with assembler code, registers, arithmetic, flags, and memory
- [Intermediate](#intermediate) - more details on the beginner topics
- [Graphics](#graphics) - manipulating pixels and grayscale
- [Advanced](#advanced) - ports, hidden TI-OS features
- [Opcodes](#opcodes) - listing of all z80 opcodes (numeric or alphabetic)
- [Variables](#variables) - manipulate TI-OS variables
- [Menus](#menus) - creating native TI-OS menus
- [Design](#design) - planning and game design, writing clean code
- [Downloads](download/download) - tools, examples, algorithms

![xkcd: 1996](1996.png "xkcd #768: '1996'")


## Beginner

- [Number Bases](beginner/numb) - Learn how to understand and convert
  between the different number systems such as binary and hexadecimal. Make
  your calculator do all the work.
- [z80 Processor](beginner/z80p) - History and specifications of the z80
  processor. What's really behind the games.
- [TI86 Specs](beginner/ti86) - Basic information about the TI86, ROM
  versions, and the LCD.
- [Format and Compiling](beginner/form) - Start coding. Get the necessary
  tools to get you on your way. Walk through creating your first program
  and running it.
- [Oh, No! It Crashed!](beginner/ohno) - What to do when it freezes up on
  you. A step-by-step diagnosis.
- [TI-BASIC versus Asm](beginner/ti-b) - A simple chart to show you
  equivalent tasks in z80 asm and the old TI-BASIC.
- [Aliases](beginner/alia) - Equates and include files. Download the
  hottest include files around. Make your own equates.
- [Registers](beginner/regi) - How to store and manipulate values.
- [Instructions](beginner/inst) - Start working up your own
  programs. Learn the basic syntax of assembler instructions. A great place to
  reference all those little mnemonics and what they do.
- [Flags and Conditions](beginner/flag) - `if` statements.
- [Math](beginner/math) - Learn the basics of simple math routines like
  multiplying, dividing, adding, and subtracting.
- [Two's Compliment](beginner/twos) - Negative numbers and how to use
  them.



## Intermediate

- [Logical Operators](intermediate/logi) - Introduction to `and`, `or`,
  and `xor`. How to mask out bits and control binary data.
- [Miscellaneous Instructions](intermediate/misc) - These don't fit in
  anywhere? `neg`, `scf`, and others!
- [All the Flags](intermediate/allt) - Besides the zero and carry flags,
  there are four others! What do they all do? Come find out!
- [Restart Commands](intermediate/rstc) - Faster `call`s with the help of
  these one byte instructions used for some of the most frequent ROM calls.
- [Memory and Pages of It](intermediate/memo) - Dive into the
  memory of your calculator. What is Consecutive Addressing and how to
  reference addresses in memory. Explore some safe areas to store data at!
- [Variables](intermediate/vari) - Start off storing user input and data
  like high scores and such.
- [The Stack](intermediate/stac) - Ever heard of \"Last On, First Off\"?
  Save register pairs and recall their values later with `push` and `pop`!
- [Tables and Arrays](intermediate/tabl) - The famous `for` loop used in
  recursion. Take advantage of the `ix` and `iy` register pairs for lists with
  an intro into matrices!
- [Simulated 16-bit Addition](intermediate/simu) - A faster method of
  adding `a` to `hl`. In time crunch areas, this beats conventional methods.
- [Random Numbers](intermediate/rand) - Need a random number? This is the
  place for you! Take your pick of different routines, all designed to
  give you a different number each time.
- [TI's ROM Calls](intermediate/romc) - Why draw up your own routine when
  TI's already got a ton. Use their calls for printing text, checking
  keypresses, clearing the screen, and much much more!
- [Getkey](intermediate/getkey) - Get user input in a flash with
  `_GetKey`! This routine gives you the ability to respond to certain key
  presses. Here you'll find charts filled with key press codes with their
  equates, a handy reference!
- [Program Counter, Stack Pointer](intermediate/pcsp) - Two fundamental
  registers the z80 uses to keep track of executing code.
- [Text Display](intermediate/text) - Print text on the screen in an
  instant with your choice of several routines printing everything from
  individual characters to entire paragraphs. Learn how to print in standard
  or small text with a look at how to create your own
  [custom fonts](advanced/font).
- [Down-Left Bug](intermediate/down) - Why does the calculator freeze when
  you press down-left?



## Graphics

Pixel manipulation and sprite animation. Line-by-line walk throughs of the
most popular graphics routines.

- [The Screen](intermediate/scre) - Introduction to the LCD, Video Memory,
and how the pixels are stored in memory.
- [Find Pixel](intermediate/find) - Find where on the screen pixels are
  supposed to be from manipulating the coordinates.
- [Pixel Manipulation](intermediate/pixe) - Setting, reseting, and testing
  pixels using Find Pixel.
- [Sprites](intermediate/spri) - Printing small images on the screen.
- [Tile Maps](intermediate/tile) - Draw game levels on the screen using
  compact level data.
- [Grayscale Graphics](advanced/gray) - Blend black and white to make
  gray. Check out this line-by-line analysis of one of the hottest Grayscale
  routines out there.



## Advanced

- [More Registers](advanced/inde) - Now you have even more with the
  addition of a whole hidden set of registers banks. Also, learn about the
  Index and Refresh Registers.
- [Reading Keys from Port](advanced/read) - Don't wait up for that slow
  `_GetKey`, scan for keys in an instant with Port 0. You can always count on
  the Ports for quick results. Also included, a handy reference table with key
  bitmasks for every key.
- [Assembler Directives](advanced/asse) - Customize your source code in a
  flash with macros. Reference just about every directive available for the
  TASM Assembler.
- [On-Off](advanced/onof) - Turn your calculator On or Off in a flash
  using the ports. Even put it in low power mode to conserve energy. Take a
  peek at how TI-OS turns itself On and Off.
- [Shift and Rotate](advanced/shif) - Move bits left or right within a
  byte. This handy reference provides examples and graphical representations
  of what each instruction does!
- [Entry Stack](advanced/entr) - Access and manipulate the user input
  history.
- [Morphic Code](advanced/morp) - Programs that edit themselves, what a
  dream! Preload code with values, manipulate routines, and more.
- [All the Ports](advanced/allp) - Communicate with the z80's hardware
  behind the scenes. Change the Video Screen address, adjust the contrast,
  change the power mode, etc.
- [Square Root Programs](advanced/squa) - Take command of the many common
  tasks of TI-OS such as Parsing, Tokenizing, `_GetKey`, Graphing, and much
  much more! TI-OS lets you run your own programs before or after it performs
  these tasks. Step in and manipulate data before TI-OS gets it.
- [System Flags](advanced/syst) - Want a complete listing of TI-OS' flags?
  You got it! This reference gives you everything you need to know about
  customizing the options of TI-OS from Graph Methods to Operand calculations.
- [Auto Power Down](advanced/apd) - Like a screen saver, TI-OS will shut
  down after inactivity. Learn how to control this process and use it to your
  advantage.
- [Sound](advanced/soun) - How to produce mono sound with a few small
  parts. These step-by-step instructions walk you through the process of
  building speakers and then programming sound into your games. You can even
  convert Wave files.
- [Simulating Key Presses](advanced/simu) - Kind of like macros, have the
  TI86 think you're pushing keys and respond to them when you're not even
  touching the calculator.
- [Fonts](advanced/font) - Create your own fonts for TI-OS to for
  everything.
- [Interrupt](advanced/inte) - Create your own routine to be run about 200
  times a second in the background of regular code.
- [Interrupt Mode 1](advanced/im1i) - Run a routine 200 times a second
  to perform background tasks.
- [Interrupt Mode 2](advanced/im2i) - Run a routine randomly chosen from a
  jump table 200 times a second.



## Opcodes

- [Overview](opcodes/opcodes)
- [Sorted by value](opcodes/opcodesB)
- [Sorted by name](opcodes/opcodesN)


## Variables

- [TI86 Variable Manipulation](variables/ti86) - Manipulating data behind
  TI-OS' back. What are the Operator Registers?
- [Variable Name Format](variables/vari) - How to set-up variables' names
  in the OP Registers. Learn about the Variable Type byte with the included
  reference chart and numerous full examples.
- [Creating Variables](variables/crea) - You can generate just about any
  variable type you want through these asm calls.
- [_FindSym](variables/findsym) - The basis for *all* variable manipulation,
  `_FindSym` finds variable data addresses fast. A must for all who want to
  work with TI-OS variables!
- [Absolute Addressing](variables/abso) - A 24-bit address? That's right!
  Since there's more than 64 kilobytes of memory, you need to be familiar with
  TI's method of absolute addressing. It's used *all* the time with TI-OS
  variables.
- [Messing with Data](variables/mess) - This is the meat of the topic: How
  to manipulate the data within the TI-OS Variables! Through step-by-step
  examples, you'll learn how to edit everything from Lists and Complex
  Matrices to Real Numbers and Strings! You can even download source code for
  Tokenized, Un-Tokenized, and Assembler Programs.
- [Binary Coded Decimal](variables/bcd) - Format Floating Point decimal
  numbers. Work with exponents, Complex and Real numbers, and negative
  numbers. Examples are illustrated in tables and code snippets!
- [VAT Searches](variables/vats) - Learn the methodology behind the
  Variable Allocation Table and how to search through it. You can even walk
  through the line-by-line analysis of one of the hottest search routines out
  there! Learn how to make your own shell.
- [External Levels](variables/exte) - Access and execute other variables
  on the calculator as level data, plug-ins, and much more. Customizable,
  full-featured programs are just around the corner.
- [OP_ Math](variables/op_m) - Get an understanding of how to perform
  Floating Point math with the Operator Registers. You can even check out TI's
  own routine to input strings or values.

## Menus

Create full featured, native TI-OS Menu Trees. Have one on the bottom like the
Custom Menu or branch that one out into other Menu Trees. Create a menu with
conversions, constants, program names, and more.

- [Executing Menus](menus/exec) - The place to start, here you'll learn
  about two routines that tie up the whole process. It's as simple as loading
  a pointer!
- [Creating Menus](menus/crea) - Here's where the full customization of
  the menus comes into play. Create multiple menus with Paste, Branch, or
  Execute Items!
- [ROM Menus](menus/romm) - Take advantage of TI's own menu
  structures. Use them as patches for your own structures!



## Design

- [The Design Process](design/desi) - Take a walk through designing a
  game. Go step-by-step as you create a well designed game that will last for
  ages. Great design is essential for great games.
- [Clean Code](design/clea) - A must read for all programmers, this
  section gives details and examples of what to do and what *not* to do. These
  key points will change the way you program.


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

This content was formerly hosted as "The Guide" on
[TI-Calc.org](//ticalc.org).
