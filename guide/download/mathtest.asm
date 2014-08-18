_dispAHL	=$4a33
_homeup		=$4a95
_clrScrn	=$4a82
_runindicoff	=$4ab1
_asm_exec_ram	=$d748
_getkey		=$55aa
.org _asm_exec_ram

	call _homeup
	call _clrScrn
	call _runIndicOff

	call routine	;run your routine

;=====================
; take out the following
; three lines if you're
; dealing with 16 bit
; register hl and put in
; the following:
;	sub a
;=====================
	ld l,a
	sub a
	ld h,a		;ahl=a
;=====================
; end code to be cut out
; if using 16 bit hl
;=====================
	call _dispAHL
	call _getkey
	call _homeup
	jp _clrScrn
routine:
;=====================
; load operands here
;  ex)	ld a,4
;	ld b,6
;=====================

;=====================
; paste routine here
;  ex) add a,a	;a*2
;=====================


	ret
.end
