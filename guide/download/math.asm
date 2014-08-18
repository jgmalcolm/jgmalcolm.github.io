#include "ti86asm.inc"		;normal include file with
				; common ROM calls
#include "ti86math.inc"		;contains math function
				; equates
_formDisp	=$515b
_ioprompt	=$c324
_asap_ind	=$d623
.org _asm_exec_ram
	call _clrScrn		;clear screen & text memory
	ld bc,0*256+0		;row 0, col 0
	ld (_curRow),bc
	ld hl,string		;string to prompt with
	call input		;input number and store
				; in OP1
	call _SQRoot		;$54ac - op1 = square root
				; of op1
	jp _formDisp		;$515b - displays op1 right
				; justified big numbers
				;aka _dispOP1
input:				;14 byte routine to input
				; numbers
				;ti was nice enough to
				; give us the basics of
				; this routine
	ld de,_ioprompt		;$c324 - string storage for
				; display when prompted
	call _mov10b		;$427b - move 10 bytes from
				; hl to de
	ld a,$0d		;type of input
				;$0d - value
				:$0c - string
	ld (_asap_ind),a	;$d623 - tell ti86 what kind
				; to be inputted
	jp _exec_pg3		;$5714 - ti86 os input
				; routine of type
				; (_asap_ind) with all ti-os
				; key handler routines
				;inputted value/string stored
				; in op1
string: .db "number? ",0	;string to prompt with
.end
