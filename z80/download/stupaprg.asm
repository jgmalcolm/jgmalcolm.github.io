#include "ti86asm.inc"		;normal include file with common ROM calls
_Ex_ahl_bde		=$45f3	;like 'ex bde,ahl'
_ahl_Plus_2_Pg3		=$4c3f	;ahl=ahl+2
_Set_ABS_Dest_Addr	=$5285
_Set_ABS_Src_Addr	=$4647
_Set_MM_Num_Bytes	=$464f
_MM_Ldir		=$52ed
.org _asm_exec_ram
	ld hl,prog-1		;copy anything before
				; prog for type byte
	rst 20h			;call _Mov10toOP1
	rst 10h			;call _FindSym to see
				; if variable exists
	call nc,_delvar		;delete variable if
				; it exists all
				; necessary info
				; still preserved
	ld hl,prog_size		;length
	call _CreatePROG	;create prog
	call _ex_ahl_bde	;$45f3  ABS bde &
				; ahl swapped
	call _ahl_Plus_2_Pg3	;get paste row byte
				; and col byte
	call _Set_ABS_Dest_Addr	;$5285  set that as
				; destination for
				; block copy
	sub a			;AKA ld a,0
	ld hl,copy_start	;hl points to prog_start
				;address of prog is
				; in relation to 16 bit
				; and ram page
	call _Set_ABS_Src_Addr	;$4647  set that as
				; source for block copy
	sub a			;AKA ld a,0 -it's on
				; already swapped in
				; page (0)
	ld hl,prog_size		;length of prog
	call _Set_MM_Num_Bytes	;$464f  set # of bytes
				; to copy in block copy
	jp _MM_Ldir		;$52ed  ABS block copy
				;we jump instead of
				; calling and returning
				;this way we just use
				; _MM_Ldir's ret as ours
				;saves 1 byte

prog:	.db 6,"Stupid"		;length indexed prog name
copy_start:
	.dw $288e		;asm prog identifier
.org _asm_exec_ram		;new origin
start:
	call _clrLCD
	call _getkey
	call _homeup
	jp continue		;to demonstrate absolute
				; jumps with new origin
	nop
	nop
	nop
continue:
	jp _clrLCD
end:
prog_size	=end-start+2
.end