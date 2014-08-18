;============================
; aliases and defines used
;
_getkey		=$55aa		;pause for keypress
_contrast	=$c008		;current contrast level
_dispAHL	=$4a33		;displays ahl in
				; cursor font
_homeup		=$4a95		;cursor at top left
_clrScrn	=$4a82		;clear screen & _textShadow

_asm_exec_ram	=$d748		;address where
				; program is run from
kUp		=$03		;[up] key
kDown		=$04		;[down] key
kExit		=$07		;[exit] key
contrast_port	=2		;port for contrast
.org _asm_exec_ram
;============================
; main loop
;  displays contrast
;  checks for keypresses
;  adjusts contrast accordingly
;  loops again
;
main_loop:
	call display_contrast	;display contrast
	call _getkey		;wait for a keypress
	cp kUp \ jr z,up	;[up]
	cp kDown \ jr z,down	;[down]
	cp kExit		;[exit]
	jr nz,main_loop		;if it isn't
				; exit then loop again

;============================
; exit program
; input:	none
; output:	at cleared homescreen
;		with cursor at top left
exit:
	call _homeup		;cursor at top left
	jp _clrScrn		;clear screen and
				; return


;============================
; increase contrast
; input:	none
; output:	increases contrast if possible
up:
	ld a,31			;max contrast
	ld hl,_contrast		;get current
				; contrast address
	cp (hl)			;is it at
				; the max?
	jr z,main_loop		;it was already
				; at it's highest
	inc (hl)		;increase contrast
	ld a,(hl)
	out (contrast_port),a	;update contrast
	jr main_loop


;============================
; decrease contrast
; input:	none
; output:	decreases contrast if possible
down:
	sub a			;aka ld a,$00
				;lowest contrast
	ld hl,_contrast		;get current
				; contrast address
	cp (hl)			;is it at
				; the max?
	jr z,main_loop		;it was already
				; at it's highest
	dec (hl)
	ld a,(hl)
	out (contrast_port),a	;update contrast
	jr main_loop



;============================
; display contrast
; input:	none
; output:	contrast in cursor font
;		at top right
;
display_contrast:
	call _clrScrn		;clear screen
	call _homeup		;put cursor
				; at top left
	ld a,(_contrast)	;get current
				; contrast
	ld h,$00		;zero h
	ld l,a			;hl=(_contrast)
	sub a			;aka ld a,$00
	jp _DispAHL		;display it
				; and return
.end
