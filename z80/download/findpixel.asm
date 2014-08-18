;----------------------------------------------------------------------
; FIND PIXEL by CLEM  (117 cycles 34 bytes)
;
;  Input: x->b
;            y->c
;
;  Output: hl : byte in LCD memory
;               a  : bitmask for (hl)
;
; Destroyes : bc
;----------------------------------------------------------------------

FindPixel:
     ld h,63
     ld a,c
     add a,a
     add a,a
     ld l,a
     ld a,b
     rra
     add hl,hl
     rra
     add hl,hl
     rra
     or l
     ld l,a
     ld a,b
     and 7
     ld bc,FP_Bits
     add a,c
     ld c,a
     adc a,b
     sub c
     ld b,a
     ld a,(bc)
     ret

FP_Bits:     .db $80,$40,$20,$10,$08,$04,$02,$01

