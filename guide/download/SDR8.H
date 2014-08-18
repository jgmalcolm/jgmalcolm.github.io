;Sprite Drawing Routine (SDR): 8 Bit Normal Version
;by JL
;<JayEll64@aol.com>
;
;Inputs:
;	b=x coordinate
;	c=y coordinate
;	hl=pointer to sprite data
;Outputs:
;	af=destroyed
;	bc=destroyed
;	de=destroyed
;	hl=pointer to byte after sprite
;	no other registers are changed
;If you want to save those registers that are destroyed, push/pop them!
;
;Sprite data should be stored as follows:
;.db (# rows/bytes/height of sprite)
;.db (bitmap of sprite)
;
;Size=59 bytes (+pushes/pops)
;***CLOCKED AT MORE THAN 2000 8X8 SPRITES PER SECOND!!!  THAT'S MORE THAN 3X
; FASTER THAN PUTSPRITE!!!*** (At the same size, or maybe even at a smaller
; size!)
;
;Notes:
;You can 'xor' the sprite to the video memory by changing both 'or (hl)'s
; with 'xor (hl)'s
;You can make this routine smaller by deleting the first 3 lines and
; accounting in your program the fact the the origin (0,0) is the *bottom*
; left corner (saves 4 bytes!).
;Also, if all your sprites are the same height, you can delete the next 2
; lines (ld e,(hl)\inc hl); change the 3rd line after that (ld c,e) to
; 'ld c,x', where x is the height of your sprites; and store all sprites
; with only the sprite data, leaving off that first byte that defines the
; height (saves 1 bytes + # of sprites!)
;If you want the sprite to be drawn in the graphics memory instead of the
; video memory, simply replace the one instance of VIDEO_MEM with
; GRAPH_MEM.

SDR8:
 ld a,63	;-->flips the x coordinate around for FIND_PIXEL
 sub c		; / may be deleted if accounted for in program
 ld c,a		;/
 ld e,(hl)	;e=number of rows in sprite
 inc hl	;next byte (points to sprite now)
 push hl	;push pointer to sprite to stack
 call FIND_PIXEL	;)
 ld c,e	;c=number of rows in sprite
 ld de,VIDEO_MEM	;define offset
 add hl,de	;and add offset to get where to put sprite

 add a,a	;-> sets all bits to the right of set bit (for mask)
 dec a		;/
 ld e,a	;save mask into e
 ld a,b	;a=x coor
 and %00000111	;find remainder of x/8
 inc a	;get range between 1-8
 ld b,a	;and save rotate counter

SDR8_NewRow:
 ex (sp),hl	;hl(video location)<->(sp)(pointer to sprite)
 ld a,(hl)	;a=byte in sprite
 inc hl	;next byte
 ex (sp),hl	;hl<->(sp)
 push bc	;save rotate counter and row counter

 rlca	;rotate left once...
SDR8_PrepByte:
 rrca	;...then rotate right...
 djnz SDR8_PrepByte	;...1 to 8 times

 ld b,a	;save rotated sprite byte into b
 and e	;mask away left bits
 ld d,a	;save masked sprite byt into d
 ld a,e	;a=sprite mask
 cpl	;switch every bit
 and (hl)	;reset every bit sprite's going to write to
 or d	;and combine with masked sprite byte
 ld (hl),a	;put left half of sprite
 inc hl	;next byte over

 ld a,e	;a=sprite mask
 cpl	;switch every byte
 and b	;mask off right bits
 ld d,a	;save masked sprite byte into d
 ld a,e	;a=sprite mask (again)
 and (hl)	;mask off bits where sprite's going to be put
 or d	;set bits in sprite byte
 ld (hl),a	;and put right half of sprite

 ld bc,$10-1	;bc=number of bytes in one row subtract one
 add hl,bc	;add to point hl to next row
 pop bc	;restore rotate counter and row counter
 dec c	;decrease row counter
 jr nz,SDR8_NewRow	;and repeat until whole sprite is drawn
 pop hl	;restore hl (which now points to next byte after sprite)
 ret	;return