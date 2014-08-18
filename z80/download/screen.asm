#include "ti86asm.inc"

.org _asm_exec_ram

	ld hl,$fc00	;start of video memory
	ld a,%10000000	;since screen is based on pixels/bits
			; it's best to use binary
			; representation so you
			; can picture stuff in
			; your head
	ld (hl),a	;write to video memory
	ret		;return from program

.end
