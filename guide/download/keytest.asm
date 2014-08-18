#include "ti86asm.inc"

.org _asm_exec_ram
redo:
	call _clrLCD
	ld (_penCol),bc		;bc=$0000 after _clrLCD because
				; of its ldir
	ld hl,waiting_string	;"waiting..."
	call _vputs
	call _getkey		;get keypress
		push af		;save keycode
	ld hl,256*8+0		;row 8,col 0
	ld (_penCol),hl
	ld hl,keycode_string	;"keycode is: "
	call _vputs
		pop af
	call disp_hex_a_m	;display scancode
	call _getkey
	cp kExit
	jr nz,redo		;try it again
	call _homeup		;cursor coords at top left
	jp _clrScrn		;exit if kExit was pressed
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
	jp _vputmap
disp_nibble_now:
	jp _vputmap
waiting_string:	.db "waiting...",0
keycode_string:	.db "keycode is: $",0

.end
