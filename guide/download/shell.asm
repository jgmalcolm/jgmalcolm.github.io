;
;	shell v2 by jimi malcolm
;

;i'm putting all the aliases i used right here so you can look at them without having to search far
;i always find it nice when other people do this too
;it's also nice because you don't have to have the same include files as the person who made the program
_RAM_Page_7		=$47f3		;swap in RAM page 7...the variable allocation table (v.a.t.) where the names of all the variables on the calculator are listed
_jforcecmdnochar	=$409c		;exit to homescreen without crashing because
					; of misused pushes/pops..don't disp "Done"
_homeup			=$4a95		;cursror at top left
_RunIndicOff		=$4ab1		;turn off the busy indicator at the top right of screen
_Asm_Exec_RAM		=$d748		;where the program is put in memory
_clrScrn		=$4a82		;clear the LCD and the _textShadow
_getkey			=$55aa		;wait for a key to be pressed and store its scancode in the accumulator (register a)
_HtimesL		=$4547		;hl=h*l  [note:h cannot be $00 or it will not work...i think]
_exec_assembly		=$5730		;execute the assembly program whose is in op1
start_of_vat_addr	=$bfff		;where the end of the swapped in RAM page is
					;when page 7 is swapped in, this is the start of the vat
_PTEMP_END		=$d29a		;3 byte ABS pointer to end of vat
					;if vat page (ram page 7) is swapped in, the second two bytes can be used for 16 bit addressing
_penCol			=$c37c		;cursor coordinates for menu text column
_penRow			=$c37d		;cursor coordinates for menu text row
_vputmap		=$4aa1		;put a variable width (menu size) character on the screen
_vputs			=$4aa5		;put a null terminated (zero terminated) string on screen in menu text
_vputsn			=$4aa9		;put a length indexed string on screen in menu text

num_progs		=$f200
cur_prog		=$f201
cur_page		=$f202
cur_vat			=$f203
prog_list		=$f205

program_type		=$12
RAM_VAT_page		=7
RAM_Port		=6
textflags		=5
textInverse		=3
;	scancodes of keys checked for
kExit			=$07
kEnter			=$06
kMore			=$0b
kUp			=$03
kDown			=$04

.org _Asm_Exec_RAM

restart_everything:
	call _RunIndicOff			;turn off busy indicator on top right
	call _clrScrn			;clear LCD and _textShadow

	ld hl,shell_text			;address of shell text string
	ld bc,(256*0)+54			;row 0...column 54
	ld (_penCol),bc
	call _vputs			;print the null terminated string (zero terminated)

	ld hl,$fc00			;start of video memory
	ld b,$70				;7 rows of 16 bytes ($10 bytes)
invert_top_row_loop:
	ld a,(hl)				;get byte to change
	cpl				;invert all bits (0's become 1's and 1's become 0's)
	ld (hl),a				;put it back on the screen
	inc hl				;get ready for next byte on screen (in video memory)
	djnz invert_top_row_loop
restart_search_at_beginning:
	ld hl,start_of_vat_addr		;start of vat in memory...where we start looking
	ld (cur_vat),hl			;save where we are going to start

restart_search:
	xor a				;ld a,$00
	ld (num_progs),a			;zero the number of programs found so far
clear_display_area:
	;xor a				;a is still zeroed from last 'xor a'
	ld hl,$fc80			;one row down from where our title bar is
	ld (hl),a				;zero the first byte to be copied 
	ld de,$fc81			;next byte
	ld bc,$380			;number of bytes from $fc80 to the end of the video memory
	ldir				;loads (hl) into (de) and increases both
					;it keeps doing this until bc=$0000
					;this is a good method of clearing large spaces in memory because after each loop, the byte being copied was zeroed in the last loop
	ld bc,(256*8)+1			;row 8...column 1
					;this is where we are going to start displaying the program names
	ld (_penCol),bc

	ld de,prog_list			;where we are going to store all the prog names
					;10 bytes for each name stored
