#include "ti86asm.inc"
_HtimesL	=$4547		;hl=h*l
.org _asm_exec_ram
	di			;so we're not also counting the interrupt times
	call _clrScrn
	call _runIndicOff

	ld bc,500

	ld hl,0
	ld (_curRow),hl
	ld hl,begin_text
	call _puts
	call _getkey
loop:
		push bc
;===================================
	ld hl,tile_data
	call tile_gen
;	call drawmap
;===================================
		pop bc
	dec bc
	ld a,b
	or c
	jr nz,loop

	ld hl,0
	ld (_curRow),hl
	ld hl,stop_text
	call _puts
	call _getkey
	ei			;so we're not also counting the interrupt times
	jp _clrScrn
begin_text:	.db "ready",0
stop_text:	.db "stop",0
;============================================================
; DrawMap -- draws an 8x16 tilemap  [Assembly Coder's Zenith]
;  input: HL = pointer to tilemap to draw
;  total: 34b/91529t (including ret and entire GridPutSprite)
;============================================================
DrawMap:
 ld de,$0000            ; start drawing at (0, 0)
DrawMapL:
 push hl                ; save map pointer
 ld l,(hl)              ; get the current tile
 ld h,0                 ; clear the upper byte
 add hl,hl              ; multiply by 8 (* 2)
 add hl,hl              ; * 4
 add hl,hl              ; * 8
 ld bc,tile0          ; load the start of the sprites
 add hl,bc              ; add togehter to get correct sprite
 push de                ; save sprite draw location
 call GridPutSprite     ; draw the sprite
 pop de                 ; restore sprite draw location
 pop hl                 ; restore map pointer
 inc hl                 ; go to next tile
 inc e                  ; move location to the right
 bit 4,e                ; if the 5th bit (e = 16), we're done
 jr z,DrawMapL          ; only jump if the row isn't complete
 ld e,0                 ; draw at the left again
 inc d                  ; move location down a row
 bit 3,d                ; check if it's done (e = 8)
 ret nz                 ; return if we're done
 jr DrawMapL            ; jump back to the top of the loop
;===========================================================
; GridPutSprite:                                  [Dan Eble]
;  Puts an aligned sprite at (E, D), where HL -> Sprite
;===========================================================
; IN : D  = y (0-7 inclusive)
;      E  = x (0-15 inclusive)
;      HL-> sprite
;
; OUT: AF, BC, DE, HL, IX modified
; Current total : 28b/567t (not counting ret)
;===========================================================
GridPutSprite:
 push hl
 pop ix                 ; ix-> sprite
 srl d                  ; de = 128y+x (16 bytes/row, 8 rows)
 rra
 and $80
 or e                   ; add x offset (remember x <= 15)
 ld e,a
 ld hl,$fc00            ; hl-> video ram
 add hl,de              ; hl-> video ram + offset
 ld b,8                 ; initialize loop counter
 ld de,$10              ; initialize line increment
GPS_Loop
 ld a,(ix+0)            ; get byte from sprite
 ld (hl),a              ; put byte on screen
 inc ix                 ; move to next byte in sprite
 add hl,de              ; move to next line on screen
 djnz GPS_Loop
 ret



;==================================
; tile_gen
;
;  draws 16x8 tile map
;==================================
tile_gen:
	ld ix,$fc00		;where to draw it to
	ld b,8			;8 rows of tiles
loop_row:
		push bc		;save our loop counter
columns:
	ld b,16			;16 columns of tiles
loop_columns:
		push hl		;save where we are in data
	ld l,(hl)		;tile data
	ld h,0			;clear upper byte of address
	add hl,hl		;*2
	add hl,hl		;*2
	add hl,hl		;*2 = 2*2*2 = 8
				;each tile is 8 bytes long
	ld de,tile0		;address of first tile
	add hl,de		;get offset in tile image data

draw_tile:
	ld de,$10		;$10 bytes to get to next row
	ld c,b			;save our column counter
	ld b,8			;need to copy 8 bytes
				; from tile image
		push ix		;save where we are in video mem
draw_tile_loop:
	ld a,(hl)		;get byte from tile image
	ld (ix),a		;draw it onto video memory
	add ix,de		;increase row in the video
				; memory we're working with
	inc hl			;increase the address in
				; tile data
	djnz draw_tile_loop
		pop ix		;get back where we were in
				; video memory
	ld b,c			;get back our column counter
		pop hl		;get back where we were in
				; the tile data
	inc hl			;inc tile data - next tile
	inc ix			;inc video mem - next col
	djnz loop_columns
	ld de,$10*7		;need to move down now
	add ix,de
		pop bc		;get back our row counter
	djnz loop_row
	ret
	
	


tile_data:
	.db 0,1,0,0,2,0,0,0,0,3,0,0,0,0,0,0
	.db 0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0
	.db 0,0,0,0,1,0,0,3,0,2,0,2,0,0,0,0

;#include tiles.inc
tile0:
	.db %11011101
	.db %11101110
	.db %01110111
	.db %10111011
	.db %11011101
	.db %11101110
	.db %01110111
	.db %10111011

tile1:
	.db %01111110
	.db %11000011
	.db %10100101
	.db %10000001
	.db %10000001
	.db %10100101
	.db %11000011
	.db %01111110

tile2:
	.db %00000000
	.db %00000000
	.db %01100110
	.db %10011001
	.db %10011001
	.db %01100110
	.db %01100110
	.db %01100110

tile3:
	.db %00011000
	.db %00100100
	.db %00100100
	.db %01000010
	.db %01000010
	.db %10000001
	.db %10000001
	.db %10000001
.end
