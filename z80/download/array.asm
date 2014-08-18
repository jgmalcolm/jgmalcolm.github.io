a_size		=$f200	;array size
array_start	=$f201	;start of element data
e_size		=1	;element size in bytes
#define array(element)	array_start+((element-1)*e_size)
	;each element is two bytes
	;when we want the 2nd element, we usually
	; put 'array(2)' but since 0 is the first
	; element, we subtract 1 from what we
	; requested
#include "ti86asm.inc"
.org _asm_exec_ram

;let's start loading the array with
; values
	ld hl,array(1)	;return the address of the
			; first element in de
	ld ix,a_size	;size/length counter address
	ld (ix),$00	;initialize counter to $00
			; because we haven't stored
			; anything in it yet
			;ix register pair can be used
			; just like hl
	ld de,e_size	;load de with the size
			; of each element so we
			; can move from one element
			; to the next
	ld b,26		;there are 26 characters
			; in the alphabet...i hope
	ld a,'a'	;letter to start with
initialize_loop:
	ld (hl),a	;load element
	inc a		;increment letter value
	inc (ix)	;increment counter value
	add hl,de	;add where we are to
			; the length of each element
			; to get the next element's
			; address
	djnz initialize_loop

	call _clrScrn	;clear the screen
	call _homeup	;put cursor at top left

;now let's print the word "stupid" letter by letter

	ld hl,array(19)		;'s'
	call print_element

	ld hl,array(20)		;'t'
	call print_element

	ld hl,array(21)		;'u'
	call print_element

	ld hl,array(16)		;'p'
	call print_element

	ld hl,array(9)		;'i'
	call print_element

	ld hl,array(4)		;'d'
	call print_element

	call _getkey	;wait for keypress
	jp _clrScrn	;clear screen and return
;print_element prints the character in the
; array at address held by hl
print_element:
	ld a,(hl)	;get that element's value
	jp _putc	;print character and return
.end
