#include "ti86asm.inc"
table_width	=3
.org _asm_exec_ram
	call _clrScrn
	call _homeup

	ld de,1*256+2	;row 1, col 2
	ld hl,table
	call get_cell
	call _putc
	call _getkey
	call _homeup
	jp _clrScrn

;input: d=row
;	e=col
;	hl=address of 3x3 table
;output:a=value
get_cell:
	dec e		;decrease columns
			; since $00 is 1st
			; column
	sub a		;initialize to $00
	ld b,d		;get row #
	dec b
	jr z,no_row_mult
row_multiply_loop:
	add a,table_width	;width of table (3)
	djnz row_multiply_loop
no_row_mult:
	add a,e		;add in col #
	add a,l
	ld l,a
	adc a,h
	sub l
	ld h,a
	ld a,(hl)
	ret
table:
	.db 'a','b','c'
	.db 'd','e','f'
	.db 'g','h','i'
.end