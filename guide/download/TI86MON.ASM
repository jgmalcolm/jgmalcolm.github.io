;TI86MON.ASM Copyright (C) 1998 Steve Gordon
;Version 2.0

#include "asm86.h"
#include "ti86asm.inc"
#include "ti86math.inc"
#include "ti86ops.inc"
#include "ti86abs.inc"

OP_NONE                 equ $0  ;
OP_LIST                 equ $1
OP_VIEW1LINE            equ $2  ;
OP_VIEWLINES            equ $3  ;
OP_SETMEM               equ $4  ;
OP_MEMMOVE              equ $5  ;
OP_MINIASM              equ $6
OP_OUTP                 equ $7  ;
OP_INP                  equ $8  ;
OP_REGADDR              equ $a  ;
OP_SEARCH               equ $b  ;
OP_GO                   equ $c  ;

;*****************************************************************************
; MAIN
;*****************************************************************************
.org _asm_exec_ram
        nop
        nop
        nop
        ld bc,cmdline
        ld (temp2),bc
        call storeregs          ; store regs
        call $49DC              ; get rid of menus
        ld bc, 0                ; clear first 3 params
        ld (param0), bc
        ld (param1), bc
        ld (param2), bc
        call _clrLCD
;        call _clrScrn
;        call _runindicoff
        ld hl,$0000             ; Print intro
        ld (_curRow),hl
        ld hl,intro
        call _puts
        ld bc, endprog
        call printword
        ld hl,$0001
        ld (_curRow),hl
        ld hl,author
        call _puts
        ld hl,$0002             ; Display cursor
        ld (_curRow),hl
        ld ix, cmdline
dspcur: ld a,62
        call _putc
        ld a,$5f
        call _putmap
getkey: call _getkey            ; Get keystroke
        cp kExit                ; exit?
        jp z, exit
        cp kEnter               ; enter?
        jp z, enter
        cp kLeft
                jp z, left
        cp kClear
                jp z, cls
        cp kF1
                jp z, helpmsg
        cp kF2
                jp z, miniasm
        cp kF3
                jp z, dumpt1
        cp kF4
                jp z, dumpt2
        cp kF5
                jp z, dumpt3
        cp kUp
                jp z, restline
        call keytoasc           ; numeric or operation key, just print
        cp 0
        jp z, getkey            ; undefined key
        ld (ix), a              ; Store char in cmdline
        inc ix
        call _putc              ; Print char
        ld a,$5f
        call _putmap
        jp getkey
enter:                          ;enter key, parse and execute command
        call printcr
        ld hl, cmdline          ; hl=commandline start, ix=endline
        ld (temp2),ix
        ld (ix), 0              ; terminate cmdline
        call parsecmd
        ld a, (op)
        cp OP_VIEW1LINE
                jp z, view1line
        cp OP_VIEWLINES
                jp z, viewmulti
        cp OP_LIST
                jp z, viewlist
        cp OP_INP
                jp z, inport
        cp OP_OUTP
                jp z, outport
        cp OP_MEMMOVE
                jp z, memmove
        cp OP_SEARCH
                jp z, search
        cp OP_REGADDR
                jp z, regaddr
        cp OP_SETMEM
                jp z, setmem
        cp OP_GO
                jp z, go
enter1:
        ld ix, cmdline
        jp dspcur

restline:
        ld bc,(temp2)
        ld a,c
        or b
        jp z,getkey
        ld hl,cmdline
        call _puts
        ld ix,(temp2)
        ld bc,$0
        ld (temp2),bc
        ld a,$5f
        call _putmap
        jp getkey

memmove:
        ;a=byte, b=#param, ix=dstaddr, iy=srcaddr, hl=ct
        push iy
        ld ix, (param0)
        ld iy, (param1)
        ld hl, (param2)
        inc hl
mm1:    dec hl
        ld a, l
        cp 0
        jr nz, mm2
        ld a, h
        cp 0
        jr z, mm3
mm2:    ld a, (iy)
        ld (ix), a
        inc ix
        inc iy
        jr mm1
mm3:    pop iy
        jp enter1

search:
        ; ix=start, iy=finish, b=#params, c=dec params, hl=params2[x]
        push iy
        ld a, (numpar)
        ld b, a
        dec b
        dec b
        jr z, srchnf
        ld ix, (param0)
        ld iy, (param1)
srch0:  push ix                 ;ix=iy?
        push iy
        pop de
        pop hl
        ld a, l
        cp e
        jr nz, srch1
        ld a, h
        cp d
        jr z, srchnf            ;ix=iy, done
srch1:  ld a, (param2)          ;is (ix) = param2?
        cp (ix)
        jr nz, srch4
        ld hl, param3           ;found first byte
        push ix
        inc ix
        ld c, b
srch2:  dec c
        jr z, srchf
        ld a, (ix)
        cp (hl)
        jr nz, srch3            ;not equal, abort loop
        inc hl                  ;equal, look at next param
        inc hl
        inc ix
        jr srch2
srch3:  pop ix
srch4:  inc ix
        jr srch0
srchnf: ld hl, notfndmsg        ;not found, print message
        pop iy                  ;must restore iy to call sys funcs
        call _puts
        jp srchd
srchf:  pop bc                  ;remember, ix is on the stack
        pop iy
        call printword
srchd:  call printcr
        jp enter1

setmem:
        ;a=byte, b=#param, hl=address, i1=source
        ld a, (numpar)
        ld b, a
        ld hl, (param0)
        ld ix, param1
stmem0: dec b
        jr z, stmem1
        ld a, (ix)
        ld (hl), a
        inc ix
        inc ix
        inc hl
        jr stmem0
stmem1: jp enter1

go:
        ld a, (param0)
        ld (cadr+1), a
        ld a, (param0+1)
        ld (cadr+2), a
        call getregs
cadr:   call $0000
        call storeregs
        jp enter1

viewmulti:                      ;Seven line dump
        ld e, 7
vl0:
        call dumpline
        call printcr
        ld ix, (param0)
        ld a, (addrinc)
        ld b, 0
        ld c, a
        add ix, bc
        ld (param0), ix
        dec e
        jr nz, vl0
        jp enter1

helpmsg:
        ld hl,$0000             ; Print intro
        ld (_curRow),hl
        ld hl,helptxt
        call _puts
        jp enter1

viewlist:                       ;Dissassemblly list
        ld e, 7
dis0:
        call disline
        call printcr
        ld ix, (param0)
        ld a, (instsz)
        ld b, 0
        ld c, a
        add ix, bc
        ld (param0), ix
        dec e
        jr nz, dis0
        jp enter1

view1line:                      ;One line of dump
        call dumpline
        call printcr
        ld ix, (param0)
        ld a, (addrinc)
        ld b, 0
        ld c, a
        add ix, bc
        ld (param0), ix
        jp enter1

cls:
        call _clrLCD
        ld hl,$0000             ; first row
        ld (_curRow),hl
        jp enter1

left:
        ld a, (_curCol)
        cp 1
        jp z,getkey
        dec ix
        ld a, $20
        call _putmap
        ld a, (_curCol)
        dec a
        ld (_curCol), a
        ld a, '_'
        call _putmap
        jp getkey

miniasm:
        ld hl, masmmsg
        call _puts
        call printcr
        jp enter1

regaddr:
        ld bc,regist    
        call printword
        call printcr
        jp enter1

outport:
        ld a, (param0)
        ld c,a
        ld a, (param1)
        out (c),a
        jp enter1

inport:
        ld a, (param0)
        ld c,a
        in a,(c)
        call printbyte
        call printcr
        jp enter1

dumpt1:
        ld a, 0
        ld (dumptyp),a
        ld a, 4
        ld (addrinc),a
        ld hl, dpt1msg
        call _puts
        call printcr
        jp enter1

dumpt2:
        ld a, 1
        ld (dumptyp),a
        ld a, 8
        ld (addrinc),a
        ld hl, dpt2msg
        call _puts
        call printcr
        jp enter1

dumpt3:
        ld a, 2
        ld (dumptyp),a
        ld a, $10
        ld (addrinc),a
        ld hl, dpt3msg
        call _puts
        call printcr
        jp enter1
exit:                           ;exit program
        ret

;*****************************************************************************
; SUBROUTINES
;*****************************************************************************

;*************************************
; printcr
; Print a carrige return to screen by
; printing n blanks
; in            : none
; out           : none
; destoys       : none
;*************************************
printcr:
        push af
        push bc
        ld a, (_curCol)
        cp 0
        jr z, printcrexit
        ld b, a
        ld a, 21       
        sub b          
        ld b, a                 ;b=21-curcol
cr0     ld a, 32
        call _putc
        dec b
        jp nz, cr0
printcrexit:
        pop bc
        pop af
        ret

;*************************************
; keytoasc
; Convert _getkey keystroke  to ascii
; in            : a
; out           : a
; destroys      : none
;*************************************
keytoasc:
        push hl
        push bc
        ld d, a
        ld a, (keyasctab)
        ld c, a
        ld a, d
        ld hl, keyasctab+1
ka0:    cp (hl)
        jr z,ka1
        inc hl
        inc hl
        dec c
        jr nz, ka0
        ld a, 0
        jr ka2
ka1:    inc hl
        ld a, (hl)
ka2:    pop bc
        pop hl
        ret

;*************************************
; parsecmd
; Parse command string, fill param0, 
; param1, and op
; in            : hl=command string
; out           : op,param1,param2,param3,
;                 ...,numparams
; destroys      : none
;
; a = general
; ix = current position in string
; b = address
; c = command phase
;
;*************************************
parsecmd:
        push af
        push bc
        push ix
        push hl
        ld a, OP_NONE           ;Clear op
        ld (op), a
        ld bc, 0
        push hl
        pop ix
