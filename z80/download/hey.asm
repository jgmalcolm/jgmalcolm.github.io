#include "ti86asm.inc"
.org _asm_exec_ram

	call _clrLCD	;line 4 - alias _clrLCD=$4a7e
			;clears screen

	call _homeup	;put cursor at top left of
			; screen

	ld hl,text_to_print
			;load hl with address of text
			; to print
	call _puts	;print string on screen

	call _getkey	;wait for keypress
	call _clrLCD	;alias again!
			;clears screen
	ret		;return from program
text_to_print:	.db "hey",$00
			;text to print with a zero
			; at the end to tell the
			; ti86 to stop printing
.end
