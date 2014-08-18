#include "ti86asm.inc"
_altlfontptr	=$d2ed	;large font pointer
_altsfontptr	=$d2f0	;small font pointer
_asapvar		=$d6fc
.org _asm_exec_ram

_altlfontptr	=$d2ed	;large font pointer
_altsfontptr	=$d2f0	;small font pointer
_asapvar		=$d6fc
install:
	ld hl,_asapvar
	rst 20h
	rst 10h
	ld a,b
	ld hl,font_data-_asm_exec_ram+4
	add hl,de
	adc a,$00
	ld (_AltLFontPtr),a
	ld (_AltLFontPtr+1),hl
	ld a,%00000001
	xor (iy+35)	;flips bit  0 at iy+35
	ld (iy+35),a
	ret
font_data:
	.db $6f		;type of font (large)
	.db (end_font_data-begin_font_data)/8
			;# of characters in font
			;each is 8 bytes so
			; we take the total space
			; used and divide by
			; 8 to get how many
			; fonts we are doing
begin_font_data:
	.db ' '
	.db %00000
	.db %00000
	.db %00000
	.db %00000
	.db %00000
	.db %00000
	.db %00000

	.db 223		;cursor that blinks usually
	.db %11111
	.db %10001
	.db %10001
	.db %10001
	.db %10001
	.db %10001
	.db %11111

	.db 'x'
	.db %00000
	.db %00000
	.db %11011
	.db %11011
	.db %01110
	.db %11011
	.db %11011

	.db 'y'
	.db %00000
	.db %00000
	.db %11011
	.db %11011
	.db %11111
	.db %00111
	.db %11110

	.db '1'
	.db %01110
	.db %11110
	.db %01110
	.db %01110
	.db %01110
	.db %11111
	.db %11111

	.db '2'
	.db %11110
	.db %11111
	.db %00111
	.db %01110
	.db %11100
	.db %11111
	.db %11111

	.db '3'
	.db %11110
	.db %11111
	.db %00111
	.db %11110
	.db %00111
	.db %11111
	.db %11110

	.db '4'
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %01111
	.db %00011
	.db %00011

	.db '5'
	.db %11111
	.db %11111
	.db %11000
	.db %11110
	.db %00011
	.db %11111
	.db %11110

	.db '6'
	.db %01110
	.db %11100
	.db %11110
	.db %11111
	.db %11011
	.db %11111
	.db %01110

	.db '7'
	.db %11111
	.db %11111
	.db %11011
	.db %00011
	.db %00111
	.db %00110
	.db %00110

	.db '8'
	.db %01110
	.db %11111
	.db %11011
	.db %01110
	.db %11011
	.db %11111
	.db %01110

	.db '9'
	.db %01110
	.db %11111
	.db %11011
	.db %11111
	.db %01111
	.db %00111
	.db %01110

	.db '0'
	.db %11111
	.db %11111
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %11111

	.db 'a'
	.db %00000
	.db %01110
	.db %00011
	.db %01111
	.db %11011
	.db %11111
	.db %01111

	.db 'b'
	.db %11000
	.db %11000
	.db %11110
	.db %11111
	.db %11011
	.db %11111
	.db %01110

	.db 'c'
	.db %00000
	.db %00000
	.db %01110
	.db %11111
	.db %11000
	.db %11111
	.db %01110

	.db 'd'
	.db %00011
	.db %00011
	.db %01111
	.db %11111
	.db %11011
	.db %11111
	.db %01110

	.db 'e'
	.db %00000
	.db %00000
	.db %01110
	.db %11011
	.db %11111
	.db %11000
	.db %01111

	.db 'f'
	.db %00110
	.db %01110
	.db %01100
	.db %11110
	.db %11110
	.db %01100
	.db %01100

	.db 'g'
	.db %00000
	.db %01110
	.db %11011
	.db %01111
	.db %00011
	.db %11111
	.db %11110

	.db 'h'
	.db %11000
	.db %11000
	.db %11110
	.db %11111
	.db %11011
	.db %11011
	.db %11011

	.db 'i'
	.db %00110
	.db %00000
	.db %00110
	.db %00110
	.db %00110
	.db %00110
	.db %00110

	.db 'j'
	.db %00110
	.db %00000
	.db %00110
	.db %00110
	.db %00110
	.db %11110
	.db %11110

	.db 'k'
	.db %00000
	.db %11000
	.db %11011
	.db %11111
	.db %11110
	.db %11111
	.db %11011

	.db 'l'
	.db %01110
	.db %00110
	.db %00110
	.db %00110
	.db %00110
	.db %00110
	.db %00110

	.db 'm'
	.db %00000
	.db %00000
	.db %11110
	.db %11111
	.db %11111
	.db %11111
	.db %10101

	.db 'n'
	.db %00000
	.db %00000
	.db %11110
	.db %11111
	.db %11011
	.db %11011
	.db %11011

	.db 'o'
	.db %00000
	.db %00000
	.db %01110
	.db %11011
	.db %11011
	.db %11011
	.db %01110

	.db 'p'
	.db %00000
	.db %00000
	.db %01110
	.db %11011
	.db %11110
	.db %11000
	.db %11000

	.db 'q'
	.db %00000
	.db %01110
	.db %11011
	.db %01111
	.db %00011
	.db %00011
	.db %00011

	.db 'r'
	.db %00000
	.db %00000
	.db %00111
	.db %01111
	.db %01100
	.db %01100
	.db %01100

	.db 's'
	.db %00000
	.db %00000
	.db %01111
	.db %11100
	.db %01110
	.db %00111
	.db %11110

	.db 't'
	.db %00000
	.db %00110
	.db %01111
	.db %00110
	.db %00110
	.db %00110
	.db %00110

	.db 'u'
	.db %00000
	.db %00000
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %11111

	.db 'v'
	.db %00000
	.db %00000
	.db %11011
	.db %11011
	.db %11011
	.db %11011
	.db %01110

	.db 'w'
	.db %00000
	.db %00000
	.db %10101
	.db %11111
	.db %11111
	.db %11111
	.db %11011

	;x and y are at the top

	.db 'z'
	.db %00000
	.db %00000
	.db %11111
	.db %00011
	.db %01110
	.db %11000
	.db %11111

	.db 'A'
	.db %01110
	.db %11111
	.db %11011
	.db %11111
	.db %11011
	.db %11011
	.db %11011

	.db 'B'
	.db %01110
	.db %11111
	.db %11011
	.db %11110
	.db %11011
	.db %11111
	.db %11110

	.db 'C'
	.db %01110
	.db %11111
	.db %11011
	.db %11000
	.db %11011
	.db %11111
	.db %01110

	.db 'D'
	.db %11110
	.db %11111
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %11110

	.db 'E'
	.db %11111
	.db %11111
	.db %11000
	.db %11110
	.db %11000
	.db %11111
	.db %11111

	.db 'F'
	.db %11111
	.db %11111
	.db %11000
	.db %11110
	.db %11110
	.db %11000
	.db %11000

	.db 'G'
	.db %01111
	.db %11111
	.db %11000
	.db %11111
	.db %11011
	.db %11111
	.db %01110

	.db 'H'
	.db %11011
	.db %11011
	.db %11111
	.db %11111
	.db %11011
	.db %11011
	.db %11011

	.db 'I'
	.db %01111
	.db %01111
	.db %00110
	.db %00110
	.db %00110
	.db %01111
	.db %01111

	.db 'J'
	.db %00011
	.db %00011
	.db %00011
	.db %00011
	.db %11011
	.db %11111
	.db %01110

	.db 'K'
	.db %11011
	.db %11011
	.db %11110
	.db %11111
	.db %11011
	.db %11011
	.db %11011

	.db 'L'
	.db %11000
	.db %11000
	.db %11000
	.db %11000
	.db %11000
	.db %11111
	.db %11111

	.db 'M'
	.db %10001
	.db %11011
	.db %11111
	.db %11111
	.db %11111
	.db %11111
	.db %11011

	.db 'N'
	.db %10011
	.db %11011
	.db %11111
	.db %11111
	.db %11111
	.db %11011
	.db %11001

	.db 'O'
	.db %01110
	.db %11111
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %01110

	.db 'P'
	.db %01110
	.db %11111
	.db %11011
	.db %11111
	.db %11110
	.db %11000
	.db %11000

	.db 'Q'
	.db %01110
	.db %11111
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %01111

	.db 'R'
	.db %01110
	.db %11111
	.db %11011
	.db %11111
	.db %11110
	.db %11011
	.db %11011

	.db 'S'
	.db %01111
	.db %11111
	.db %11100
	.db %01110
	.db %00111
	.db %11111
	.db %11110

	.db 'T'
	.db %01111
	.db %01111
	.db %00110
	.db %00110
	.db %00110
	.db %00110
	.db %00110

	.db 'U'
	.db %11011
	.db %11011
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %01110

	.db 'V'
	.db %11011
	.db %11011
	.db %11011
	.db %11111
	.db %01110
	.db %01110
	.db %00100

	.db 'W'
	.db %10001
	.db %10101
	.db %11111
	.db %11111
	.db %11111
	.db %11111
	.db %11011

	.db 'X'
	.db %11011
	.db %11011
	.db %11111
	.db %01110
	.db %11111
	.db %11011
	.db %11011

	.db 'Y'
	.db %11011
	.db %11011
	.db %11111
	.db %11111
	.db %01110
	.db %01110
	.db %01110

	.db 'Z'
	.db %11111
	.db %11111
	.db %00111
	.db %01110
	.db %11100
	.db %11111
	.db %11111

	.db Lroot
	.db %01111
	.db %01111
	.db %01100
	.db %01100
	.db %11100
	.db %11100
	.db %01100

	.db '/'
	.db %00000
	.db %00100
	.db %00000
	.db %11111
	.db %11111
	.db %00000
	.db %00100

	.db '*'
	.db %00000
	.db %00000
	.db %00000
	.db %00110
	.db %00110
	.db %00000
	.db %00000

	.db '-'
	.db %00000
	.db %00000
	.db %00000
	.db %11111
	.db %11111
	.db %00000
	.db %00000

	.db '+'
	.db %00000
	.db %01110
	.db %01110
	.db %11111
	.db %11111
	.db %01110
	.db %01110

	.db '('
	.db %00111
	.db %01111
	.db %11100
	.db %11000
	.db %11100
	.db %01111
	.db %00111

	.db ')'
	.db %11100
	.db %11110
	.db %00111
	.db %00011
	.db %00111
	.db %11110
	.db %11100

	.db '['
	.db %00111
	.db %00111
	.db %00110
	.db %00110
	.db %00110
	.db %00111
	.db %00111

	.db ']'
	.db %11100
	.db %11100
	.db %01100
	.db %01100
	.db %01100
	.db %11100
	.db %11100

	.db '{'
	.db %00011
	.db %00110
	.db %00110
	.db %01100
	.db %00110
	.db %00110
	.db %00011

	.db '}'
	.db %11000
	.db %01100
	.db %01100
	.db %00110
	.db %01100
	.db %01100
	.db %11000

	.db Lcomma
	.db %00000
	.db %00000
	.db %00000
	.db %01110
	.db %01110
	.db %00110
	.db %01100

	.db LInverse
	.db %00011
	.db %00011
	.db %11011
	.db %00011
	.db %00011
	.db %00000
	.db %00000

	.db LStore
	.db %00000
	.db %01100
	.db %01110
	.db %11111
	.db %11111
	.db %01110
	.db %01100

	.db LCaret
	.db %01110
	.db %11111
	.db %11011
	.db %00000
	.db %00000
	.db %00000
	.db %00000

	.db LExponent
	.db %00000
	.db %00000
	.db %00000
	.db %10111
	.db %10101
	.db %10101
	.db %10111

	.db LNeg
	.db %00000
	.db %00000
	.db %00111
	.db %00111
	.db %00000
	.db %00000
	.db %00000

	.db LSquare
	.db %11100
	.db %01100
	.db %11000
	.db %11100
	.db %00000
	.db %00000
	.db %00000

	.db '.'
	.db %00000
	.db %00000
	.db %00000
	.db %00000
	.db %01110
	.db %01110
	.db %01110

	.db '='
	.db %00000
	.db %11111
	.db %11111
	.db %00000
	.db %11111
	.db %11111
	.db %00000

	.db LColon
	.db %01110
	.db %01110
	.db %01110
	.db %00000
	.db %01110
	.db %01110
	.db %01110

	.db LSemiColon
	.db %01110
	.db %01110
	.db %00000
	.db %01110
	.db %01110
	.db %00110
	.db %01100

	.db LPi
	.db %00000
	.db %00000
	.db %11111
	.db %11111
	.db %01011
	.db %01011
	.db %01011

	.db LSupX
	.db %11011
	.db %01110
	.db %11011
	.db %00000
	.db %00000
	.db %00000
	.db %00000

	.db LNE
	.db %00011
	.db %11111
	.db %11111
	.db %00110
	.db %11111
	.db %11111
	.db %01100

	.db 227		;insert thingy
	.db %10000
	.db %10000
	.db %10000
	.db %10000
	.db %10000
	.db %10000
	.db %10000

	.db 228		;2nd insert thingy
	.db %10000
	.db %10110
	.db %11111
	.db %10110
	.db %10110
	.db %10110
	.db %10000

	.db 229		;A insert thingy
	.db %10000
	.db %10000
	.db %10111
	.db %10101
	.db %10111
	.db %10101
	.db %10000

	.db 230		;a insert thingy
	.db %10000
	.db %10010
	.db %10001
	.db %10011
	.db %10101
	.db %10011
	.db %10000

end_font_data:
.end
