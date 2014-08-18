;==========================================================
; Create String routine
; by Andreas Finne <a_finne@hotmail.com>
; date: 10 Dec 1999
;
; Size: 40 bytes
;
; Input:
; de = length of data
; a  = length of name <=8
; hl = pointer to filename
; bc = pointer to start of data (Must be on ram page 0 or 1)
;==========================================================

CreateString:
	push bc						;Save the pointer to start of data
	push de						;Save the length of data twice
	push de
	ld de,_OP1+1				;Point de to OP1+1
	ld (de),a					;Load length of string name to OP1+1
	ld c,a						;
	xor a						;Load length of string name to bc
	ld b,a						;
	inc de						;de = OP1+2
	ldir						;Copy the name into OP1+2->
	pop hl						;hl = length of data
	call _createstrng			;create a string with namelength=OP1+1, name=OP1+2->, hl=number of bytes
	ld a,b						;_createstrng returns the ABS address of the created string to bde
	ex de,hl					;bde to ahl
	call _ahl_plus_2_pg3		;Skip size bytes of the string (ahl=ahl+2)
	call _set_abs_dest_addr		;Set destination address of _mm_ldir to ahl
	pop hl						;hl = length of data
	xor a						;a=0
	call _set_mm_num_bytes		;Number of bytes to copy = ahl
	pop hl						;hl = pointer to start of data
	call _set_abs_src_addr		;Set source address of _mm_ldir to ahl
	call _mm_ldir				;Copy _mm_num_bytes from _abs_src_addr to _abs_dest_addr
	jp _ram_page_1				;_mm_ldir changes ram pages, this loads page #1 and returns
