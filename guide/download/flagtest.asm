
;	flagtest by jimi malcolm

;purpose:		tests status of flags after code is run
;usage:		paste the code to test where stated
;output:		status of flags listed on screen
_clrScrn			=$4a82		;clear the LCD and the _textShadow
_getkey			=$55aa		;wait for a key to be pressed and store its scancode in the
					; accumulator (register a)
_Asm_Exec_RAM		=$d748		;where the program is put in memory
_putc			=$4a2b		;puts a character and advances cursor position
_newline			=$4a5f		;creates a new line
_homeup			=$4a95		;puts cursor coordinates at top left
_puts			=$4a37		;puts a zero terminated string o
_dispHL			=$4a33
.org _Asm_Exec_RAM
	call _homeup
	call _clrScrn
;==============================================
; PASTE CODE TO TEST HERE...
;==============================================
	ld b,2
	dec b
;==============================================
; END TEST CODE
;==============================================
		push af	;1
		push af	;2
		push af	;3
		push af	;4
		push af	;5
		push af	;6
	call c,carry_f
		pop af	;6
	call nc,no_carry
		pop af	;5
	call z,zero_f
		pop af	;4
	call nz,no_zero
		pop af	;3
	call m,m_flag
		pop af	;2
	call po,parity_odd
		pop af	;1
	call pe,parity_even
	ret
m_flag:
	ld hl,m_flag_text
	call _puts
	jp _newline
parity_odd:
	ld hl,parity_over_text
	call _puts
	jp _newline
parity_even:
	ld hl,parity_e_text
	call _puts
	jp _newline
carry_f:
	ld hl,carry_text
	call _puts
	jp _newline
no_carry:
	ld hl,no_carry_text
	call _puts
	jp _newline
zero_f:
	ld hl,zero_f_text
	call _puts
	jp _newline
no_zero:
	ld hl,no_zero_text
	call _puts
	jp _newline
m_flag_text:		.db "m set",0
parity_over_text:	.db "parity odd",0
parity_e_text:		.db "parity even",0
carry_text:		.db "carry",0
no_carry_text:		.db "no carry",0
zero_f_text:		.db "zero",0
no_zero_text:		.db "no zero",0
.end