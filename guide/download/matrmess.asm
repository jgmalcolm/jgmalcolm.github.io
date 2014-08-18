;jimi malcolm
;guide.ticalc.org
#include "ti86asm.inc"
_Ex_ahl_bde		=$45f3	;like 'ex bde,ahl'
_ahl_Plus_2_Pg3		=$4c3f	;ahl=ahl+2
_Set_ABS_Dest_Addr	=$5285
_Set_ABS_Src_Addr	=$4647
_Set_MM_Num_Bytes	=$464f
_MM_Ldir		=$52ed
_GetMtoOP1		=$4bc7	;in:  b-row/c-col/ade-matrix
				;out: op1 - cell value
_dispOP1		=$515b	;displays op1
_ConvOP1		=$5577	;a=integer of op1
_DispAHL		=$4a33	;displays ahl
.org _asm_exec_ram
	call create_matrix	;create matrix to mess with

	call _homeup		;put cursor at top left
	call _clrScrn		;clear screen
	ld hl,matrix-1		;name without type byte
	ld bc,256*1+2		;row 1, col 2
	call get_cell		;get cell to op1
	call _ConvOP1		;a=op1
	ld l,a			;\
	sub a			; |- ahl=a
	ld h,a			;/
	call _DispAHL		;display it
	call _getkey		;wait for keypress
	jp _clrScrn		;clear screen and return


;==============
; gets cell of matrix to op1
; in:  hl - matrix name without type byte
;      b - row
;      c - column
; out: op1 - cell of matrix
get_cell:
		push bc		;save row/col
	rst 20h			;_mov10toop1
	rst 10h			;_findsym
	ld a,b			;ade=matrix data start
		pop bc		;get back row/col
	jp _GetMToOP1		;get cell to op1


;==============
; creates matrix
; taken from my internet page: http://guide.ticalc.org/download/stupmat.asm
create_matrix:
	ld hl,matrix-1		;copy anything before matrix for type byte
	rst 20h			;call _Mov10toOP1
	rst 10h			;call _FindSym to see if variable exists
	call nc,_delvar		;delete variable if it exists
				;all necessary info still preserved
	ld hl,3*256+3		;3 rows, 3 columns
	call _CreateRMAT	;create real matrix (as opposed to complex)
	call _ex_ahl_bde	;$45f3  ABS bde &  ahl swapped
	call _ahl_Plus_2_Pg3	;get paste row byte and col byte
	call _Set_ABS_Dest_Addr	;$5285  set that as destination for block copy
	sub a			;AKA ld a,0
	ld hl,start		;hl points to matrix_start
				;address of matrix is in relation to 16 bit
				; and ram page
	call _Set_ABS_Src_Addr	;$4647  set that as source for block copy
	sub a			;AKA ld a,0 -it's on already swapped in page (0)
	ld hl,end-start		;length of matrix
	call _Set_MM_Num_Bytes	;$464f  set # of bytes to copy in block copy
	jp _MM_Ldir		;$52ed  ABS block copy
				;we jump instead of calling and returning
				;this way we just use _MM_LDIR's ret as ours
				;saves 1 byte
;===================================================
; data and variables
;---------------------------------------------------
matrix:	.db 6,"Stupid"		;length indexed matrix name
start:
	;row 1
	.db $00,$00, $fc, $10, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $20, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $30, $00, $00, $00, $00, $00, $00 
	;row 2
	.db $00,$00, $fc, $40, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $50, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $60, $00, $00, $00, $00, $00, $00 
	;row 3
	.db $00,$00, $fc, $70, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $80, $00, $00, $00, $00, $00, $00 
	.db $00,$00, $fc, $90, $00, $00, $00, $00, $00, $00 
end:
.end