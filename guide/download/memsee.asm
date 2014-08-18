;=============================
; for debugging purposes:
#define BREAK	call _getkey \ call _clrScrn \ jp _jforcecmdnochar
_jforcecmdnochar	=$409c
;=============================
#include "ti86asm.inc"
page0_vputmap		=$3ae2		;since i want to be using
					; other ROM pages than $0d (the one
					; with _vputmap on it), i will
					; just call the routine directly
					; on ROM page 0...the problem is
					; that this could cause errors with
					; different ROM versions
					;this is designed for ROM v1.6
_jforcecmdnochar	=$409c
_ldhlind		=$4010		;hl=(hl)
ROM_port		=5
RAM_port		=6
num_options		=5
cur_select	=_textShadow
patched_address	=cur_select+1		;address of rom call _vputmap on rom
					; page 0 specific to user's ti86 rom
_ldhlind		=$4010
_HtimesL		=$4547		;hl=h*l  [note:h cannot be $00 or it will not work...i think]
_asapvar		=$d6fc	;name of the currently
				; running program (this
				; one!)
_set_abs_src_addr	=$4647
_set_abs_dest_addr	=$5285
_set_mm_num_bytes	=$464f
_mm_ldir		=$52ed

#define call_prot_(address)	push af \ in a,(ROM_port) \ ld (saved_ROM_page),a \ ld a,$0d \ out (ROM_port),a \ pop af \ call address \ push af \ ld a,(saved_ROM_page) \ out (ROM_port),a \ pop af
	;long thing that basically saves current pages, swaps in
	; ones for ROM calls, and then puts back origninal pages
	;does not slow down program at all really!
.org _asm_exec_ram
	call patch_rom_vputmap		;need to copy address of call
					; _vputmap on rom page $0d
					; so we don't have to switch
					; pages all the time
					;i designed this with rom v1.6
					;see above
	call _runIndicOff
	call _flushallmenus
	call _clrScrn			;clear _textShadow which we use
	call load_saved_data		;recall address/rom/ram stuff
very_top:
	ld hl,menu_text			;what menu text to put
	call menus			;put menu at bottom
	ld hl,(saved_addr)		;start off at address $0000
					;just like every other hexeditor
disp_screen:
		push hl			;save where we start as top of screen
					;everything displayed is relative to
					; top line
		push hl			;temp save for dividers
dividers:				;does clearing and drawing all
					; in one!  no need to _clrLCD
	ld de,$fc00			;where to put first
	ld b,64-7
dividers_loop:
		push bc
	ld hl,row			;predone row of bytes
	ld bc,$10			;one row
	ldir
		pop bc
	djnz dividers_loop
	
	ld hl,$0000
	ld (_penCol),hl			;row 0, col 0
	ld b,8				;display 8 rows of info
		pop hl			;get back after dividers
disp_row:
		push bc			;save row counter
		push hl			;save for ascii representation
	call disp_hex_hl_m
	ld a,18
	ld (_penCol),a
	ld b,4				;display 2 bytes at address hl
disp_bytes_at_hl:
		push hl			;save current addr
		push bc			;save loop
	ld a,(hl)
	call disp_hex_a_m
		pop bc			;get back loop
	ld hl,_penCol			;get current column
	inc (hl)			;increase column
	inc (hl)			;increase column
		pop hl			;get back current addr
	inc hl
	djnz disp_bytes_at_hl

ascii_representation_hl:
	ld hl,_penCol
	ld a,58				;start ascii at column 58
	ld (hl),a
		pop hl			;get current addr for ascii representation
	ld b,4				;4 letters to display
ascii_disp_loop:
	ld a,(hl)			;get letter
	inc hl				;increase to next letter
	cp $d6				;is it a carriage return? don't want that
	jr nz,isn't_carriage_return
	ld a,$d0			;give it a new value (little black square)
isn't_carriage_return:
	cp 230				;no caracters after 231 can be displayed
					; in menu text
	jr c,under_231			;a is below 231
	ld a,$d0			;give it a new value
under_231:
	or a
	jr nz,not_zero			;zero displays funny so we want to bipass it
	ld a,$d0
