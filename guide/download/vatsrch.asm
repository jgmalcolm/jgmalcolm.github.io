#include "ti86asm.inc"

.org _asm_exec_ram

	call _homeup		;put cursor at top left
	call _clrScrn		;clear screen

	ld a,$12		;$12 - program
				;$0c - string
	ld hl,$bfff		;absolute start of vat
				;the routine automatically
				; swaps in ram page 7 (the
				; vatiable allocation table)
				; so this is a valid address
	ld b,3			;search three times so
				; we get the third program on
				; the calculator
loop:
		push bc		;save loop counter
	call vatsrch		;search starting at hl for program
		pop bc		;get back loop counter
	djnz loop


	ld de,_OP1		;where we want to store
				; name at
	call copy_to_op1	;copy backwards vat name to
				; op1 the right way
	ex de,hl		;we need it in hl so we
				; can display it
	call _putps		;display length indexed string
				; at hl
	call _getkey		;wait for keypress
	jp _clrScrn		;clear screen and quit

#include "vatsrch.inc"		;the include file with all the
				; vat routines used:
				;  - vatsrch
				;  - copy_to_op1
.end