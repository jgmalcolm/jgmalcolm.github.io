;==============================================================
; vatsrch
;  searches variable alocation
;  table for certain variable types
; in	hl - where to start searching ($bfff with
;	 ram page 7 swapped in is the
;	 start)
;	a - variable type to search for
; out	hl - the length index byte
;	 of the variable found (stored
;	 backwards! use copy_to_op1 to
;	 put name right way starting at
;	 _op1 found at bottom.)
;	a - variable type
;	d - variable type
;	bc - destroyed (how much if any
;	 vat left)
; by James Malcolm (me@jgmalcolm.com)
;==============================================================
_RAM_Page_7		=$47f3	;swap in RAM page 7 (variable alocation
				; table)
_PTEMP_END		=$d29a	;3 byte ABS pointer to end of vat
				;if vat page (ram page 7) is swapped
				; in, the second two bytes can be
				; used for 16 bit addressing
vatsrch:			;the actual routine
	call _RAM_Page_7	;swap in RAM page 7 (variable allocation
				; table)
	ld bc,(_PTEMP_END+1)	;second two bytes of ABS pointer
				; to end of vat
		push hl		;save where we're starting from
	or a			;clear the carry flag for our subtraction
				;still retain variable type # to search for
	sbc hl,bc		;since the vat is backwards, we
				; subtract the start from the end to
				; get the length of the vat stored in hl
		pop bc		;get back where we are searching
				;put it in bc temporarily
	ret c			;a carry will mean that where we want
		push bc		;save where we are in vat temporarily
				; to start is after the end of the vat
				; (but really before it in the memory
				; since the vat is backwards)
	ld b,h			;length of vat now in bc
	ld c,l
		pop hl		;get back where we are in vat
	cpdr			;compares (hl) to a, if they are equal
				; it stops, if they are unequal it
				; decreases hl and loops until bc=$0000
	ld d,a			;save what type we're searching for
	ld a,b			;get b into accumulator
	or c			;any bits set in b or c make a>=1
				;now on 3rd byte of ABS address of data
	ld a,d			;get back variable type byte
				;load doesn't affect flag status
	jr nz,good_found_one	;if bc>0000 then we found a variable
				; before running out of vat
	scf			;set carry flag like an error message
	ret			;return
good_found_one:
	dec hl			;now on 2nd byte of ABS address of data
	dec hl			;now on 1st byte of ABS address of data
	dec hl			;now we're on the trash byte
	dec hl			;now on length index byte of name!
	ret



;==============================================================
; copy_to_op1
;  turns variable name string
;  that's stored backwards, forwards
;  and stores it starting at de
; in	output of vatsrch!
;	hl - start of variable name index
;	de - where to store name
; out	de - start of variable
;	 name (length indexed). put in
;	 hl if you want to use _vputsn (after you put
;	 length in b and increase de) or _putps
;	hl - byte after variable name
;	b - $00
;	a - (de)
; by James Malcolm (me@jgmalcolm.com)
;==============================================================
copy_to_op1:
		push de
	ld b,10			;variables have a 10
				; byte max name length
copy_to_op1_loop:
	ld a,(hl)		;get character
	ld (de),a		;store character
	inc de			;increase destination
	dec hl			;decrease source
	djnz copy_to_op1_loop
		pop de
	ret