search_vat:
		push de
	call _RAM_Page_7
		pop de
	ld bc,(_PTEMP_END+1)		;second two bytes of ABS pointer to end of vat
	ld hl,(cur_vat)			;where we last left off searching (if this is the first time through...it is at the beginning [$bfff])
	xor a				;clear the carry flag for our subtraction
	sbc hl,bc				;since the vat is backwards, we subtract the start from the end to get the length of the vat stored in hl
	jp c,end_of_vat_reached		;a carry will mean that where we want to start is after the end of the vat (but really before it in the memory since the vat is backwards)
	ld b,h				;length of vat now in bc
	ld c,l
	ld hl,(cur_vat)			;where we last left off searching (if this is the first time through...it is at the beginning [$bfff])
	ld a,program_type			;what to search for
	cpdr				;compares (hl) to a, if they are equal it stops, if they are unequal it decreases hl and loops until bc=$0000
	jp po,end_of_vat_reached		;same as when we reach end of vat
					;the parity odd flag will be set when bc reaches zero
					;now on 3rd byte of ABS address of data
	dec hl				;now on 2nd byte of ABS address of data
	dec hl				;now on 1st byte of ABS address of data
	dec hl				;now we're on the trash byte
	dec hl				;now on length index byte of name
	ld (cur_vat),hl			;save where we are currently in the vat
					;we need to perform a little check to see if it's a system variable name
	dec hl				;now we're on the first byte of the name
	ld a,(hl)				;the system variable names that we need to watch out for are one byte being either '#' or '!'
	cp '!'				;check if it's the first name we're looking for
	jp z,system_variable		;if it is...just continue searching and pay no attention to it
	cp '#'				;check if it's the second name we're looking for
	jp z,system_variable		;if it is...just continue searching and pay no attention to it
	inc hl				;now we're back on the length index byte of the name
		push de			;save the address we're at on the program name list for displaying the name
		push de			;save it again for our copy of the name loop
	ld b,(hl)				;load the length of the name into b for a copy loop
	inc b				;increase it so we can also account for copying the length index byte
store_name_loop:
	ld a,(hl)				;load a byte from the vat
	ld (de),a				;put the byte into the list
	inc de				;increase our destination address of where in the prog list to store
	dec hl				;decrease our source address in the vat (because the vat is stored backwards)
	djnz store_name_loop
		pop de			;get back the address of where we started storing in the prog list (where the length index byte of the name is)

	ld a,(de)				;get the length index byte into a (number of letters in the name)
	ld b,a				;put the number of letters into b for a djnz loop
