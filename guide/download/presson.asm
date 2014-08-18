#include "ti86asm.inc"
on_port		=3
key_port	=1
.org _asm_exec_ram

	call _runindicoff	;turn off run indicator

	call startup		;clear scren and
				; put cursor at top left
loop:
	ld a,' '
	call _putc		;clear top left
	call _homeup		;redo cursor position

	in a,(on_port)		;get status
	bit 3,a			;on's bit..reset if down
	call z,pressing		;[on] is being held
				; down now
	ld a,%10111111		;now check for [exit]
	out (key_port),a	;send it out
	in a,(key_port)		;get results
	bit 6,a \ jr nz,loop	;if it wasn't pressed
				; then loop again
startup:
exit:
	call _homeup		;cursor at top left
	jp _clrScrn		;clear screen
pressing:
	ld a,'o'		;character to print
	jp _putc		;print 'o' and return
.end