not_zero:
		push bc
	call_prot_(page0_vputmap)		;put letter
		pop bc
	djnz ascii_disp_loop		;loop

		push hl
	ld hl,_penCol
	ld (hl),0
	inc hl
	ld a,7
	add a,(hl)
	ld (hl),a
		pop hl
		pop bc			;get row counter
	djnz disp_row
		pop hl			;get back where we started on screen
keyloop:
		push hl			;save current address
	call_prot_(_getkey)		;destroys hl
		pop hl			;get current address
	cp kRight	\ jr z,inc1
	cp kLeft	\ jr z,dec1
	cp kUp		\ jr z,decrease
	cp kDown	\ jr z,increase
	cp kF1		\ jr z,dec100h
	cp kF2		\ jr z,inc100h
	cp kF3		\ jp z,menu_time
	cp kF4		\ jr z,dec1000h
	cp kF5		\ jr z,inc1000h
					;need a better way to get
					; to the address input routine
					; like from a menu
	cp kExit	\ jr nz,keyloop
	ld a,$0d			;could be on different ROM page
	out (ROM_port),a		;need to put back on page $0d
					; for _clrScrn and _homeup to work!
	call save_data			;save address, ram/rom pages
	call _clrScrn			;clears screen
	jp _homeup			;puts cursor position at top left
;	jp _jforcecmdnochar		;gets rid of the "Done"
					;nice trick but only for shells really
					; because you don't want your program
					; exiting the shell which this command
					; will do!
					;this thing fixes any miss pushes/pops
					; and returns to homescreen no
					; matter what!
inc1:
	inc hl
	jr go_up_to_top
dec1:
	dec hl
	jr go_up_to_top
increase:
	ld de,$0010
	add hl,de
	jr go_up_to_top
decrease:
	ld de,-$0010
	add hl,de
	jr go_up_to_top
inc100h:
	ld de,$0100
	add hl,de
	jr go_up_to_top
dec100h:
	ld de,-$0100
	add hl,de
	jr go_up_to_top
inc1000h:
	ld de,$1000
	add hl,de
	jr go_up_to_top
dec1000h:
	ld de,-$1000
	add hl,de
go_up_to_top:
	jp disp_screen
disp_hex_hl_m:
	ld a,h
	call disp_hex_a_m
	ld a,l
	;lead right into disp_hex_a_m

disp_hex_a_m:
	ld c,a				;save away a
	rrca \ rrca \ rrca \ rrca	;rotate a one nibble to right
					;%xxxxyyyy ->%yyyyxxxx
	and $0f				;only want bottom nibble
	call disp_nibble
	ld a,c
	and $0f
disp_nibble:
	add a,'0'
	cp '9'+1
	jr c,disp_nibble_now
	sub '9'+1-'a'
	jp page0_vputmap
disp_nibble_now:
	jp page0_vputmap
;
;	patch_rom_vputmap
;
patch_rom_vputmap:
	ld hl,(_vputmap+1)
	ld (patched_address),hl
	ret
;
;	draw menu at bottom of screen with strings
;
menus:					;writes over everything there
		push hl			;save the start of the menu text
					; to print
					;no need to _clrLCD
	ld de,$ff90			;where to start
	ld b,8
menus_loop:
		push bc
	ld hl,menu_row			;predone row of bytes
	ld bc,$10			;one row
	ldir
		pop bc
	djnz menus_loop

	set textInverse,(iy+textFlags)	;write text on black background
		pop hl			;get back the saved address of the
					; text to print
	ld b,5				;display 5 menu strings
menu_text_loop:
	ld d,(hl)
	inc hl
	ld e,(hl)
	inc hl
	ld (_penCol),de
	call_prot_(_vputs)		;destroys a,l
	djnz menu_text_loop
	res textInverse,(iy+textFlags)	;normal black text on white
					; background
	ret
goto_addr:
	call input_addr_start		;get address in (saved_addr)
					; or else don't modify address
					; already in (saved_addr)
	jp very_top
search:
		push hl			;save current address
	call input_addr_start
