;
; destroy by jimi
;

; instructions:
;  1 paste the alias and call
;    for your routine by step #1
;  2 paste your code to be tested
;    by step #2.  if you're testing
;    a rom call, skip this
;  3 assembler and execute

_clrScrn		=$4a82		;clear the LCD and the _textShadow
_getkey			=$55aa		;wait for a key to be pressed and store its scancode in the
					; accumulator (register a)
_Asm_Exec_RAM		=$d748		;where the program is put in memory
_putc			=$4a2b		;puts a character and advances cursor position
_newline		=$4a5f		;creates a new line
_homeup			=$4a95		;puts cursor coordinates at top left
_puts			=$4a37		;puts a zero terminated string o
#define push_all	push af \ push bc \ push de \ push hl
#define pop_all		pop hl \ pop de \ pop bc \ pop af
.org _Asm_Exec_RAM
	ld a,69				;"magic" byte...after we run the routine...we check all the registers
					; to see if they still contain this byte
	ld b,a \ ld c,a			;load up bc
	ld d,a \ ld e,a			;load up de
	ld h,a \ ld l,a			;load up hl

;==============================================
: STEP #1
; PASTE CALL TO TEST HERE...
;	e.g.)_clrScrn	=$4a82
;		call _clrScrn
;==============================================
_clrScrn	=$4a82
	call _clrScrn
;==============================================
; END TEST CALL
;==============================================
	jp continue
;==============================================
: STEP #2
; PASTE CODE TO TEST HERE...
;==============================================

;==============================================
; END CODE
;
;
; STEP #3
; ASSEMBLE AND RUN
;==============================================
continue:

		push_all
	call _clrScrn			;clears the screen and text memory
	call _homeup			;puts cursor at top left
	ld hl,destroys_text
	call _puts				;puts a zero terminated string
	call _newline			;creates a new line
		pop_all
	cp 69				;compare the a register to the magic byte
	call nz,destroys_a

	ld a,69
		push_all
		push_all
		push_all
		push_all
		push_all
		push_all

		pop_all
	cp b
	call nz,destroys_b

		pop_all
	cp c
	call nz,destroys_c

		pop_all
	cp d
	call nz,destroys_d

		pop_all
	cp e
	call nz,destroys_e

		pop_all
	cp h
	call nz,destroys_h

		pop_all
	cp l
	call nz,destroys_l

	
	ret
destroys_a:
	ld a,'A'
	jp _putc
destroys_b:
	ld a,'B'
	jp _putc
destroys_c:
	ld a,'C'
	jp _putc
destroys_d:
	ld a,'D'
	jp _putc
destroys_e:
	ld a,'E'
	jp _putc
destroys_h:
	ld a,'H'
	jp _putc
destroys_l:
	ld a,'L'
	jp _putc

destroys_text:	.db "destroys registers:",0
.end