look:   ld a, (ix)              ;Look at command
        cp 0
        jp z, endline
        cp 'P'
                jp z, viewcmd
        cp 'X'
                jp z, listcmd
        cp 'K'
                jp z, memmovcmd
        cp '='
                jp z, setmemcmd
        cp 'I'
                jp z, inportcmd
        cp 'O'
                jp z, outportcmd
        cp '.'
                jp z, dot
        cp 'T'
                jp z, regaddrcmd
        cp 'G'
                jp z, gocmd
        cp 'H'
                jp z, searchcmd
        inc ix
        jp look
listcmd:
        ld a, OP_LIST
        jp pcgf
viewcmd:
        ld a, OP_VIEWLINES
        jp pcgf
outportcmd:
        ld a, OP_OUTP
        jp pcgf
inportcmd:
        ld a, OP_INP
        jp pcgf
setmemcmd:
        ld a, OP_SETMEM
        jp pcgf
gocmd:
        ld a, OP_GO
        jp pcgf
memmovcmd:
        ld a, OP_MEMMOVE
        jp pcgf
searchcmd:
        ld a, OP_SEARCH
        jp pcgf
endline:
        ld a, OP_VIEW1LINE
        jp pcgf
regaddrcmd:
        ld a, OP_REGADDR
        jp pcgf2
dot:    dec ix                  ;Get address and return
        call getparam
        cp 0
        jr z, pc1
        inc b
pc1:    inc ix
        inc ix
        push ix
        pop hl
        jp look
pcgf:   dec ix
        ld c, a
        call getparam
        cp 0
        jr z, pcgf1
        inc b
pcgf1:  ld a, c
pcgf2:  ld (op), a
        ld a, b
        ld (numpar), a
        pop hl
        pop ix
        pop bc
        pop af
        ret

;*************************************
; getparam
; Convert string from hl to ix to
; params in param0+b
; in            : hl=start of string,
;                 ix = last byte
;                 b = paramindex
; out           : a = valid param
;                 param0,1,2..,7
; destroys      : none
;
; d=valid
; e=power
;*************************************
; A=41 F=46, a=61 f=66, 0=30 9=39
;
;    3000v[0]
;    ^    ^
;    h    i
;    l    x
;
; iy=daf1
; ix-daf0
;
getparam:
        push bc
        push de
        push hl
        push ix
        push iy
        ld a, b
        ld (temp1), a
        push hl
        pop iy                  ;iy=hl
        ld hl, 0
        ld d,0
        ld e,0
getad1: push hl
        push ix
        push iy
        pop bc
        pop hl
        scf
        ccf
        sbc hl, bc
        jp c, getad2            ;ix<iy?
        pop hl
        ld a, (ix)
looksm: cp $67
        jr nc, nonum
        cp $61
        jr c, lookbg
        sub $57
        jr yesnum
lookbg: cp $47
        jr nc, nonum
        cp $41
        jr c, looknm
        sub $37
        jr yesnum
looknm: cp $3a
        jr nc, nonum
        cp $30
        jr c, nonum
        sub $30
yesnum: ld d,1
        push hl
        pop bc
        ld h, 0
        ld l, a
        push de
        sla e
        sla e
        inc e
getad3: dec e                   ;accumulate result
        jr z, acc
        sla l
        rl h
        jr getad3
acc:    add hl, bc
        pop de
        inc e
nonum:  dec ix
        jp getad1
getad2: pop hl
        ld a, d
        cp 0
        jr z, getad5
        ld ix, param0            ;store param
        ld a, (temp1)
        sla a
        ld c, a
        ld b, 0
        add ix, bc
        ld (ix), l
        ld (ix+1), h
        ld a, 1
        jr getad4
getad5: ld a, 0
getad4: pop iy                  ;restore
        pop ix
        pop hl
        pop de
        pop bc
        ret

;*************************************
; printnib
; Print nibble in "a" register
; in            : a=byte to print
; out           : none
; destroys      : none
;*************************************
printnib:
        push af
        and $0f
        add a, $30
        cp $3a
        jp c, pn2
        add a, 7
pn2:    call _putc
        pop af
        ret

;*************************************
; printbyte
; Print byte in "a" register
; in            : a=byte to print
; out           : none
; destroys      : none
;*************************************
printbyte:
        push af
        sra a
        sra a
        sra a
        sra a
        and $0f
        add a, $30
        cp $3a
        jp c, pb1
        add a, 7 
pb1:    call _putc
        pop af
        push af
        and $0f
        add a, $30
        cp $3a
        jp c, pb2
        add a, 7
pb2:    call _putc
        pop af
        ret

;*************************************
; printword
; Print word in bc register
; in            : bc=word to print
; out           : none
; destroys      : none
;*************************************
printword:
        push af
        push bc
        ld a, b
        call printbyte
        ld a, c
        call printbyte
        pop bc
        pop af
        ret

;*************************************
; dumpline
; Dump one line at param0
; in            : param0 (global var)
; out           : none
; destroyed     : none
;*************************************
dumpline:
        push af
        push bc
        push de
        ld bc, (param0)          ;Print address
        call printword
        ld a, ':'               ;Print :
        call _putc
        ld a, (dumptyp)
        cp 1
        jp z, dlt2
        cp 2
        jp z, dlt3
dlt1:   ld d, 3
dlt11:  ld a, (bc)              ;Print first three hex val
        call printbyte
        ld a, ' '               ;Print space
        call _putc
        inc bc
        dec d
        jr nz, dlt11
        ld a, (bc)              ;Print fourth hex val
        call printbyte
        dec bc                  ;Point back to param0
        dec bc
        dec bc
        ld d, 4
        ld a, ' '               ;Print :
        call _putc
dlt12:  ld a, (bc)              ;Print four asc values
        cp $d6
        jr nz, dlt13
        ld a, $ff
dlt13:  call _putc
        inc bc
        dec d
        jr nz, dlt12
        jp dlend
dlt2:   ld d, 8
dlt21:  ld a, (bc)              ;Print 8 hex vals
        call printbyte
        inc bc
        dec d
        jr nz, dlt21
        jp dlend
dlt3:   ld d, $10
dlt31:  ld a, (bc)
        cp $d6
        jr nz, dlt32
        ld a, $ff
dlt32:  call _putc
        inc bc
        dec d
        jr nz, dlt31
dlend:  pop de
        pop bc
        pop af
        ret

;*************************************
; disline
; Disassemble one line at param0
; in            : param0 (global var)
; out           : none
; destroyed     : none
;*************************************
disline:
        push af
        push bc
        push de
        push hl
        push ix
        push iy

        ld bc, (param0)
        call printword
        ld a, ':'               ;Print :
        call _putc
        ld a,(bc)               ;a=opcode
        cp $cb                  ;cb set?
        jr z,dsl0
        cp $dd                  ;dd set?
        jr z,dsl1
        cp $ed                  ;ed set?
        jr z,dsl2
        cp $fd                  ;fd set?
        jr z,dsl3
        ld de,instrtab          ;normal set
normst: ld h,0                  ;hl=(4*opcode+_insttab)=_inst
        ld l,a
        sla l
        rl h
        sla l
        rl h
        add hl,de
        ld b,1
        jr dsl4
dsl0:   ld de,cbinstrtab
        inc bc
        ld a,(bc)
        jr normst
dsl1:   inc bc                  ;ddset
        ld a,(bc)
        cp $cb
        jr nz, dsl11            ;ddcb set
        inc bc
        inc bc
        ld a,(bc)
        ld hl,ddcbinstrtab
        call findinstr
        jr dsl4
dsl11:  ld hl,ddinstrtab        
        call findinstr
        jr dsl4
dsl2:   inc bc                  ;ed set
        ld a,(bc)
        ld hl,edinstrtab
        call findinstr
        jr dsl4
dsl3:   inc bc                  ;fd set
        ld a,(bc)
        cp $cb
        jr nz, dsl31            ;fdcb set
        inc bc
        inc bc
        ld a,(bc)
        ld hl,fdcbinstrtab
        call findinstr
        jr dsl4
dsl31:  ld hl,fdinstrtab
        call findinstr
dsl4:   push hl                 ;hl,ix=inst_,b=valid instr
        pop ix
        ld a,b
        cp 0
        jr nz,dsl55
        ld hl,invalidins
        call _puts
        ld a,1
        ld (instsz),a
        jp dslend
dsl55:  inc hl
        ld b,0                  ;bc=_mnutab offset
        ld c,(hl)
        dec hl
        ld a,(hl)               
        and $80
        jp p,dsl5
        inc b
dsl5:   ld hl,mnutab            ;print mnumonic
        add hl,bc
        call _puts
        ld a,(ix)               ;increment param0
        and $0f
        ld (instsz),a
        ld a,(ix)               ;print parameters
        and $70
        sra a
        sra a
        sra a
        sra a
        cp 0                    ;type 0
        jr z,dslend
dsl6:   cp 1                    ;type 1
        jr nz,dsl7
        ld a,' '
        call _putc
        ld a,(ix+2)
        cp $6a
        jr z,dsl61
        call getp
        ld a,','
        call _putc
dsl61:  ld a,(ix+3)
        call getp
        jr dslend
dsl7:   cp 2                    ;type 2
        jr nz,dsl8
        ld a,' '
        call _putc
        ld a,(ix+2)
        call getp
        jr dslend
dsl8:   cp 3                    ;type 3
        jr nz,dslend
        ld a,' '
        call _putc
        ld a,(ix+2)
        call getcc
        cp 0
        jr z,dsl81
        ld a,(ix+3)
        cp $b0
        jr z,dsl81
        ld a,','
        call _putc
dsl81:  ld a,(ix+3)
        call getp
        jr dslend
dslend: call printcr
        pop iy
        pop ix
        pop hl
        pop de
        pop bc
        pop af
        ret

getp:   ; ix=inst_,a=inst_[2]
        push af
        push bc
        push hl
        ld b,a
        srl a
        srl a
        srl a
        srl a
        cp 0                    ;address mode 0
        jr nz,getp0
        jp getpe
