#include "ti86asm.inc"

.org _asm_exec_ram
	call _clrLCD	;clear screen

	ld bc,256*45+2	;coords (45,2)
	call pixel_on

	ld bc,256*3+62	;coords (3,62)
	call pixel_on

	ld bc,256*100+6	;coords (100,6)
	call pixel_on

	call _getkey	;wait for keypress
	jp _clrLCD	;clear screen and ret



pixel_on:
	call FindPixel	;hl=location in $fc00 (screen)
			;a=byte containing pixel at hl
			; with bit set for pixel
			; we want to change
	or (hl)		;logical op to make bit in
			; a that is set be included
			; in new a with original byte
	ld (hl),a       ;load modified byte onto screen
	ret             ;done
#include "findpixel.asm"
			;pastes the findpixel routine by clem
			; here
			;input:	(b,c)=(x,y)
			;output:hl=byte address in video memory
			;	bit set in a for offset
.end
