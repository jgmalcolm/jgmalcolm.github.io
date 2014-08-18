#include "ti86asm.inc"		;equate file
.org _asm_exec_ram		;where it starts
	call _clrLCD		;clear the screen
	ld bc,$0000			;at coordinates (0,0)
	ld (_curRow),bc		;load coodinates
	ld hl,hello_text		;address of text
	call _puts			;display it
	call _getkey		;wait for keypress
	ret				;exit program
hello_text:	.db "hello",0	;text to display
.end	