getp0:  cp 1                    ;mode 1,immediate 8 bit
        jr nz,getp1
        ld a,'$'
        call _putc
        ld a,b
        and $0f
        ld c,a
        ld b,0
        ld hl,(param0)
        add hl,bc
        ld a,(hl)
        call printbyte
        jp getpe
getp1:  cp 2                    ;Immediate 16 bit
        jr nz,getp2
        ld a,'$'
        call _putc
        ld a,b
        and $0f
        ld c,a
        ld b,0
        ld hl,(param0)
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)
        dec hl
        call printword
        jp getpe
getp2:  cp 3
        jr nz,getp3
        jp getpe
getp3:  cp 4                    ;Direct
        jr nz,getp4
        ld a,'('
        call _putc
        ld a,'$'
        call _putc
        ld a,b
        and $0f
        ld c,a
        ld b,0
        ld hl,(param0)
        add hl,bc
        ld c,(hl)
        inc hl
        ld b,(hl)
        dec hl
        call printword
        ld a,')'
        call _putc
        jp getpe
getp4:  cp 5                    ;Direct with index
        jr nz,getp5
        ld a,'('
        call _putc
        ld a,b
        and $0f
        call getreg16
        ld a,'+'
        call _putc
        ld a,'$'
        call _putc
        ld hl,(param0)
        inc hl
        inc hl
        ld a,(hl)
        call printbyte
        ld a,')'
        call _putc
        jp getpe
getp5:  cp 6                    ;8 bit register
        jr nz,getp6
        ld a,b
        and $0f
        call getreg8
        jp getpe
getp6:  cp 7                    ;16 bit register
        jr nz,getp7
        ld a,b
        and $0f
        call getreg16
        jp getpe
getp7:  cp 8                    ;16 bit register indirect

        jr nz,gettp8
        ld a,'('
        call _putc
        ld a,b
        and $0f
        call getreg16
        ld a,')'
        call _putc
        jp getpe
gettp8: cp $c                   ;8 bit pc relative 
        jr nz,gettp9
        ld a,'$'
        call _putc
        ld a,b
        and $0f
        ld c,a
        ld b,0
        ld hl,(param0)
        add hl,bc               ;hl = e_
        ld c,(hl)               ;c=e
        ld a,c
        ld b,0
        and $80
        jp p,getp81
        ld b,$ff
getp81: ld hl,(param0)
        inc hl
        inc hl
        add hl,bc
        push hl
        pop bc
        call printword
        jp getpe
gettp9: cp $d                   ;literal
        jr nz,gettpa
        ld a,b
        call printnib
        jp getpe
gettpa: cp $a
        jr nz,gettpb
        ld a,'('
        call _putc
        ld a,'$'
        call _putc
        ld a,b
        and $0f
        ld c,a
        ld b,0
        ld hl,(param0)
        add hl,bc
        ld a,(hl)
        call printbyte
        ld a,')'
        call _putc
        jr getpe
gettpb: cp $e
        jr nz,getpe
        ld a,'('
        call _putc
        ld a,b
        and $0f
        call getreg8
        ld a,')'
        call _putc
getpe:  pop hl
        pop bc
        pop af
        ret

getcc:
        push hl
        cp 0
        jr z,getcr
getc0:  cp 1
        jr nz,getc1
        ld hl,cctab+2
getc1:  cp 2
        jr nz,getc2
        ld hl,cctab+4
getc2:  cp 3
        jr nz,getc3
        ld hl,cctab+7
getc3:  cp 4
        jr nz,getc4
        ld hl,cctab+9
getc4:  cp 5
        jr nz,getc5
        ld hl,cctab+12
getc5:  cp 6
        jr nz,getc6
        ld hl,cctab+15
getc6:  cp 7
        jr nz,getc7
        ld hl,cctab+18
getc7:  cp 8
        jr nz,getce
        ld hl,cctab+20
getce:  call _puts
getcr:  pop hl
        ret

getreg8:
        push af
        push bc
        push hl
        ld hl,regtab
        sla a
        ld c,a
        ld b,0
        add hl,bc
        call _puts
        pop hl
        pop bc
        pop af
        ret

getreg16:
        push af
        push bc
        push hl
        ld hl,regtab+38
        ld c,a
        sla a
        add a,c
        ld c,a
        ld b,0
        add hl,bc
        call _puts
        pop hl
        pop bc
        pop af
        ret

findinstr: ;    passed:   hl=table ptr,a=opcode
           ;    returned: b=valid (0/1)
        ld de,5
        ld c,(hl)
        inc hl
fi1:    ld b,(hl)
        cp b
        jr z,finf
        add hl,de
        dec c
        jr nz,fi1
        ld b,0
        ret
finf:   ld b,1
        inc hl
        ret

;*************************************
; storeregs
; Store registers in register storage
; area
; in            : none
; out           : none
; destroyed     : none
;*************************************
storeregs:
        push af
        push bc
        ld (areg), a            ;a
        ld a, b                 ;b
        ld (breg), a            
        ld a, c                 ;c
        ld (creg), a
        push af                 ;f
        pop bc
        ld a, c
        ld (freg), a
        ld a, d                 ;d
        ld (dreg), a
        ld a, e                 ;e
        ld (ereg), a
        ld a, h                 ;h
        ld (hreg), a
        ld a, l                 ;l
        ld (lreg), a
        ld a, i                 ;i
        ld (ireg), a
        ld (xreg), ix           ;ix
        ld (yreg), iy           ;iy
                                ;pc
        ld a, r                 ;r
        ld (rreg), a
        ld (spreg), sp          ;sp

        exx
        ld a, b                 ;b'
        ld (arbreg), a            
        ld a, c                 ;c'
        ld (arcreg), a
        ld a, d                 ;d'
        ld (ardreg), a
        ld a, e                 ;e'
        ld (arereg), a
        ld a, h                 ;h'
        ld (arhreg), a
        ld a, l                 ;l'
        ld (arlreg), a

        ex af, af'
        ld (arareg), a          ;a'
        push af                 ;f'
        pop bc
        ld a, c
        ld (arfreg), a
        exx
        pop bc
        pop af
        ret

;*************************************
; getregs
; Get registers from register storage
; area
; in            : none
; out           : none
; destroyed     : all
;*************************************
getregs:
        ld a, (arfreg)          ;f'
        ld c, a
        ld a, (arareg)          ;a'
        ld b, a
        push bc
        pop af
        ex af, af'
        ld a, (arbreg)          ;b'
        ld b, a
        ld a, (arcreg)          ;c'
        ld c, a
        ld a, (ardreg)          ;d'
        ld d, a
        ld a, (arereg)          ;e'
        ld e, a
        ld a, (arhreg)          ;h'
        ld h, a
        ld a, (arlreg)          ;l'
        exx
        ld a, (dreg)            ;d
        ld d, a
        ld a, (ereg)            ;e
        ld e, a
        ld a, (hreg)            ;h
        ld h, a
        ld a, (lreg)            ;l
        ld l, a
        ld a, (ireg)            ;i
        ld i, a
        ld ix, (xreg)           ;ix
        ld iy, (yreg)           ;iy
        ld a, (rreg)            ;r
        ld r, a
;        ld sp, (spreg)          ;sp
        ld a, (freg)            ;f
        ld c, a
        push bc
        pop af
        ld a, (breg)            ;b
        ld b, a
        ld a, (creg)            ;c
        ld c, a
        ld a, (areg)            ;a
        ret

;*****************************************************************************
; DATA section
;*****************************************************************************
intro:
        .db "TI86MON 1.0  end:",0
author:
        .db "By: Steve Gordon",0
keyasctab:
        .db 26
        .db $0c,'X',$0d,'T',$0e,'O',$10,'E',$11,'H',$12,'I',$16,'=',$18,'P'
        .db $1b,'.',$1c,'0',$1d,'1',$1e,'2',$1f,'3',$20,'4',$21,'5',$22,'6'
        .db $23,'7',$24,'8',$25,'9',$26,'G',$60,'B',$62,'C',$64,'D',$66,'K'
        .db $68,'F',$6A,'A'
helptxt:                         ;
        .db "0-9,A-F enter digit  "
        .db "G:Go H:searcH I:In   "
        .db "K:blocKmov O:Out     "
        .db "P:dumP T:getregaddr  "
        .db "X:dis <CLEAR>:clrscn "
        .db "<F1>:help <F2>miniasm"
        .db "<F2>:asm <F3-5>:dpfmt",0
numpar: .db $00
param0: .dw $0000
param1: .dw $0000
param2: .dw $0000
param3: .dw $0000
param4: .dw $0000
param5: .dw $0000
param6: .dw $0000
param7: .dw $0000
param8: .dw $0000 
param9: .dw $0000
parama: .dw $0000
regist: 
areg:   .db $00
freg:   .db $00
breg:   .db $00
creg:   .db $00
dreg:   .db $00
ereg:   .db $00
hreg:   .db $00
lreg:   .db $00
ireg:   .db $00
xreg:   .dw $0000
yreg:   .dw $0000
pcreg:  .dw $0000
rreg:   .db $00
spreg:  .dw $0000
arareg: .db $00
arfreg: .db $00
arbreg: .db $00
arcreg: .db $00
ardreg: .db $00
arereg: .db $00
arhreg: .db $00
arlreg: .db $00
dumptyp:.db $00
addrinc:.db $04
instsz: .db $01
op:     .db $00
temp1:  .db $00
temp2:  .dw $0000
cmdline:.db 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .db 0,0,0,0,0,0
masmmsg:.db "MASM (NOT YET)",0
dpt1msg:.db "DUMPNORM",0
dpt2msg:.db "DUMPHEX",0
dpt3msg:.db "DUMPASC",0
notfndmsg:
        .db "NOT FOUND",0
cctab:
        .db 0,0,"C",0,"NC",0,"Z",0,"NZ",0,"PO",0,"PE",0,"P",0,"M",0,
