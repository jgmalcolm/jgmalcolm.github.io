int_addr equ $8f8f

;===============================
; Install IM 2 Grayscale Routine
;===============================

OpenGray:
	ld hl,$ce00
	ld de, SixBytes
	ld bc, 6
	ldir

	ld hl,$8e00
	ld de,$8e01
	ld (hl),$8f
	ld bc,256
	ldir

	ld hl,int_copy
	ld de,int_addr
	ld bc,int_end-int_start
	ldir

	call _runindicoff

;================================================
; Set up parameters to pass the interrupt handler
; via the alternate register set
;================================================
	di
	exx
	ld b,$3c
	ld c,0
	ld d,5
	ld e,%110110
	ld hl,UserCounter
	exx
	xor a
	ld (UserCounter),a

	ld a,$8e
	ld i,a

	
	im 2
	ei
	ret

;==================================
; Close Grayscale Handler
;==================================

CloseGray:
	im 1
	ld a,$3c
	out (0),a

	call _clrLCD

	ld hl,_plotSScreen
	ld de,_plotSScreen+1
	ld (hl), 0
	ld bc,1024
	ldir

	ld hl, SixBytes
	ld de, $ce00
	ld bc, 6
	ldir

	ret

org $8f8f
int_copy:

int_start:
	ex af,af'
	exx

	in a,(3)
	bit 1,a
	jr z,leave_int

	inc (hl)
	out (c),b

	dec d
	call z,reset_int_counter
	ld a,d
	cp 2
	call z,change_pages

leave_int:
	in a,(3)
	rra
	ld a,c
	adc a,9
	out (3),a
	ld a,$0b
	out (3),a

	ex af,af'
	exx
	ei
	reti

reset_int_counter:
	ld d,5
change_pages:
	ld a,e
	xor b


	ld b,a
	ret
int_end:

UserCounter:	.db 5
SixBytes:	.db 0,0,0,0,0,0

.end
