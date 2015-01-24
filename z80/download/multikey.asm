#include "ti86asm.inc"
.org _asm_exec_ram
key_port	=1
	di			;disable interupts
				; so we don't get
				; that [down] [left]
				; but that slows
				; the program
	call _clrScrn		;clear screen
	call _homeup		;cursor at (0,0)
	call _flushallmenus	;get rid of all
				; menus on screen

	ld c,key_port		;store it in
				; c so we can
				; reference it faster
key_press_loop:
	ld a,%11111110		;what row to check
	out (c),a		;send it out
	in a,(c)		;get results

	bit 3,a \ call z,up	;[up]
	bit 2,a \ call z,right	;[right]
	bit 1,a \ call z,left	;[left]
	bit 0,a \ call z,down	;[down]

	ld a,%10111111		;what row to check
	out (c),a		;send it out
	in a,(c)		;get resuls

	bit 6,a			;[exit]
	jr nz,key_press_loop
exit:
	ei			;enable interupts
	call _homeup		;cursor at (0,0)
	jp _clrScrn		;clear and return
up:
		push af
	ld a,'u'
	call _putc
		pop af
	ret
right:
		push af
	ld a,'r'
	call _putc
		pop af
	ret
left:
		push af
	ld a,'l'
	call _putc
		pop af
	ret
down:
		push af
	ld a,'d'
	call _putc
		pop af
	ret
.end