regtab:
        .db "A",0,"F",0,"B",0,"C",0,"D",0,"E",0,"H",0,"L",0,
        .db "I",0,"R",0,0,0,"IXH",0,"IXL",0,"IYH",0,"IYL",0,         ;37
        .db "AF",0,"BC",0,"DE",0,"HL",0,"IX",0,"IY",0,"SP",0,"PC",0

mnutab:
        .db "ADC",0,"ADD",0,"AND",0,"BIT",0,"CALL",0,"CCF",0,    ;24d  18h
        .db "CP",0,"CPD",0,"CPDR",0,"CPI",0,"CPIR",0,"CPL",0,    ;49d  31h
        .db "DAA",0,"DEC",0,"DI",0,"DJNZ",0,"EI",0,"EX",0,       ;71d  47h
        .db "EXX",0,"HALT",0,"IM",0,"IN",0,"INC",0,"IND",0,      ;94d  5eh
        .db "INDR",0,"INI",0,"INIR",0,"JP",0,"JR",0,"LD",0,      ;117d 75h
        .db "LDD",0,"LDDR",0,"LDI",0,"LDIR",0,"NEG",0,"NOP",0,   ;143d 8fh
        .db "OR",0,"OTDR",0,"OTIR",0,"OUT",0,"OUTD",0,"OUTI",0,  ;170d aah
        .db "POP",0,"PUSH",0,"RES",0,"RET",0,"RETI",0,"RETN",0   ;197d c5h      
        .db "ROL",0,"RLA",0,"RLC",0,"RLCA",0,"RLD",0,"RR",0,     ;221d ddh
        .db "RRA",0,"RRC",0,"RRCA",0,"RRD",0,"RST",0,"SBC",0,    ;246d f6h
        .db "SCF",0,"SET",0,"SLA",0,"SRA",0,"SRL",0,"SUB",0,     ;270d 10eh
        .db "XOR",0,"EX AF,AF",$27,0,"RST $0",0,"RST $8",0,      ;298d 12ah
        .db "RST $10",0,"RST $18",0,"RST $20",0,                 ;142h
        .db "RST $28",0,"RST $30",0,"RST $38",0,"???",0,"RL",0   ;161h

invalidins:
        .db "???",0