;do something with hl (what we just got inputted)
		pop hl			;save what we just got back
	jp nc,very_top			;carry was set if [exit] was
					; pressed
menu_time:
	ld (saved_addr),hl		;save current addr
	call_prot_(_clrLCD)
	ld hl,menu_time_title_text	;title "options"
	call vput_string
	ld hl,_penRow
	inc (hl)			;move down a little on the
					; screen for actual options'
					; text
invert_top_row:
	ld hl,$fc00			;start of video memory
	ld b,$70			;7 rows of 16 bytes ($10 bytes)
invert_top_row_loop:
	ld a,(hl)			;get byte to change
	cpl				;invert all bits (0's become 1's and 1's become 0's)
	ld (hl),a			;put it back on the screen
	inc hl				;get ready for next byte on screen (in video memory)
	djnz invert_top_row_loop
disp_table_text:
	ld hl,table_text
	ld b,num_options
disp_table_text_loop:
;		push bc		;_vputs doesn't destroy b
		push hl
	ld hl,_penCol
	ld (hl),12		;col 0
	inc hl
	ld a,7
	add a,(hl)		;row current+7 (down 1 line)
	ld (hl),a
		pop hl
	call_prot_(_vputs)	;can't use jp _vputs because
				; we might not have rom page $0d
				; swapped in at moment (that's the
				; page this call's on so it would
				; probably execute gibberish
				; and crash)
;		pop bc		;_vputs doesn't destroy b
	djnz disp_table_text_loop
display_selections:
	xor a				;ld a,$00
refresh_screen:
	ld (cur_select),a		;zero the number of programs found now
refresh_no_load:
	call invert			;invert the first program's name on the screen so it looks like it's highlighted
plain_refresh:
;========================
; display state of memory pages
;========================
	ld hl,ROM_text
	call vput_string		;put "ROM="
	in a,(ROM_port)			;get current ROM page
	call disp_hex_a_m		;put page
	call vput_string		;put "RAM="
	in a,(RAM_port)			;get current RAM page
	and $07
	call disp_hex_a_m		;put page
;========================
;
;========================
key_check_loop:
	call_prot_(_getkey)		;wait for a key to be pressed
	cp kExit
	jp z,very_top			;if [exit] was pressed, clear the screen and exit
					;we use _clrScrn's 'ret' instruction for ours by jumping to it...this saves 1 byte compared to 'call _clrScrn \ ret'
	cp kEnter
	jr z,execute_select		;if [enter] was pressed, execute the currently highlighted program
	sub kUp				;would be zero if a was 3 (the value of kUp)
	jr z,menu_up			;if [up] was pressed, move highlighter bar up one if possible
	dec a				;will now be zero if scancode in a was 4 (value of kDown) to begin with
	jr nz,key_check_loop		;if scancode wasn't kDown...redo the search for keys
menu_down:				;since [down] was pressed, move highlighter bar down one if possible
	call invert			;we want to invert the current highlighter bar...this in effect clears the highlighter bar
					;we will make a new one after we're made changes to the current highlighter bar position
	ld a,(cur_select)		;which program is currently highlighted
	cp num_options-1		;amount of possible selections-1!
	jr nz,down_down
	xor a
	jr refresh_screen
down_down:
	inc a
	jr refresh_screen
menu_up:
	call invert			;we want to invert the current highlighter bar...this in effect clears the highlighter bar
					;we will make a new one after we're made changes to the current highlighter bar position
	ld a,(cur_select)		;which program is currently highlighted
	or a				;is it at zero (actually the first program on the screen)
					;like cp $00
	jr z,put_at_bottom
	dec a				;go up one
	jr refresh_screen
put_at_bottom:
	ld a,num_options-1		;amount of things-1
					; because we start counting
					; at 0
	jr refresh_screen
execute_select:				;i took this routine from my
					; program shell.asm and modified it
					; and then took the jump table routine
					; from my other program addict.asm and
					; modified it
	ld a,(cur_select)
	ld h,2
	ld l,a
	call_prot_(_HtimesL)
	ld de,selection_addr_table
	add hl,de
	call_prot_(_ldhlind)
	ld (selection_addr_call+1),hl	;called morphic code
