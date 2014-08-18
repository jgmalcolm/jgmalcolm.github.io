#include "ti86asm.inc"

.org _asm_exec_ram

;loads ram page 4 into both the RAM and ROM areas in memory

RAM_page_4	=4
ROM_port	=
RAM_port	=

	ld a,RAM_page_4		; load a with the page number
	out (ROM_port),a	; put it out the rom port
	out (RAM_port),a	; put it out the ram port
	ret			; done

.end
