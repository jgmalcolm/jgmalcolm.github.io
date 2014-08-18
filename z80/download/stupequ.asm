#include "ti86asm.inc"		;normal include file with common ROM calls
_Ex_ahl_bde		=$45f3	;like 'ex bde,ahl'
_ahl_Plus_2_Pg3		=$4c3f	;ahl=ahl+2
_Set_ABS_Dest_Addr	=$5285
_Set_ABS_Src_Addr	=$4647
_Set_MM_Num_Bytes	=$464f
_MM_Ldir		=$52ed
.org _asm_exec_ram
	ld hl,equation-1	;copy anything before equation for type byte
	rst 20h			;call _Mov10toOP1
	rst 10h			;call _FindSym to see if variable exists
	call nc,_delvar		;delete variable if it exists
				;all necessary info still preserved
	ld hl,end-start		;minus start from end of equation
				; so result is length of equation
	call _CreateEQU		;$472f  create equation
	call _ex_ahl_bde	;$45f3  ABS bde &  ahl swapped
	call _AHL_Plus_2_Pg3	;$4c3f  increase ABS ahl by two
	call _Set_ABS_Dest_Addr	;$5285  set that as destination for block copy
	sub a			;AKA ld a,0
	ld hl,start		;hl points to equation_start
				;address of equation is in relation to 16 bit
				; and ram page
	call _Set_ABS_Src_Addr	;$4647  set that as source for block copy
	sub a			;AKA ld a,0 -it's on already swapped in page (0)
	ld hl,end-start		;length of equation
	call _Set_MM_Num_Bytes	;$464f  set # of bytes to copy in block copy
	jp _MM_Ldir		;$52ed  ABS block copy
				;we jump instead of calling and returning
				;this way we just use _MM_LDIR's ret as ours
				;saves 1 byte

equation:	.db 6,"Stupid"	;length indexed equation name
start:
				;tokenized equation
	.db $42			;Pi
	.db $32+1		;following is a 1 character
				; variable name
	.db "R"			;R (for radius)
	.db $f0			;^
	.db $44,"2",0		;2
	;=Pi R ^2  (i think that's some area formula or something)
end:
.end
