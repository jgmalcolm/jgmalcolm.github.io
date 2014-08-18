;This is a highly optimized writeback routine for saving high scores and saved games.
;It saves all data between data_start and data_end.
;-Jonah Cohen		<ComAsYuAre@aol.com>

#include "TI86.inc"			;Clem's include file

save_data:
	ld hl,_asapvar			;hl->name of program
	rst 20h				;copy to OP1
	rst 10h				;_findsym
	xor a
	ld hl,data_start-_asm_exec_ram+4		;offset
	add hl,de				;hl=pointer to data in original prog
	adc a,b				;in case we overlapped pages
	call _SET_ABS_DEST_ADDR
	xor a					;no absolute addressing now
	ld hl,data_start			;get data from here
	call _SET_ABS_SRC_ADDR
	ld hl,data_end-data_start	;number of bytes to save
	call _SET_MM_NUM_BYTES
	jp _MM_LDIR			;copy data and return
