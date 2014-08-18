#include "ti86asm.inc"

.org _asm_exec_ram

	call _clrLCD		;clear screen (not _textShadow)
	call _homeup		;put big text cursor at top left
	ld hl,description_text
	call _puts
	call _getkey

	ld hl,data_to_copy_from	;source
	ld de,address_after_prog	;destination
	ld bc,10			;amount to copy
	ldir			;copy bc amount of bytes from hl into de

	jp _clrLCD		;jump here so _clrLCD's 'ret' instruction acts as ours also
				;same as 'call _clrLCD' then 'ret'

description_text:	.db "this will copy 10    bytes from data      within the program tothe ten bytes        following the program",0
data_to_copy_from:
	.db 1,2,3,4,5,6,7,8,9,10


address_after_prog:	$	;a "$" means "*this* address in memory" ...the address that this would be
				; at when this program is at _asm_exec_ram in memory
				;with no instructions or data after this, this is a reference to the byte
				; after your program
.end