;fmt:   0[7]=mnutabptrhi
;       0[6,5,4]=type,
;       0[3,2,1,0]=instruction len,
;       1=mnutabptr
;       2=p0
;       3=p1
;
;type:  0=none                  p0,p1=unused
;       1=src/dst               p0=dstmode/dst,p1=srcmode/p3=src
;       2=dst                   p0=dstmode/dst,p1=unused
;       3=branch                p0=cc,p1=dstmode/dst
;
;mode:  0=none
;       1=immediate             
;       2=16bit immediate       
;       3=8bit relative         
;       4=extended (direct)     
;       5=register indirect indexed (xx+n)   
;       6=8bit register
;       7=16bit register
;       8=16bit register indirect     
;       9=bit
;       a=zeropage
;       b=ret
;       c=pc relative (PC+e)
;       d=literal
;       e=8bit register indirect
;
;cc:    0=none
;       1=c
;       2=nc
;       3=z
;       4=nz
;       5=po
;       6=pe
;       7=p
;       8=m
;
;sd:reg8
;       0=A,1=F,2=B,3=C,4=D,5=E,6=h,7=l,8=I,9=R,a=a(imp),b=ixh,c=ixl,d=iyh,e=iyl
;sd:reg16
;       0=AF,1=BC,2=DE,3=HL,4=IX,5=IY,6=SP,7=PC
;sd:regind
;       0=(AF),1=(BC),2=(DE),3=(HL),4=(IX),5=(IY),6=(SP),7=(PC)
;sd:imm16
;       instrction offset to word
;sd:imm8
;       instruction offset to byte      sssss
instrtab:
        .db $01,$8c,$00,$00             ;nop            ;00
        .db $13,$73,$71,$21             ;ld bc,nn
        .db $11,$73,$81,$60             ;ld (bc),a
        .db $21,$57,$71,$00             ;inc bc
        .db $21,$57,$62,$00             ;inc b
        .db $21,$36,$62,$00             ;dec b
        .db $12,$73,$62,$11             ;ld b,n
        .db $01,$d2,$00,$00             ;rlca
        .db $81,$13,$00,$00             ;xc af,af'
        .db $11,$04,$73,$71             ;add hl,bc
        .db $11,$73,$60,$81             ;ld a,(bc)
        .db $21,$36,$71,$00             ;dec bc
        .db $21,$57,$63,$00             ;inc c
        .db $21,$36,$63,$00             ;dec c
        .db $12,$73,$63,$11             ;ld c,n
        .db $01,$e6,$00,$00             ;rrca
        .db $32,$3d,$00,$c1             ;djnz (pc+e)        ;10
        .db $13,$73,$72,$21             ;ld de,nn
        .db $11,$73,$82,$60             ;ld (de),a
        .db $21,$57,$72,$00             ;inc de
        .db $21,$57,$64,$00             ;inc d
        .db $21,$36,$64,$00             ;dec d
        .db $12,$73,$64,$11             ;ld d,n
        .db $01,$ca,$00,$00             ;rla
        .db $32,$70,$00,$c1             ;jr (pc+e)
        .db $11,$04,$73,$72             ;add hl,de
        .db $11,$73,$60,$82             ;ld a,(de)
        .db $21,$36,$72,$00             ;dec de
        .db $21,$57,$65,$00             ;inc e
        .db $21,$36,$65,$00             ;dec e
        .db $12,$73,$65,$11             ;ld e,n
        .db $01,$de,$00,$00             ;rra
        .db $32,$70,$04,$c1             ;jr nz,(pc+e)   ;20
        .db $13,$73,$73,$21             ;ld hl,nn
        .db $13,$73,$41,$73             ;ld (nn),hl
        .db $21,$57,$73,$00             ;inc hl
        .db $21,$57,$66,$00             ;inc h
        .db $21,$36,$66,$00             ;dec h
        .db $12,$73,$66,$11             ;ld h,n
        .db $01,$32,$00,$00             ;daa
        .db $32,$70,$03,$c1             ;jr z,(pc+e)
        .db $11,$04,$73,$73             ;add hl,hl
        .db $13,$73,$73,$41             ;ld hl,(nn)
        .db $21,$36,$73,$00             ;dec hl
        .db $21,$57,$67,$00             ;inc l
        .db $21,$36,$67,$00             ;dec l
        .db $12,$73,$67,$11             ;ld l,n
        .db $01,$2e,$00,$00             ;cpl
        .db $32,$70,$02,$c1             ;jr nc,(pc+e)   ;$30
        .db $13,$73,$76,$21             ;ld sp,nn
        .db $13,$73,$41,$60             ;ld (nn),a
        .db $21,$57,$76,$00             ;inc sp
        .db $21,$57,$83,$00             ;inc (hl)
        .db $21,$36,$83,$00             ;dec (hl)
        .db $12,$73,$83,$11             ;ld (hl),n
        .db $01,$f7,$00,$00             ;scf
        .db $32,$70,$01,$c1             ;jr c,(pc+e)
        .db $11,$04,$73,$76             ;add hl,sp
        .db $13,$73,$60,$41             ;ld a,(nn)
        .db $21,$36,$76,$00             ;dec sp
        .db $21,$57,$60,$00             ;inc a
        .db $21,$36,$60,$00             ;dec a
        .db $12,$73,$60,$11             ;ld a,n
        .db $01,$15,$00,$00             ;ccf
        .db $11,$73,$62,$62             ;ld b,b         ;40
        .db $11,$73,$62,$63             ;ld b,c
        .db $11,$73,$62,$64             ;ld b,d
        .db $11,$73,$62,$65             ;ld b,e
        .db $11,$73,$62,$66             ;ld b,h
        .db $11,$73,$62,$67             ;ld b,l
        .db $11,$73,$62,$83             ;ld b,(hl)
        .db $11,$73,$62,$60             ;ld b,a
        .db $11,$73,$63,$62             ;ld c,b
        .db $11,$73,$63,$63             ;ld c,c
        .db $11,$73,$63,$64             ;ld c,d
        .db $11,$73,$63,$65             ;ld c,e
        .db $11,$73,$63,$66             ;ld c,h
        .db $11,$73,$63,$67             ;ld c,l
        .db $11,$73,$63,$83             ;ld c,(hl)
        .db $11,$73,$63,$60             ;ld c,a
        .db $11,$73,$64,$62             ;ld d,b         ;50
        .db $11,$73,$64,$63             ;ld d,c
        .db $11,$73,$64,$64             ;ld d,d
        .db $11,$73,$64,$65             ;ld d,e
        .db $11,$73,$64,$66             ;ld d,h
        .db $11,$73,$64,$67             ;ld d,l
        .db $11,$73,$64,$83             ;ld d,(hl)
        .db $11,$73,$64,$60             ;ld d,a
        .db $11,$73,$65,$62             ;ld e,b
        .db $11,$73,$65,$63             ;ld e,c
        .db $11,$73,$65,$64             ;ld e,d
        .db $11,$73,$65,$65             ;ld e,e
        .db $11,$73,$65,$66             ;ld e,h
        .db $11,$73,$65,$67             ;ld e,l
        .db $11,$73,$65,$83             ;ld e,(hl)
        .db $11,$73,$65,$60             ;ld e,a
        .db $11,$73,$66,$62             ;ld h,b         ;60
        .db $11,$73,$66,$63             ;ld h,c
        .db $11,$73,$66,$64             ;ld h,d
        .db $11,$73,$66,$65             ;ld h,e
        .db $11,$73,$66,$66             ;ld h,h
        .db $11,$73,$66,$67             ;ld h,l
        .db $11,$73,$66,$83             ;ld h,(hl)
        .db $11,$73,$66,$60             ;ld h,a
        .db $11,$73,$67,$62             ;ld l,b
        .db $11,$73,$67,$63             ;ld l,c
        .db $11,$73,$67,$64             ;ld l,d
        .db $11,$73,$67,$65             ;ld l,e
        .db $11,$73,$67,$66             ;ld l,h
        .db $11,$73,$67,$67             ;ld l,l
        .db $11,$73,$67,$83             ;ld l,(hl)
        .db $11,$73,$67,$60             ;ld l,a
        .db $11,$73,$83,$62             ;ld (hl),b      ;70
        .db $11,$73,$83,$63             ;ld (hl),c
        .db $11,$73,$83,$64             ;ld (hl),d
        .db $11,$73,$83,$65             ;ld (hl),e
        .db $11,$73,$83,$66             ;ld (hl),h
        .db $11,$73,$83,$67             ;ld (hl),l      ;75
        .db $01,$4c,$00,$00             ;halt
        .db $11,$73,$83,$60             ;ld (hl),a
        .db $11,$73,$60,$62             ;ld a,b
        .db $11,$73,$60,$63             ;ld a,c
        .db $11,$73,$60,$64             ;ld a,d
        .db $11,$73,$60,$65             ;ld a,e
        .db $11,$73,$60,$66             ;ld a,h
        .db $11,$73,$60,$67             ;ld a,l
        .db $11,$73,$60,$83             ;ld a,(hl)
        .db $11,$73,$60,$60             ;ld a,a
        .db $11,$04,$60,$62             ;add a,b        ;80
        .db $11,$04,$60,$63             ;add a,c
        .db $11,$04,$60,$64             ;add a,d
        .db $11,$04,$60,$65             ;add a,e
        .db $11,$04,$60,$66             ;add a,h
        .db $11,$04,$60,$67             ;add a,l
        .db $11,$04,$60,$83             ;add a,(hl)
        .db $11,$04,$60,$60             ;add a,a
        .db $11,$00,$60,$62             ;adc a,b
        .db $11,$00,$60,$63             ;adc a,c
        .db $11,$00,$60,$64             ;adc a,d
        .db $11,$00,$60,$65             ;adc a,e
        .db $11,$00,$60,$66             ;adc a,h
        .db $11,$00,$60,$67             ;adc a,l
        .db $11,$00,$60,$83             ;adc a,(hl)
        .db $11,$00,$60,$60             ;adc a,a
        .db $91,$0b,$6a,$62             ;sub b          ;90
        .db $91,$0b,$6a,$63             ;sub c
        .db $91,$0b,$6a,$64             ;sub d
        .db $91,$0b,$6a,$65             ;sub e
        .db $91,$0b,$6a,$66             ;sub h
        .db $91,$0b,$6a,$67             ;sub l
        .db $91,$0b,$6a,$83             ;sub (hl)
        .db $91,$0b,$6a,$60             ;sub a
        .db $11,$f3,$60,$62             ;sbc a,b
        .db $11,$f3,$60,$63             ;sbc a,c
        .db $11,$f3,$60,$64             ;sbc a,d
        .db $11,$f3,$60,$65             ;sbc a,e
        .db $11,$f3,$60,$66             ;sbc a,h
        .db $11,$f3,$60,$67             ;sbc a,l
        .db $11,$f3,$60,$83             ;sbc a,(hl)
        .db $11,$f3,$60,$60             ;sbc a,a
        .db $11,$08,$6a,$62             ;and b          ;a0
        .db $11,$08,$6a,$63             ;and c
        .db $11,$08,$6a,$64             ;and d
        .db $11,$08,$6a,$65             ;and e
        .db $11,$08,$6a,$66             ;and h
        .db $11,$08,$6a,$67             ;and l
        .db $11,$08,$6a,$83             ;and (hl)
        .db $11,$08,$6a,$60             ;and a
        .db $91,$0f,$6a,$62             ;xor b
        .db $91,$0f,$6a,$63             ;xor c
        .db $91,$0f,$6a,$64             ;xor d
        .db $91,$0f,$6a,$65             ;xor e
        .db $91,$0f,$6a,$66             ;xor h
        .db $91,$0f,$6a,$67             ;xor l
        .db $91,$0f,$6a,$83             ;xor (hl)
        .db $91,$0f,$6a,$60             ;xor a
        .db $11,$90,$6a,$62             ;or b           ;b0
        .db $11,$90,$6a,$63             ;or c
        .db $11,$90,$6a,$64             ;or d
        .db $11,$90,$6a,$65             ;or e
        .db $11,$90,$6a,$66             ;or h
        .db $11,$90,$6a,$67             ;or l
        .db $11,$90,$6a,$83             ;or (hl)
        .db $11,$90,$6a,$60             ;or a
        .db $11,$19,$6a,$62             ;cp b
        .db $11,$19,$6a,$63             ;cp c
        .db $11,$19,$6a,$64             ;cp d
        .db $11,$19,$6a,$65             ;cp e
        .db $11,$19,$6a,$66             ;cp h
        .db $11,$19,$6a,$67             ;cp l
        .db $11,$19,$6a,$83             ;cp (hl)
        .db $11,$19,$6a,$60             ;cp a
        .db $31,$b8,$04,$b0             ;ret nz         ;c0
        .db $21,$ab,$71,$00             ;pop bc
        .db $33,$6d,$04,$21             ;jp nz,(nn)
        .db $33,$6d,$00,$21             ;jp (nn)
        .db $33,$10,$04,$21             ;call nz,(nn)
        .db $21,$af,$71,$00             ;push bc
        .db $12,$04,$60,$11             ;add a,n
        .db $81,$1d,$00,$00             ;rst 0h
        .db $31,$b8,$03,$b0             ;ret z
        .db $31,$b8,$00,$b0             ;ret
        .db $33,$6d,$03,$21             ;jp z,(nn)
        .db $81,$5b,$00,$00             ;CB INSTRUCTION SET     
        .db $33,$10,$03,$21             ;call z,(nn)
        .db $33,$10,$00,$21             ;call (nn)
        .db $12,$00,$60,$11             ;adc a,n
        .db $81,$24,$00,$00             ;rst 8h
        .db $31,$b8,$02,$b0             ;ret nc         ;d0
        .db $21,$ab,$72,$00             ;pop de
        .db $33,$6d,$02,$21             ;jp nc,(nn)
        .db $12,$9d,$a1,$60             ;out (n),a
        .db $33,$10,$02,$21             ;call nc,(nn)
        .db $21,$af,$72,$00             ;push de
        .db $92,$0b,$6a,$11             ;sub n
        .db $81,$2b,$00,$00             ;rst 10h
        .db $31,$b8,$01,$b0             ;ret c
        .db $01,$48,$00,$00             ;exx
        .db $33,$6d,$01,$21             ;jp c,(nn)
        .db $12,$54,$60,$a1             ;in a,(n)
        .db $33,$10,$01,$21             ;call c,(nn)
        .db $81,$5b,$00,$00             ;DD INSTRUCTION SET     ;dd
        .db $12,$f3,$60,$11             ;sbc a,n
        .db $81,$33,$00,$00             ;rst 18h
        .db $31,$b8,$05,$b0             ;ret po         ;e0
        .db $21,$ab,$73,$00             ;pop hl
        .db $33,$6d,$05,$21             ;jp po,(nn)
        .db $11,$45,$86,$73             ;ex (sp),hl
        .db $33,$10,$05,$21             ;call po,(nn)
        .db $21,$af,$73,$00             ;push hl
        .db $12,$08,$6a,$11             ;and n
        .db $81,$3b,$00,$00             ;rst 20h
        .db $31,$b8,$06,$b0             ;ret pe
        .db $31,$6d,$00,$83             ;jp (hl)
        .db $33,$6d,$06,$21             ;jp pe,(nn)     
        .db $11,$45,$72,$73             ;ex de,hl
        .db $33,$10,$06,$21             ;call pe,(nn)
        .db $81,$5b,$00,$00             ;ED INSTRUCTION SET
        .db $92,$0f,$6a,$11             ;xor n
        .db $81,$43,$00,$00             ;rst 28h
        .db $31,$b8,$07,$b0             ;ret p          ;f0
        .db $21,$ab,$70,$00             ;pop af
        .db $33,$6d,$07,$21             ;jp p,(nn)
        .db $01,$3a,$00,$00             ;di
        .db $33,$10,$07,$21             ;call p,(nn)
        .db $21,$af,$70,$00             ;push af
        .db $12,$90,$6a,$11             ;or n
        .db $81,$4b,$00,$00             ;rst 30h
        .db $31,$b8,$08,$b0             ;ret m
        .db $11,$73,$76,$73             ;ld sp,hl
        .db $33,$6d,$08,$21             ;jp m,(nn)
        .db $01,$42,$00,$00             ;ei
        .db $33,$10,$08,$21             ;call m,(nn)
        .db $81,$5b,$00,$00             ;FD INSTRUCTION SET
        .db $12,$19,$6a,$11             ;cp n
        .db $81,$53,$00,$00             ;rst 38h         ;ff