selection_addr_call:			; because you change it after
	jp $0000			; time of assembly
					;because i jump to
					; these addresses, these
					; addresses have to think
					; of themselves as calls
incROM:
	ld c,ROM_port
	in a,(c)
	inc a
	jr do_for_ROM
decROM:
	ld c,ROM_port
	in a,(c)
	dec a
do_for_ROM:				;universal for ROM port
	and $0f
	out (c),a
	jr indirect_plain_refresh
incRAM:
	ld c,RAM_port
	in a,(c)
	inc a
	jr do_for_RAM
decRAM:
	ld c,RAM_port
	in a,(c)
	dec a
do_for_RAM:				;universal for RAM port
	and $07
	set 6,a
	out (c),a
indirect_plain_refresh:			;save one byte by jumping
					; here instead of using
					; another absolute jump
	ld c,ROM_port
	ld hl,saved_ROM_page		;address of saved pages
	in a,(c)
	ld (hl),a
	inc hl				;now at saved_RAM_port
	inc c				;now at port 6 (RAM)
	in a,(c)
	ld (hl),a
	jp plain_refresh
invert:
	ld a,(cur_select)
	ld h,$70				;ten bytes for each program name in program list
	ld l,a
	call_prot_(_HtimesL)
	ld de,$fc81
	add hl,de
	ld b,7				;7 pixel rows high
	ld de,$10-7			;just enough to complete the row
invert_loop:
		push bc
	ld b,7				;how wide in bytes
invert_half_loop:
	ld a,(hl)
	cpl
	ld (hl),a
	inc hl
	djnz invert_half_loop
		pop bc
	add hl,de
	djnz invert_loop
	ret
;
;
;	vput_string
;
;	input	hl points to string
;		string format: .db row,col,"string",$00
;
vput_string:
	ld b,(hl)
	inc hl
	ld c,(hl)
	inc hl
	ld (_penCol),bc
	call_prot_(_vputs)	;can't use jp _vputs because
				; we might not have rom page $0d
				; swapped in at moment (that's the
				; page this call's on so it would
				; probably execute gibberish
				; and crash)
	ret
;
;	input address routine
;
;
input_addr_start:
	call_prot_(_clrLCD)
	ld (_penCol),bc			;bc=$0000 after _clrLCD
	ld hl,input_text
	call_prot_(_vputs)
	ld hl,$0000			;start inputting at $0000
input_addr:
	ld bc,(256*00)+21
	ld (_penCol),bc
	call disp_hex_hl_m
			;display what we currently have
		push hl	;save the address we are working with
	call_prot_(_getkey)	;destroys a,de,hl
	cp kExit	\ jr z,input_exit
	cp kEnter	\ jr z,input_done
			;we'll pop off hl before exiting
	cp k0
	jr z,goofup
	ld hl,key_codes_end-1
			;end of table
			;we are destroying the
			; addr of byte we are
			; working with but
			; we have it pushed (saved)
	ld bc,end-start
			;length of table+2
			;to account to end and beginning
	cpdr		;search from hl to hl+bc
			; for byte matching a
		pop hl	;get address we are working with
	jp po,input_addr
			;if parity is odd, that means
			; that the search ended without
			; finding a match (bc=$0000)
			; so just try it again from the
			; top!
			;po flag can only be tested with
			; absolute jump (sucks!)
	add hl,hl	;rotate hl one nibble to left
	add hl,hl	;  /
	add hl,hl	; /
	add hl,hl	;/
	ld d,$00
	ld e,c
	add hl,de	;add offset's value into right
			; most nibble
	jr input_addr
goofup:
		pop hl	;pop off saved address
			;we saved it because _getkey
			; destroys it
	add hl,hl	;since 0 was just pushed, we
	add hl,hl	; want to just shift over
	add hl,hl	; hl one nibble to left
	add hl,hl	; and act as if nothing
	jr input_addr	; happened
