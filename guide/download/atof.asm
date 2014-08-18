atof

Converts a string to a floating point number. 


.org $d748

        ld hl,str
        ld b,10
        ld de,$c089
        call atof
        call $515b
        ret

str:    .db "1.2345",$1b,"678"

;convert string (hl) length b to fp (de)
; by Joshua Seagoe
atof:   push de
        push hl
        call $41b7      ;0->(de)
        pop hl
        pop de
        inc de
        ld (atofexp),de ;->exponent
        inc de          ;skip exponent for now
        inc de
        ld c,0          ;c=number of digits parsed
atofloop:
        ld a,(hl)       ;load a char
        inc hl
        cp '0'          ;make sure it's a number
        jr c,atofnan
        cp '9'+1
        ret nc          ;nothing >9 is used
        and $0f         ;get the number
        bit 0,c         ;shift to upper bits
        call z,$438b    ;if it should be there
        ex de,hl
        add a,(hl)      ;add to what's there
        ex de,hl
        ld (de),a       ;store it
        bit 0,c         ;go to next byte
        jr z,atofnoskip
        inc de          ;if we should
atofnoskip:
        inc c           ;register another digit
        djnz atofloop   ;get the rest
        ret             ;done!

atofnan:                ;it's not a number
        cp '.'          ;is it a dp?
        jr z,atofdp
        cp $1b          ;is it the exp symbol?
        jr z,atofex
        ret             ;give up

atofdp:                 ;decimal point!
        push de         ;save dest
        push hl         ;save source
        push bc         ;save length
        ld b,0          ;bc=digit count
        ld de,$fbff     ;hl=$fbff
        ex de,hl
        add hl,bc
        ex de,hl
        ld hl,(atofexp) ;find exponent
        ld (hl),e       ;write exponent
        inc hl
        ld (hl),d
        pop bc
        pop hl
        pop de
        djnz atofloop   ;get the rest
        ret

atofex:                 ;exponent
        ld de,0         ;now contains exponent
        dec b           ;count off exp char
atofeloop:
        ld a,(hl)
        inc hl
        cp '0'           ;only numbers in exponent
        ret c
        cp '9'+1
        ret nc
        and $0f         ;get actual number
        push hl
        ld l,e          ;de=de*10+a
        ld h,d
        add hl,hl       ;*2
        add hl,hl       ;*4
        add hl,de       ;*5
        add hl,hl       ;*10
        ld e,a
        ld d,0
        add hl,de       ;+a
        pop de          ;restore de
        ex de,hl        ;they go the other way...
        djnz atofeloop
        ld hl,(atofexp) ;(hl)->old exp
        call $5928      ;ld hl,(hl)
        add hl,de       ;hl=new exp
        ld de,(atofexp)
        ex de,hl
        ld (hl),e       ;store new exp
        inc hl
        ld (hl),d
        dec hl          ;restore hl->answer
        dec hl
        ret

atofexp: .dw 0

.end