cbinstrtab:
        .db $22,$ce,$62,$00             ;rlc b
        .db $22,$ce,$63,$00             ;rlc c
        .db $22,$ce,$64,$00             ;rlc d
        .db $22,$ce,$65,$00             ;rlc e
        .db $22,$ce,$66,$00             ;rlc h
        .db $22,$ce,$67,$00             ;rlc l
        .db $22,$ce,$83,$00             ;rlc (hl)
        .db $22,$ce,$60,$00             ;rlc a
        .db $22,$e2,$62,$00             ;rrc b
        .db $22,$e2,$63,$00             ;rrc c
        .db $22,$e2,$64,$00             ;rrc d
        .db $22,$e2,$65,$00             ;rrc e
        .db $22,$e2,$66,$00             ;rrc h
        .db $22,$e2,$67,$00             ;rrc l
        .db $22,$e2,$83,$00             ;rrc (hl)
        .db $22,$e2,$60,$00             ;rrc a
        .db $a2,$5f,$62,$00             ;rl b
        .db $a2,$5f,$63,$00             ;rl c
        .db $a2,$5f,$64,$00             ;rl d
        .db $a2,$5f,$65,$00             ;rl e
        .db $a2,$5f,$66,$00             ;rl h
        .db $a2,$5f,$67,$00             ;rl l
        .db $a2,$5f,$83,$00             ;rl (hl)
        .db $a2,$5f,$60,$00             ;rl a
        .db $22,$db,$62,$00             ;rr b
        .db $22,$db,$63,$00             ;rr c
        .db $22,$db,$64,$00             ;rr d
        .db $22,$db,$65,$00             ;rr e
        .db $22,$db,$66,$00             ;rr h
        .db $22,$db,$67,$00             ;rr l
        .db $22,$db,$83,$00             ;rr (hl)
        .db $22,$db,$60,$00             ;rr a
        .db $22,$ff,$62,$00             ;sla b
        .db $22,$ff,$63,$00             ;sla c
        .db $22,$ff,$64,$00             ;sla d
        .db $22,$ff,$65,$00             ;sla e
        .db $22,$ff,$66,$00             ;sla h
        .db $22,$ff,$67,$00             ;sla l
        .db $22,$ff,$83,$00             ;sla (hl)
        .db $22,$ff,$60,$00             ;sla a
        .db $a2,$03,$62,$00             ;sra b
        .db $a2,$03,$63,$00             ;sra c
        .db $a2,$03,$64,$00             ;sra d
        .db $a2,$03,$65,$00             ;sra e
        .db $a2,$03,$66,$00             ;sra h
        .db $a2,$03,$67,$00             ;sra l
        .db $a2,$03,$83,$00             ;sra (hl)
        .db $a2,$03,$60,$00             ;sra a
        .db $81,$5b,$62,$00             ;sll b*
        .db $81,$5b,$63,$00             ;sll c*
        .db $81,$5b,$64,$00             ;sll d*
        .db $81,$5b,$65,$00             ;sll e*
        .db $81,$5b,$66,$00             ;sll h*
        .db $81,$5b,$67,$00             ;sll l*
        .db $81,$5b,$83,$00             ;sll (hl)*
        .db $81,$5b,$60,$00             ;sll a*
        .db $a2,$07,$62,$00             ;srl b
        .db $a2,$07,$63,$00             ;srl c
        .db $a2,$07,$64,$00             ;srl d
        .db $a2,$07,$65,$00             ;srl e
        .db $a2,$07,$66,$00             ;srl h
        .db $a2,$07,$67,$00             ;srl l
        .db $a2,$07,$83,$00             ;srl (hl)
        .db $a2,$07,$60,$00             ;srl a
        .db $12,$0c,$d0,$62             ;bit 0,b
        .db $12,$0c,$d0,$63             ;bit 0,c
        .db $12,$0c,$d0,$64             ;bit 0,d
        .db $12,$0c,$d0,$65             ;bit 0,e
        .db $12,$0c,$d0,$66             ;bit 0,h
        .db $12,$0c,$d0,$67             ;bit 0,l
        .db $12,$0c,$d0,$83             ;bit 0,(hl)
        .db $12,$0c,$d0,$60             ;bit 0,a
        .db $12,$0c,$d1,$62             ;bit 1,b
        .db $12,$0c,$d1,$63             ;bit 1,c
        .db $12,$0c,$d1,$64             ;bit 1,d
        .db $12,$0c,$d1,$65             ;bit 1,e
        .db $12,$0c,$d1,$66             ;bit 1,h
        .db $12,$0c,$d1,$67             ;bit 1,l
        .db $12,$0c,$d1,$83             ;bit 1,(hl)
        .db $12,$0c,$d1,$60             ;bit 1,a
        .db $12,$0c,$d2,$62             ;bit 2,b
        .db $12,$0c,$d2,$63             ;bit 2,c
        .db $12,$0c,$d2,$64             ;bit 2,d
        .db $12,$0c,$d2,$65             ;bit 2,e
        .db $12,$0c,$d2,$66             ;bit 2,h
        .db $12,$0c,$d2,$67             ;bit 2,l
        .db $12,$0c,$d2,$83             ;bit 2,(hl)
        .db $12,$0c,$d2,$60             ;bit 2,a
        .db $12,$0c,$d3,$62             ;bit 3,b
        .db $12,$0c,$d3,$63             ;bit 3,c
        .db $12,$0c,$d3,$64             ;bit 3,d
        .db $12,$0c,$d3,$65             ;bit 3,e
        .db $12,$0c,$d3,$66             ;bit 3,h
        .db $12,$0c,$d3,$67             ;bit 3,l
        .db $12,$0c,$d3,$83             ;bit 3,(hl)
        .db $12,$0c,$d3,$60             ;bit 3,a
        .db $12,$0c,$d4,$62             ;bit 4,b
        .db $12,$0c,$d4,$63             ;bit 4,c
        .db $12,$0c,$d4,$64             ;bit 4,d
        .db $12,$0c,$d4,$65             ;bit 4,e
        .db $12,$0c,$d4,$66             ;bit 4,h
        .db $12,$0c,$d4,$67             ;bit 4,l
        .db $12,$0c,$d4,$83             ;bit 4,(hl)
        .db $12,$0c,$d4,$60             ;bit 4,a
        .db $12,$0c,$d5,$62             ;bit 5,b
        .db $12,$0c,$d5,$63             ;bit 5,c
        .db $12,$0c,$d5,$64             ;bit 5,d
        .db $12,$0c,$d5,$65             ;bit 5,e
        .db $12,$0c,$d5,$66             ;bit 5,h
        .db $12,$0c,$d5,$67             ;bit 5,l
        .db $12,$0c,$d5,$83             ;bit 5,(hl)
        .db $12,$0c,$d5,$60             ;bit 5,a
        .db $12,$0c,$d6,$62             ;bit 6,b
        .db $12,$0c,$d6,$63             ;bit 6,c
        .db $12,$0c,$d6,$64             ;bit 6,d
        .db $12,$0c,$d6,$65             ;bit 6,e
        .db $12,$0c,$d6,$66             ;bit 6,h
        .db $12,$0c,$d6,$67             ;bit 6,l
        .db $12,$0c,$d6,$83             ;bit 6,(hl)
        .db $12,$0c,$d6,$60             ;bit 6,a
        .db $12,$0c,$d7,$62             ;bit 7,b
        .db $12,$0c,$d7,$63             ;bit 7,c
        .db $12,$0c,$d7,$64             ;bit 7,d
        .db $12,$0c,$d7,$65             ;bit 7,e
        .db $12,$0c,$d7,$66             ;bit 7,h
        .db $12,$0c,$d7,$67             ;bit 7,l
        .db $12,$0c,$d7,$83             ;bit 7,(hl)
        .db $12,$0c,$d7,$60             ;bit 7,a
        .db $12,$b4,$d0,$62             ;res 0,b
        .db $12,$b4,$d0,$63             ;res 0,c
        .db $12,$b4,$d0,$64             ;res 0,d
        .db $12,$b4,$d0,$65             ;res 0,e
        .db $12,$b4,$d0,$66             ;res 0,h
        .db $12,$b4,$d0,$67             ;res 0,l
        .db $12,$b4,$d0,$83             ;res 0,(hl)
        .db $12,$b4,$d0,$60             ;res 0,a
        .db $12,$b4,$d1,$62             ;res 1,b
        .db $12,$b4,$d1,$63             ;res 1,c
        .db $12,$b4,$d1,$64             ;res 1,d
        .db $12,$b4,$d1,$65             ;res 1,e
        .db $12,$b4,$d1,$66             ;res 1,h
        .db $12,$b4,$d1,$67             ;res 1,l
        .db $12,$b4,$d1,$83             ;res 1,(hl)
        .db $12,$b4,$d1,$60             ;res 1,a
        .db $12,$b4,$d2,$62             ;res 2,b
        .db $12,$b4,$d2,$63             ;res 2,c
        .db $12,$b4,$d2,$64             ;res 2,d
        .db $12,$b4,$d2,$65             ;res 2,e
        .db $12,$b4,$d2,$66             ;res 2,h
        .db $12,$b4,$d2,$67             ;res 2,l
        .db $12,$b4,$d2,$83             ;res 2,(hl)
        .db $12,$b4,$d2,$60             ;res 2,a
        .db $12,$b4,$d3,$62             ;res 3,b
        .db $12,$b4,$d3,$63             ;res 3,c
        .db $12,$b4,$d3,$64             ;res 3,d
        .db $12,$b4,$d3,$65             ;res 3,e
        .db $12,$b4,$d3,$66             ;res 3,h
        .db $12,$b4,$d3,$67             ;res 3,l
        .db $12,$b4,$d3,$83             ;res 3,(hl)
        .db $12,$b4,$d3,$60             ;res 3,a
        .db $12,$b4,$d4,$62             ;res 4,b
        .db $12,$b4,$d4,$63             ;res 4,c
        .db $12,$b4,$d4,$64             ;res 4,d
        .db $12,$b4,$d4,$65             ;res 4,e
        .db $12,$b4,$d4,$66             ;res 4,h
        .db $12,$b4,$d4,$67             ;res 4,l
        .db $12,$b4,$d4,$83             ;res 4,(hl)
        .db $12,$b4,$d4,$60             ;res 4,a
        .db $12,$b4,$d5,$62             ;res 5,b
        .db $12,$b4,$d5,$63             ;res 5,c
        .db $12,$b4,$d5,$64             ;res 5,d
        .db $12,$b4,$d5,$65             ;res 5,e
        .db $12,$b4,$d5,$66             ;res 5,h
        .db $12,$b4,$d5,$67             ;res 5,l
        .db $12,$b4,$d5,$83             ;res 5,(hl)
        .db $12,$b4,$d5,$60             ;res 5,a
        .db $12,$b4,$d6,$62             ;res 6,b
        .db $12,$b4,$d6,$63             ;res 6,c
        .db $12,$b4,$d6,$64             ;res 6,d
        .db $12,$b4,$d6,$65             ;res 6,e
        .db $12,$b4,$d6,$66             ;res 6,h
        .db $12,$b4,$d6,$67             ;res 6,l
        .db $12,$b4,$d6,$83             ;res 6,(hl)
        .db $12,$b4,$d6,$60             ;res 6,a
        .db $12,$b4,$d7,$62             ;res 7,b
        .db $12,$b4,$d7,$63             ;res 7,c
        .db $12,$b4,$d7,$64             ;res 7,d
        .db $12,$b4,$d7,$65             ;res 7,e
        .db $12,$b4,$d7,$66             ;res 7,h
        .db $12,$b4,$d7,$67             ;res 7,l
        .db $12,$b4,$d7,$83             ;res 7,(hl)
        .db $12,$b4,$d7,$60             ;res 7,a
        .db $12,$fb,$d0,$62             ;set 0,b
        .db $12,$fb,$d0,$63             ;set 0,c
        .db $12,$fb,$d0,$64             ;set 0,d
        .db $12,$fb,$d0,$65             ;set 0,e
        .db $12,$fb,$d0,$66             ;set 0,h
        .db $12,$fb,$d0,$67             ;set 0,l
        .db $12,$fb,$d0,$83             ;set 0,(hl)
        .db $12,$fb,$d0,$60             ;set 0,a
        .db $12,$fb,$d1,$62             ;set 1,b
        .db $12,$fb,$d1,$63             ;set 1,c
        .db $12,$fb,$d1,$64             ;set 1,d
        .db $12,$fb,$d1,$65             ;set 1,e
        .db $12,$fb,$d1,$66             ;set 1,h
        .db $12,$fb,$d1,$67             ;set 1,l
        .db $12,$fb,$d1,$83             ;set 1,(hl)
        .db $12,$fb,$d1,$60             ;set 1,a
        .db $12,$fb,$d2,$62             ;set 2,b
        .db $12,$fb,$d2,$63             ;set 2,c
        .db $12,$fb,$d2,$64             ;set 2,d
        .db $12,$fb,$d2,$65             ;set 2,e
        .db $12,$fb,$d2,$66             ;set 2,h
        .db $12,$fb,$d2,$67             ;set 2,l
        .db $12,$fb,$d2,$83             ;set 2,(hl)
        .db $12,$fb,$d2,$60             ;set 2,a
        .db $12,$fb,$d3,$62             ;set 3,b
        .db $12,$fb,$d3,$63             ;set 3,c
        .db $12,$fb,$d3,$64             ;set 3,d
        .db $12,$fb,$d3,$65             ;set 3,e
        .db $12,$fb,$d3,$66             ;set 3,h
        .db $12,$fb,$d3,$67             ;set 3,l
        .db $12,$fb,$d3,$83             ;set 3,(hl)
        .db $12,$fb,$d3,$60             ;set 3,a
        .db $12,$fb,$d4,$62             ;set 4,b
        .db $12,$fb,$d4,$63             ;set 4,c
        .db $12,$fb,$d4,$64             ;set 4,d
        .db $12,$fb,$d4,$65             ;set 4,e
        .db $12,$fb,$d4,$66             ;set 4,h
        .db $12,$fb,$d4,$67             ;set 4,l
        .db $12,$fb,$d4,$83             ;set 4,(hl)
        .db $12,$fb,$d4,$60             ;set 4,a
        .db $12,$fb,$d5,$62             ;set 5,b
        .db $12,$fb,$d5,$63             ;set 5,c
        .db $12,$fb,$d5,$64             ;set 5,d
        .db $12,$fb,$d5,$65             ;set 5,e
        .db $12,$fb,$d5,$66             ;set 5,h
        .db $12,$fb,$d5,$67             ;set 5,l
        .db $12,$fb,$d5,$83             ;set 5,(hl)
        .db $12,$fb,$d5,$60             ;set 5,a
        .db $12,$fb,$d6,$62             ;set 6,b
        .db $12,$fb,$d6,$63             ;set 6,c
        .db $12,$fb,$d6,$64             ;set 6,d
        .db $12,$fb,$d6,$65             ;set 6,e
        .db $12,$fb,$d6,$66             ;set 6,h
        .db $12,$fb,$d6,$67             ;set 6,l
        .db $12,$fb,$d6,$83             ;set 6,(hl)
        .db $12,$fb,$d6,$60             ;set 6,a
        .db $12,$fb,$d7,$62             ;set 7,b
        .db $12,$fb,$d7,$63             ;set 7,c
        .db $12,$fb,$d7,$64             ;set 7,d
        .db $12,$fb,$d7,$65             ;set 7,e
        .db $12,$fb,$d7,$66             ;set 7,h
        .db $12,$fb,$d7,$67             ;set 7,l
        .db $12,$fb,$d7,$83             ;set 7,(hl)
        .db $12,$fb,$d7,$60             ;set 7,a

