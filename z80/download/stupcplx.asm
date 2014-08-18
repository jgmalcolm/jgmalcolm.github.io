#include "ti86asm.inc"		;normal include file with common ROM calls
_Ex_ahl_bde		=$45f3	;like 'ex bde,ahl'
_ahl_Plus_2_Pg3		=$4c3f	;ahl=ahl+2
_Set_ABS_Dest_Addr	=$5285
_Set_ABS_Src_Addr	=$4647
_Set_MM_Num_Bytes	=$464f
_MM_Ldir		=$52ed
.org _asm_exec_ram
	ld hl,complex-1		;copy anything before
				; complex for type byte
	rst 20h			;call _Mov10toOP1
	rst 10h			;call _FindSym to see
				; if variable exists
	call nc,_delvar		;delete variable if
				; it exists all
				; necessary info
				; still preserved
	ld hl,2			;2 elements
	call _CreateCPLX	;create complex (as
				; opposed to complex)
				; number
	call _ex_ahl_bde	;$45f3  ABS bde &
				; ahl swapped
	call _Set_ABS_Dest_Addr	;$5285  set that as
				; destination for
				; block copy
	sub a			;AKA ld a,0
	ld hl,start		;hl points to complex_start
				;address of complex is
				; in relation to 16 bit
				; and ram page
	call _Set_ABS_Src_Addr	;$4647  set that as
				; source for block copy
	sub a			;AKA ld a,0 -it's on
				; already swapped in
				; page (0)
	ld hl,end-start		;length of complex
	call _Set_MM_Num_Bytes	;$464f  set # of bytes
				; to copy in block copy
	jp _MM_Ldir		;$52ed  ABS block copy
				;we jump instead of
				; calling and returning
				;this way we just use
				; _MM_Ldir's ret as ours
				;saves 1 byte

complex:	.db 6,"Stupid"	;length indexed complex name
start:
	.db $01,$00, $fc, $10, $00, $00, $00, $00, $00, $00 
	.db $01,$00, $fc, $20, $00, $00, $00, $00, $00, $00 
end:
.end