input_done:
		pop hl	;pop off saved address
	ld (saved_addr),hl
			;save address as current address
	scf		;carry means address is final
			;no carry means exit was pressed
	ret
input_exit:
		pop hl
		pop af	;get this call off
	jp menu_time



;
;
;	data
;
row:	.db %00000000,%00000000,%10000000,%00000000,%00000000,%00000000,%00000000,%10000000
	.db %00000000,%00000000,%00100000,%00000000,%00000000,%00000000,%00000000,%00000000
	;this is one row of the screen to make the dividers fast
menu_row:
	.db %11111111,%11111111,%11111111,%10111111,%11111111,%11111111,%10111111,%11111111
	.db %11111111,%11101111,%11111111,%11111111,%11111011,%11111111,%11111111,%11111111
menu_text:	.db 57,3,"-100h",0
		.db 57,28,"+100h",0
		.db 57,51,"options",0
		.db 57,77,"-1000h",0
		.db 57,103,"+1000h",0
input_text:	.db "input=",0
;
;	
;
key_codes:
start:
	.db k0,k1,k2,k3		;$01 to $04
	.db k4,k5,k6,k7		;$05 to $08
	.db k8,k9,kLog,kSin	;$09 to $0c
	.db kCos,kTan,kExpon	;$0d to $0f
	.db kLn			;$10
end:
key_codes_end:
		;it is in the order of value
		;search routine just checks to see if
		; keypress is in this chart and if it is,
		; it stores that as a nibble of the
		; addr and then adds whatever
		; to get the ascii representation of
		; that letter for displaying
table_text:
	.db "increase ROM",0
	.db "decrease ROM",0
	.db "increase RAM",0
	.db "decrease RAM",0
	.db "goto",0
	.db "search",0
menu_time_title_text:	.db 0,53,"options",0	;row 0, col 0
ROM_text:		.db 8,101,"rom=",0
RAM_text:		.db 15,101,"ram=",0
selection_addr_table:			;by using a table it is easy
					; to add and remove things
					; whenever i want
					; once i get past 8 though, i
					; have to make it possible
					; to change to the next page
					;this feature also makes it possible
					; to have things like external
					; plug-ins later on but that might
					; be stupid for a simple program like
					; this
	.dw incROM
	.dw decROM
	.dw incRAM
	.dw decRAM
	.dw goto_addr
	.dw search
;====================================
; loads last address, rom/ram pages
load_saved_data:
	ld c,ROM_port			;port 5 (ROM)
	ld hl,saved_ROM_page		;get start of data
	ld a,(hl)			;get saved value
	and $0f				;mask off extras
	out (c),a			;swap it in
	inc c				;now port 6 (RAM)
	inc hl				;now at RAM value
	ld a,(hl)
	and $07				;mask off extras
	set 6,a				;tell it that it's RAM!
	out (c),a			;swap it in
	ret
;====================================
; saves address, rom/ram pages before
; exiting program
save_data:
	ld hl,_asapvar			;name of current
					; program running
	rst 20h				;copy to OP1
	rst 10h				;_findsym
	ld a,b				;returns bde as prog data
	ld hl,data_start-_asm_exec_ram+2+2
					;offset in this program
					; for start
					; of saved game data
					;2 bytes for prog length
					;2 bytes for asm
					; identifier bytes
	add hl,de			;hl=pointer to data
					; in original prog 
	adc a,$00			;in case we overlapped
					; pages if carry was set
					; in previous
					; instruction...this
					; will add 1 to a
					; else...it adds 0 to a
	call _set_abs_dest_addr		;set that as the absolute
					; destination address
					; to copy to
	sub a				;no absolute addressing now
	ld hl,data_start		;*get data from here
	call _set_abs_src_addr		;set that as the absolute
					; source address to copy
					; from
	ld hl,data_end-data_start	;*number of bytes to save
	call _set_mm_num_bytes		;set that as the number
					; of bytes to copy
	jp _mm_ldir			;perform absolute address
					; data block copy 
data_start:
saved_addr:	.dw $0000		;save the last pages we are at
saved_ROM_page:	.db 0
saved_RAM_page:	.db 0
data_end:
.end