ddinstrtab:
        .db 39
        .db $09,$12,$04,$74,$71         ;add ix,bc
        .db $19,$12,$04,$74,$72         ;add ix,de
        .db $21,$14,$73,$74,$22         ;ld ix,nn
        .db $22,$14,$73,$42,$74         ;ld (nn),ix
        .db $23,$22,$57,$74,$00         ;inc ix
        .db $29,$12,$04,$74,$74         ;add ix,ix
        .db $2a,$14,$73,$74,$42         ;ld ix,(nn)
        .db $2b,$22,$36,$74,$00         ;dec ix
        .db $34,$23,$57,$54,$00         ;inc (ix+d)
        .db $35,$23,$36,$54,$00         ;dec (ix+d)
        .db $36,$14,$73,$54,$13         ;ld (ix+d),n
        .db $39,$12,$04,$74,$76         ;add ix,sp
        .db $46,$13,$73,$62,$54         ;ld b,(ix+d)
        .db $4e,$13,$73,$63,$54         ;ld c,(ix+d)
        .db $56,$13,$73,$64,$54         ;ld d,(ix+d)
        .db $5e,$13,$73,$65,$54         ;ld e,(ix+d)
        .db $66,$13,$73,$66,$54         ;ld h,(ix+d)
        .db $6e,$13,$73,$67,$54         ;ld l,(ix+d)
        .db $70,$13,$73,$54,$62         ;ld (ix+d),b
        .db $71,$13,$73,$54,$63         ;ld (ix+d),c
        .db $72,$13,$73,$54,$64         ;ld (ix+d),d
        .db $73,$13,$73,$54,$65         ;ld (ix+d),e
        .db $74,$13,$73,$54,$66         ;ld (ix+d),h
        .db $75,$13,$73,$54,$67         ;ld (ix+d),l
        .db $77,$13,$73,$54,$60         ;ld (ix+d),a
        .db $7e,$13,$73,$60,$54         ;ld a,(ix+d)
        .db $86,$13,$04,$60,$54         ;add a,(ix+d)
        .db $8e,$13,$00,$60,$54         ;adc a,(ix+d)
        .db $96,$93,$0b,$6a,$54         ;sub (ix+d)
        .db $9e,$13,$f3,$60,$54         ;sbc a,(ix+d)
        .db $a6,$13,$08,$6a,$54         ;and (ix+d)
        .db $ae,$93,$0f,$6a,$54         ;xor (ix+d)
        .db $b6,$13,$90,$6a,$54         ;or (ix+d)
        .db $be,$13,$19,$6a,$54         ;cp (ix+d)
        .db $e1,$22,$ab,$74,$00         ;pop ix
        .db $e3,$12,$45,$86,$74         ;ex (sp),ix
        .db $e5,$22,$af,$74,$00         ;push ix
        .db $e9,$32,$6d,$00,$84         ;jp (ix)
        .db $f9,$12,$73,$76,$74         ;ld sp,ix

ddcbinstrtab:
        .db 31
        .db $06,$24,$ce,$54,$00         ;rlc (ix+d)
        .db $0e,$24,$e2,$54,$00         ;rrc (ix+d)
        .db $16,$a4,$5f,$54,$00         ;rl (ix+d)
        .db $1e,$24,$db,$54,$00         ;rr (ix+d)
        .db $26,$24,$ff,$54,$00         ;sla (ix+d)
        .db $2e,$a4,$03,$54,$00         ;sra (ix+d)
        .db $3e,$a4,$07,$54,$00         ;srl (ix+d)
        .db $46,$14,$0c,$d0,$54         ;bit 0,(ix+d)
        .db $4e,$14,$0c,$d1,$54         ;bit 1,(ix+d)
        .db $56,$14,$0c,$d2,$54         ;bit 2,(ix+d)
        .db $5e,$14,$0c,$d3,$54         ;bit 3,(ix+d)
        .db $66,$14,$0c,$d4,$54         ;bit 4,(ix+d)
        .db $6e,$14,$0c,$d5,$54         ;bit 5,(ix+d)
        .db $76,$14,$0c,$d6,$54         ;bit 6,(ix+d)
        .db $7e,$14,$0c,$d7,$54         ;bit 7,(ix+d)
        .db $86,$14,$b4,$d0,$54         ;res 0,(ix+d)
        .db $8e,$14,$b4,$d1,$54         ;res 1,(ix+d)
        .db $96,$14,$b4,$d2,$54         ;res 2,(ix+d)
        .db $9e,$14,$b4,$d3,$54         ;res 3,(ix+d)
        .db $a6,$14,$b4,$d4,$54         ;res 4,(ix+d)
        .db $ae,$14,$b4,$d5,$54         ;res 5,(ix+d)    
        .db $b6,$14,$b4,$d6,$54         ;res 6,(ix+d)
        .db $be,$14,$b4,$d7,$54         ;res 7,(ix+d)
        .db $c6,$14,$fb,$d0,$54         ;set 0,(ix+d)
        .db $ce,$14,$fb,$d1,$54         ;set 1,(ix+d)
        .db $d6,$14,$fb,$d2,$54         ;set 2,(ix+d)
        .db $de,$14,$fb,$d3,$54         ;set 3,(ix+d)
        .db $e6,$14,$fb,$d4,$54         ;set 4,(ix+d)
        .db $ee,$14,$fb,$d5,$54         ;set 5,(ix+d)
        .db $f6,$14,$fb,$d6,$54         ;set 6,(ix+d)
        .db $fe,$14,$fb,$d7,$54         ;set 7,(ix+d)

