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
	ld hl,end-start		;length
	call _CreatePROG	;create prog
	call _ex_ahl_bde	;$45f3  ABS bde &
				; ahl swapped
	call _ahl_Plus_2_Pg3	;get paste row byte
				; and col byte
	call _Set_ABS_Dest_Addr	;$5285  set that as
				; destination for
				; block copy
	sub a			;AKA ld a,0
	ld hl,start		;hl points to prog_start
				;address of prog is
				; in relation to 16 bit
				; and ram page
	call _Set_ABS_Src_Addr	;$4647  set that as
				; source for block copy
	sub a			;AKA ld a,0 -it's on
				; already swapped in
				; page (0)
	ld hl,end-start		;length of prog
	call _Set_MM_Num_Bytes	;$464f  set # of bytes
				; to copy in block copy
	jp _MM_Ldir		;$52ed  ABS block copy
				;we jump instead of
				; calling and returning
				;this way we just use
				; _MM_Ldir's ret as ours
				;saves 1 byte

prog:	.db 6,"Stupid"		;length indexed prog name
start:
				;the ti-basic code that i
				; got from writing this
				; program out in the
				; PROG EDIT thingy and
				; then running it to get
				; it tokenized
				;then i used my memsee
				; program to check it out
	.db $e9,$44,"123",0	;Disp 123
	.db $6f			;carriage return

	.db $e1,$00,$1c,"EXIT",$00
				;Goto EXIT
	.db $6f			;carriage return

	.db $e9,$44,"321",$00	;Disp 321
	.db $6f			;carriage return

	.db $e0,"EXIT",$00	;Lbl EXIT
end:
.end