display_name_loop:			;display the name one letter at a time
	inc de				;put at start of routine so we start out on the next letter each loop (or since we just started the loop we're on the first letter because we increased it from the length index byte address)
	ld a,(de)				;get the letter
		push de			;save where we are in displaying the name because _vputmap destroys de
	call _vputmap			;put character value of a on screen in menu text and advance cursor coordinates for menu text
		pop de			;get back address of where we are in name
	djnz display_name_loop		;keep looping
		pop de			;get back where we started storing the name
move_to_next_prog_space:
		push hl			;save where we are in the vat because we need it to add something
	ld hl,10				;each program name is 10 bytes long
	add hl,de				;add 10 to where we started storing the name
	ex de,hl				;put the new address from hl into de
		pop hl			;get back where we were searching in the vat
	ld hl,_penCol			;now we need to update the menu text coordinates for the next prog to be written
	ld (hl),1				;column 1 for next time
	inc hl				;now we're on the _penRow
	ld a,(hl)				;get the current row
	add a,7				;add seven to the current row to go down one line
	ld (hl),a				;update the new _penRow one line down
	ld hl,num_progs			;how many progs have been found so far
	inc (hl)				;increase how many programs found so far because we just found one more
system_variable:
	ld hl,num_progs			;how many progs have been found so far  (i know this is not needed)
	ld a,(hl)				;get number of programs found into a
	cp 8				;we can only have a maximum of 8 programs displayed at a time
	jr nz,search_vat			;we haven't hit 8 programs yet so keep searching
end_of_vat_reached:
;	ld (cur_vat),hl			;save where we are currently in the vat
	ld hl,cur_page
	ld b,(hl)
	inc (hl)
	ld a,(num_progs)
	or a				;have we found any programs yet? (we will always find shell.86p!)
	jr nz,display_programs		;we've found as many programs as we can find (but not 8 yet)
	or b				;if we've gotten this far, a must be $00
					;that means we haven't found any programs
	jp nz,restart_search_at_beginning	;if we're on a page other than 0 (page 1), then we restart searching from the beginning of the vat
display_programs:
	xor a				;ld a,$00
refresh_screen:
	ld (cur_prog),a			;zero the number of programs found now
	call invert			;invert the first program's name on the screen so it looks like it's highlighted

key_check_loop:
	call _getkey			;wait for a key to be pressed
	cp kExit
	jr z,exit			;if [exit] was pressed, clear the screen and exit
					;we use _clrScrn's 'ret' instruction for ours by jumping to it...this saves 1 byte compared to 'call _clrScrn \ ret'
	cp kEnter
	jr z,execute_program		;if [enter] was pressed, execute the currently highlighted program
	cp kMore
	jp z,restart_search
	sub kUp				;would be zero if a was 3 (the value of kUp)
	jr z,up				;if [up] was pressed, move highlighter bar up one if possible
	dec a				;will now be zero if scancode in a was 4 (value of kDown) to begin with
	jr nz,key_check_loop		;if scancode wasn't kDown...redo the search for keys
down:					;since [down] was pressed, move highlighter bar down one if possible
	call invert			;we want to invert the current highlighter bar...this in effect clears the highlighter bar
					;we will make a new one after we're made changes to the current highlighter bar position
	ld a,(cur_prog)			;which program is currently highlighted
	ld hl,num_progs
	ld b,(hl)
	dec b
	cp b
	jr nz,down_down
	xor a
	jr refresh_screen
down_down:
	inc a
	jr refresh_screen
exit:					;i had to sneak this in somewhere
	call _clrScrn
	call _homeup
	jp _jforcecmdnochar
up:
	call invert			;we want to invert the current highlighter bar...this in effect clears the highlighter bar
					;we will make a new one after we're made changes to the current highlighter bar position
	ld a,(cur_prog)			;which program is currently highlighted
	or a				;is it at zero (actually the first program on the screen)
					;like cp $00
	jr z,put_at_bottom
	dec a				;go up one
	jr refresh_screen
put_at_bottom:
	ld a,(num_progs)			;amount of progs on screen
	dec a				;because we start counting bar slots at zero
	jr refresh_screen
execute_program:
	ld a,(cur_prog)
	ld h,10				;ten bytes for each program name in program list
	ld l,a
	call _HtimesL
	ld de,prog_list			;we want the offset of the program's name in the prog_list
	add hl,de				;we add the two to get the offset
	dec hl				;we want to copy the name into op1 so we can use _findsym (rst 10h)
					;_findsym needs the length indexed name without the type byte...the _mov10toOP1 (rst 20h) will move 10 bytes at hl to op1
					;we want it to copy a miscellaneous byte into (op1) and then the length indexed byte with name starting at op1+1
					;this makes hl point to a miscellaneous byte right before the length index byte for copying
	rst 20h				;copy 10 bytes starting at hl into op1
	call _exec_assembly		;execute the assembly program whose name is in op1
	jp restart_everything		;the assembly program we just ran probably destroyed the screen and everything so we start our program over from scratch at the top
invert:
	ld a,(cur_prog)
	ld h,$70				;ten bytes for each program name in program list
	ld l,a
	call _HtimesL
	ld de,$fc80
	add hl,de
	ld de,$10-8
	ld b,7				;seven rows
invert_loop:
		push bc
	call invert_inside_loop
		pop bc
	add hl,de
	djnz invert_loop
	ret
invert_inside_loop:
	ld b,8
invert_inside_loop_loop:
	ld a,(hl)
	cpl
	ld (hl),a
	inc hl
	djnz invert_inside_loop_loop
	ret
shell_text:	.db "shell",0		;name of shell
.end


invert:
	ld a,(cur_prog)
	ld h,$70				;ten bytes for each program name in program list
	ld l,a
	call _HtimesL
	ld de,$fc80
	add hl,de
	ld de,$10-8
	ld b,7				;seven rows
invert_loop:
		push bc
	call invert_inside_loop
		pop bc
	add hl,de
	djnz invert_loop
	ret
invert_inside_loop:
	ld b,8
invert_inside_loop_loop:
	ld a,(hl)
	cpl
	ld (hl),a
	inc hl
	djnz invert_inside_loop_loop
	ret
.end