fdinstrtab:
        .db 39
        .db $09,$12,$04,$75,$71         ;add iy,bc
        .db $19,$12,$04,$75,$72         ;add iy,de
        .db $21,$14,$73,$75,$22         ;ld iy,nn
        .db $22,$14,$73,$42,$75         ;ld (nn),iy
        .db $23,$22,$57,$75,$00         ;inc iy
        .db $29,$12,$04,$75,$75         ;add iy,iy
        .db $2a,$14,$73,$75,$42         ;ld iy,(nn)
        .db $2b,$22,$36,$75,$00         ;dec iy
        .db $34,$23,$57,$55,$00         ;inc (iy+d)
        .db $35,$23,$36,$55,$00         ;dec (iy+d)
        .db $36,$14,$73,$55,$13         ;ld (iy+d),n
        .db $39,$12,$04,$75,$76         ;add iy,sp
        .db $46,$13,$73,$62,$55         ;ld b,(iy+d)
        .db $4e,$13,$73,$63,$55         ;ld c,(iy+d)
        .db $56,$13,$73,$64,$55         ;ld d,(iy+d)
        .db $5e,$13,$73,$65,$55         ;ld e,(iy+d)
        .db $66,$13,$73,$66,$55         ;ld h,(iy+d)
        .db $6e,$13,$73,$67,$55         ;ld l,(iy+d)
        .db $70,$13,$73,$55,$62         ;ld (iy+d),b
        .db $71,$13,$73,$55,$63         ;ld (iy+d),c
        .db $72,$13,$73,$55,$64         ;ld (iy+d),d
        .db $73,$13,$73,$55,$65         ;ld (iy+d),e
        .db $74,$13,$73,$55,$66         ;ld (iy+d),h
        .db $75,$13,$73,$55,$67         ;ld (iy+d),l
        .db $77,$13,$73,$55,$60         ;ld (iy+d),a
        .db $7e,$13,$73,$60,$55         ;ld a,(iy+d)
        .db $86,$13,$04,$60,$55         ;add a,(iy+d)
        .db $8e,$13,$00,$60,$55         ;adc a,(iy+d)
        .db $96,$93,$0b,$6a,$55         ;sub (iy+d)
        .db $9e,$13,$f3,$60,$55         ;sbc a,(iy+d)
        .db $a6,$13,$08,$6a,$55         ;and (iy+d)
        .db $ae,$93,$0f,$6a,$55         ;xor (iy+d)
        .db $b6,$13,$90,$6a,$55         ;or (iy+d)
        .db $be,$13,$19,$6a,$55         ;cp (iy+d)
        .db $e1,$22,$ab,$75,$00         ;pop iy
        .db $e3,$12,$45,$86,$75         ;ex (sp),iy
        .db $e5,$22,$af,$75,$00         ;push iy
        .db $e9,$32,$6d,$00,$85         ;jp (iy)
        .db $f9,$12,$73,$76,$75         ;ld sp,iy

fdcbinstrtab:
        .db 31
        .db $06,$24,$ce,$55,$00         ;rlc (iy+d)
        .db $0e,$24,$e2,$55,$00         ;rrc (iy+d)
        .db $16,$a4,$5f,$55,$00         ;rl (iy+d)
        .db $1e,$24,$db,$55,$00         ;rr (iy+d)
        .db $26,$24,$ff,$55,$00         ;sla (iy+d)
        .db $2e,$a4,$03,$55,$00         ;sra (iy+d)
        .db $3e,$a4,$07,$55,$00         ;srl (iy+d)
        .db $46,$14,$0c,$d0,$55         ;bit 0,(iy+d)
        .db $4e,$14,$0c,$d1,$55         ;bit 1,(iy+d)
        .db $56,$14,$0c,$d2,$55         ;bit 2,(iy+d)
        .db $5e,$14,$0c,$d3,$55         ;bit 3,(iy+d)
        .db $66,$14,$0c,$d4,$55         ;bit 4,(iy+d)
        .db $6e,$14,$0c,$d5,$55         ;bit 5,(iy+d)
        .db $76,$14,$0c,$d6,$55         ;bit 6,(iy+d)
        .db $7e,$14,$0c,$d7,$55         ;bit 7,(iy+d)
        .db $86,$14,$b4,$d0,$55         ;res 0,(iy+d)
        .db $8e,$14,$b4,$d1,$55         ;res 1,(iy+d)
        .db $96,$14,$b4,$d2,$55         ;res 2,(iy+d)
        .db $9e,$14,$b4,$d3,$55         ;res 3,(iy+d)
        .db $a6,$14,$b4,$d4,$55         ;res 4,(iy+d)
        .db $ae,$14,$b4,$d5,$55         ;res 5,(iy+d)    
        .db $b6,$14,$b4,$d6,$55         ;res 6,(iy+d)
        .db $be,$14,$b4,$d7,$55         ;res 7,(iy+d)
        .db $c6,$14,$fb,$d0,$55         ;set 0,(iy+d)
        .db $ce,$14,$fb,$d1,$55         ;set 1,(iy+d)
        .db $d6,$14,$fb,$d2,$55         ;set 2,(iy+d)
        .db $de,$14,$fb,$d3,$55         ;set 3,(iy+d)
        .db $e6,$14,$fb,$d4,$55         ;set 4,(iy+d)
        .db $ee,$14,$fb,$d5,$55         ;set 5,(iy+d)
        .db $f6,$14,$fb,$d6,$55         ;set 6,(iy+d)
        .db $fe,$14,$fb,$d7,$55         ;set 7,(iy+d)

edinstrtab:
        .db 58
        .db $40,$12,$54,$62,$e3         ;in b,(c)
        .db $41,$12,$9d,$e3,$62         ;out (c),b
        .db $42,$12,$f3,$73,$71         ;sbc hl,bc
        .db $43,$14,$73,$42,$71         ;ld (nn),bc
        .db $44,$02,$88,$00,$00         ;neg
        .db $45,$32,$c1,$00,$b0         ;retn
        .db $46,$22,$51,$d0,$00         ;im 0
        .db $47,$12,$73,$68,$60         ;ld i,a
        .db $48,$12,$54,$63,$e3         ;in c,(c)
        .db $49,$12,$9d,$e3,$63         ;out (c),c
        .db $4a,$12,$00,$73,$71         ;adc hl,bc
        .db $4b,$14,$73,$71,$42         ;ld bc,(nn)
        .db $4d,$32,$bc,$00,$b0         ;reti
        .db $4f,$12,$73,$69,$60         ;ld r,a
        .db $50,$12,$54,$64,$e3         ;in d,(c)
        .db $51,$12,$9d,$e3,$64         ;out (c),d
        .db $52,$12,$f3,$73,$72         ;sbc hl,de
        .db $53,$14,$73,$42,$72         ;ld (nn),de
        .db $56,$22,$51,$d1,$00         ;im 1
        .db $57,$12,$73,$60,$68         ;ld a,i
        .db $58,$12,$54,$65,$e3         ;in e,(c)
        .db $59,$12,$9d,$e3,$65         ;out (c),e
        .db $5a,$12,$00,$73,$72         ;adc hl,de
        .db $5b,$14,$73,$72,$42         ;ld de,(nn)
        .db $5e,$22,$51,$d2,$00         ;im 2
        .db $5f,$12,$73,$60,$69         ;ld a,r
        .db $60,$12,$54,$66,$e3         ;in h,(c)
        .db $61,$12,$9d,$e3,$66         ;out (c),h
        .db $62,$12,$f3,$73,$73         ;sbc hl,hl
        .db $63,$14,$73,$42,$73         ;ld (nn),hl
        .db $67,$02,$eb,$00,$00         ;rrd
        .db $68,$12,$54,$67,$e3         ;in l,(c)
        .db $69,$12,$9d,$e3,$67         ;out (c),l
        .db $6a,$12,$00,$73,$73         ;adc hl,hl
        .db $6b,$14,$73,$73,$42         ;ld hl,(nn)
        .db $6f,$02,$d7,$00,$00         ;rld
        .db $72,$12,$f3,$73,$76         ;sbc hl,sp
        .db $73,$14,$73,$42,$76         ;ld (nn),sp 
        .db $78,$12,$54,$60,$e3         ;in a,(c)
        .db $79,$12,$9d,$e3,$60         ;out (c),a
        .db $7a,$12,$00,$73,$76         ;adc hl,sp
        .db $7b,$14,$73,$76,$42         ;ld sp,(nn)
        .db $a0,$02,$7f,$00,$00         ;ldi
        .db $a1,$02,$25,$00,$00         ;cpi
        .db $a2,$02,$64,$00,$00         ;ini
        .db $a3,$02,$a6,$00,$00         ;outi
        .db $a8,$02,$76,$00,$00         ;ldd
        .db $a9,$02,$1c,$00,$00         ;cpd
        .db $aa,$02,$5b,$00,$00         ;ind
        .db $ab,$02,$a1,$00,$00         ;outd
        .db $b0,$02,$83,$00,$00         ;ldir
        .db $b1,$02,$29,$00,$00         ;cpir
        .db $b2,$02,$68,$00,$00         ;inir
        .db $b3,$02,$98,$00,$00         ;otir
        .db $b8,$02,$7a,$00,$00         ;lddr
        .db $b9,$02,$20,$00,$00         ;cpdr
        .db $ba,$02,$5f,$00,$00         ;indr
        .db $bb,$02,$93,$00,$00         ;otdr
        ;702 total instructions
endprog:
.end

