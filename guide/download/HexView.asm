;--------------------------------------------------------------------------------
;By John Kempen
;
;Most of this code is mine, with the exception of the Mode 1 Interrupt code.
;
;If you use some of my code, please give me credit for it somewhere.
;
;
;E-mail me if you have any comments or questions:
;saywhat97@hotmail.com
;---------------------------------------------------------------------------------
#include "asm86.h"
#include "ti86asm.inc"
#include "ti86abs.inc"

freespace = $ed00								;temporary storage
xlevelstable = freespace
morefree = $f600
rowmax = morefree
colmax = morefree+1
nodata = morefree+2
rlast = morefree+3
clast = morefree+4
c = morefree+5
sizeoff = morefree+6
tsize = morefree+7
noscroll = morefree+9
menurow = morefree+10
rowl = morefree+11
r = morefree+12
exittoquit = morefree+13
up_down = morefree+15
mr = morefree+16
prow = morefree+18
pcol = morefree+19
symlocate = morefree+20
xlevelsnum = morefree+22
xtableloc = morefree+23
chrleft = morefree+25
copysource = morefree+26
copyoffset = morefree+28
type = morefree+30
size = morefree+31
hexchars = morefree+33
mrlast = morefree+42
rlastsave = morefree+44
clastsave = morefree+45
rsave = morefree+46
csave = morefree+47
mrsave = morefree+48
graphrow = morefree+50
value = morefree+51
maxvalue = morefree+52
pr = morefree+53
pageloaded = morefree+54
Addressoffset = morefree+55
maxlevs =morefree+57
lev = morefree+58
mscroll = morefree+59
retto = morefree+60
putzloc = morefree+62
next = morefree+64

.org _asm_exec_ram
	nop
	jp start
	.dw $0000
	.dw name
start
	call $49DC	
	res 0,(iy+18)
	res 2,(iy+13)
	ld a,$3c
	out (0),a
startselvar
	xor a										;does ld a,0
	ld (mscroll),a
	call installint
	call _clrScrn
	jr Selectwhat2load
End
	xor a										;does ld a,0
	ld (_curRow),a
	call _clrScrn
	set 0,(iy+18)
	set 2,(iy+13)
	res 2,(iy+$23)                      ; Disable user routine so IM 1 works "normally" again ;-)
	res 3,(iy+5)
	ld a,$3c
	out (0),a
	ret
mEnd
	pop hl
	jr End
Selectwhat2load2
	pop hl
Selectwhat2load
	call _clrLCD
	call Bydraw
	ld hl,End
	push hl
	ld a,1
	ld b,1
	ld hl,Selectwhattxt
	call putflines
Selectloadgetkey
	call _getkey
	cp k1
	jp z,Selectlevs
	cp k2
	jp z,Rampage
	cp k3
	jp z,Rompage
	cp k4
	jp z,About
	cp k5
	jr z,Help
	cp k6
	jr z,End
	cp kExit
	jr z,End	
	jr Selectloadgetkey
Help
	ld hl,textfiledata
	ld de,$c068
	ld bc,13
	ldir
	pop hl
	ld hl,variable-1
	rst 20h
	rst 10h
	jr c,noHelp
	set 2,(iy+$1F)
	call _clrLCD
	call Bydraw
	ld hl,variable-1
	rst 20h
	call $5730	;_exec_assembly
	jp start
noHelp
	call _clrLCD
	call Bydraw
	ld a,1
	ld (_curRow),a
	ld (_curCol),a
	ld hl,nohelpviewer
	call _puts
	call _getkey
	jp start
Rampage
	call _clrLCD
	call Bydraw
	ld a,2
	ld (_curRow),a
	ld a,1
	ld (_curCol),a
	ld hl,lrampage
	call _puts
	ld a,3
	ld (_curRow),a
	ld a,1
	ld (_curCol),a
	ld hl,Page
	call _puts
	xor a										;does ld a,0
	ld (lev),a
	ld a,7
	ld (maxlevs),a
	call Levelchange
	ld hl,pagetxt
	ld de,File_name+1
	ld bc,4
	ldir
	ld a,$20
	ld (File_name+5),a
	ld a,(lev)
	call atohex
	ld hl,hexchars+1
	ld de,File_name+6
	ld bc,3
	ldir
	ld a,(lev)
	ld b,%01000000
	add a,b
	out (6),a
	ld hl,$4000
	ld (size),hl
	ld (tsize),hl
	ld a,1
	ld (pageloaded),a
	ld a,$20
	ld (type),a
	ld a,(lev)
	cp 0
	jr z,rampage0selected
	ld hl,$8000
	ld (Addressoffset),hl
	jp Editbegin
rampage0selected
	ld hl,$C000
	ld (Addressoffset),hl
	jp Editbegin
Rompage
	call _clrLCD
	call Bydraw
	ld a,2
	ld (_curRow),a
	ld a,1
	ld (_curCol),a
	ld hl,lrompage
	call _puts
	ld a,3
	ld (_curRow),a
	ld a,1
	ld (_curCol),a
	ld hl,Page
	call _puts
	xor a										;does ld a,0
	ld (lev),a
	ld a,15
	ld (maxlevs),a
	call Levelchange
	ld hl,pagetxt
	ld de,File_name+1
	ld bc,4
	ldir
	ld a,$20
	ld (File_name+5),a
	ld a,(lev)
	call atohex
	ld hl,hexchars+1
	ld de,File_name+6
	ld bc,3
	ldir
	ld a,(lev)
	ld b,0
	add a,b
	out (6),a
	ld hl,$4000
	ld (size),hl
	ld (tsize),hl
	ld a,1
	ld (pageloaded),a
	ld a,$21
	ld (type),a
	ld a,(lev)
	cp 0
	jr z,rompage0selected
	ld hl,$4000
	ld (Addressoffset),hl
	jp Editbegin
rompage0selected
	ld hl,0
	ld (Addressoffset),hl
	jp Editbegin
About
	call _clrLCD
	call Bydraw
	xor a										;does ld a,0
	ld b,2
	ld hl,Abouttxt
	call putflines
	call _getkey
	cp kExit
	jp z,mEnd
	jp Selectwhat2load
Bydraw
	ld a,7
	call Invbar
	ld a,7
	ld (_curRow),a
	xor a										;does ld a,0
	ld (_curCol),a
	ld hl,bytext
	call _puts
	ld a,7
	ld (_curRow),a
	ld a,18
	ld (_curCol),a
	ld hl,versionnum
	call _puts
Namedraw
	xor a										;does ld a,0
	call Invbar
	xor a										;does ld a,0
	ld (_curRow),a
	ld (_curCol),a
	ld hl,nametext
	call _puts
	res 3,(iy+5)
	ret
Invbar
	set 3,(iy+5)
	push af
	ld hl,$c0f8
	ld a,$20
	ld (hl),a
	ld de,$c0f9
	ld bc,21
	ldir
	pop af
	ld (_curRow),a
	xor a										;does ld a,0
	ld ($c10e),a
	ld (_curCol),a
	ld hl,$c0f9
	call _puts
	ret
atodec
	ld b,a
	ld c,a
	xor a										;does ld a,0
	ld (hexchars),a
	ld (hexchars+1),a
	ld (hexchars+2),a
atodecloop
	ld a,b
	cp 0
	jr z,atodecfinish
	dec a
	ld b,a
	ld a,(hexchars+2)
	inc a
	cp 10
	jr z,atodecinc10
	ld (hexchars+2),a
	jr atodecloop
atodecinc10
	xor a										;does ld a,0
	ld (hexchars+2),a
	ld a,(hexchars+1)
	inc a
	cp 10
	jr z,atodecinc100
	ld (hexchars+1),a
	jr atodecloop
atodecinc100
	xor a										;does ld a,0
	ld (hexchars+1),a
	ld a,(hexchars)
	inc a
	ld (hexchars),a
	jr atodecloop
atodecfinish
	xor a										;does ld a,0
	ld (hexchars+3),a
	ld a,(hexchars)
	add a,$30
	ld (hexchars),a
	ld a,(hexchars+1)
	add a,$30
	ld (hexchars+1),a
	ld a,(hexchars+2)
	add a,$30
	ld (hexchars+2),a
	ld a,9
	cp c
	jr nc,notens
	ld a,99
	cp c
	jr nc,nohundreds
	ret
notens
	ld a,$20
	ld (hexchars+1),a
nohundreds
	ld a,$20
	ld (hexchars),a
	ret
atobin
	ld b,a
	or a
	and %10000000
	rl a
	rl a
	add a,$30
	ld (hexchars),a
	ld a,b
	or a
	and %01000000
	rl a
	rl a
	rl a	
	add a,$30
	ld (hexchars+1),a
	ld a,b
	or a
	and %00100000
	rl a
	rl a
	rl a
	rl a	
	add a,$30
	ld (hexchars+2),a
	ld a,b
	or a
	and %00010000
	rr a
	rr a
	rr a
	rr a	
	add a,$30
	ld (hexchars+3),a
	ld a,b
	or a
	and %00001000
	rr a
	rr a
	rr a	
	add a,$30
	ld (hexchars+4),a
	ld a,b
	or a
	and %00000100
	rr a
	rr a
	add a,$30
	ld (hexchars+5),a
	ld a,b
	or a
	and %00000010
	rr a
	add a,$30
	ld (hexchars+6),a
	ld a,b
	or a
	and %00000001
	add a,$30
	ld (hexchars+7),a
	xor a										;does ld a,0
	ld (hexchars+8),a
	ret
atohex
	push af
	push hl
	push de
	push bc
	ld b,a
	and %00001111
	ld c,a
	ld a,b
	or a
	and %11110000
	rr a
	rr a
	rr a
	rr a
	ld e,a
	ld d,0
	ld hl,hexcharstable
	add hl,de
	ld a,(hl)
	ld (hexchars),a
	ld e,c
	ld d,0
	ld hl,hexcharstable
	add hl,de
	ld a,(hl)
	ld (hexchars+1),a
	xor a										;does ld a,0
	ld (hexchars+2),a
	pop bc
	pop de
	pop hl
	pop af
	ret




scrollup
	xor a										;does ld a,0
	ld ($c177),a
	ld hl,$c177
	ld de,$c18c
	ld bc,106
	lddr
	jr scrolling
scrolldown
	xor a										;does ld a,0
	ld ($c18c),a
	ld hl,$c123
	ld de,$c10e
	ld bc,106
	ldir
	jr scrolling
scrolling
	ld a,1
	ld (_curRow),a
	ld a,1
	ld (_curCol),a
	ld hl,$c10f
	call _puts
	ret

Selectlevs
	call _clrScrn
	call Bydraw
	xor a										;does ld a,0
	ld (pageloaded),a
	ld a,$3c
	out (0),a
	call FindVariables
	call drawmenustart
	call drawoutofnum
selectlevloop
	call _getkey
	cp kF2
	jp z,startselvar
	cp kEnter
	jp z,editvar
	cp kExit
	jp z,mEnd
	cp kUp
	jr z,Selectlevup
	cp kDown
	jr z,Selectlevdown
	jr selectlevloop
Selectlevup
	ld a,(mr)
	cp 1
	jr z,selectupmove
	dec a
	ld (mr),a
	ld a,(r)
	cp 1
	jr z,selectscrlup
	dec a
	ld (r),a
	jr Selectlevdraw
Selectlevdown
	ld a,(xlevelsnum)
	ld b,a
	ld a,(mr)
	cp b
	jr z,selectdownmove
	inc a
	ld (mr),a
	ld a,(r)
	cp 6
	jr z,selectscrldown
	inc a
	ld (r),a
	jr Selectlevdraw
selectdownmove
	ld a,(xlevelsnum)
	ld (mr),a
	ld a,6
	ld (r),a
	ld a,5
	ld (rowl),a
	jr Selectlevdraw
selectupmove
	ld a,1
	ld (mr),a
	ld (r),a
	ld a,2
	ld (rowl),a
	jr Selectlevdraw
selectscrldown
	ld a,5
	ld (rowl),a
	call scrolldown
	jr Selectlevdraw
selectscrlup
	ld a,2
	ld (rowl),a
	call scrollup
	jr Selectlevdraw
Selectlevdraw
	call Putvarinfo
	call drawoutofnum
	jp selectlevloop
drawoutofnum
	set 3,(iy+5)
	ld a,0
	ld (_curRow),a
	ld a,14
	ld (_curCol),a
	ld a,(mr)
	call atodec
	ld hl,hexchars
	call _puts
	res 3,(iy+5)
	ret
Putvarinfo
	ld a,(mr)
	ld hl,xlevelstable-9
	ld de,9
Selectlevhlcalc
	or a
	add hl,de
	dec a
	cp 0
	jr nz,Selectlevhlcalc
	ld de,File_name
	ld bc,9
	ldir
	ld hl,File_name-1
	rst 20h
	rst 10h
	ld a,(r)
	ld (_curRow),a
	xor a										;does ld a,0
	ld (_curCol),a
	ld a,5
	call _putmap
	ld a,1
	ld (_curCol),a
	ld hl,File_name+1								; displays world name
	call _puts
	ld a,10
	ld (_curCol),a
	ld hl,File_name-1
	rst 20h
	rst 10h
	and $1f
	ld (type),a
	ex de,hl
	call $477f
	ld h,d
	ld l,e
	ld (tsize),hl
	ld a,(File_name)
	ld b,6
	add a,b
	ld e,a
	ld d,0
	xor a										;does ld a,0
	or a
	add hl,de
	ld (size),hl
	call $4a33
	ld a,16
	ld (_curCol),a
	call typetableloopup
	ld a,7
	ld (_curRow),a
	ld a,16
	ld (_curCol),a
	set 3,(iy+5)
	ld hl,(moreinfo)
	call _puts
	res 3,(iy+5)
	xor a										;does ld a,0
	ld (_curCol),a
	ld a,(rowl)
	ld (_curRow),a
	ld a,$20
	call _putmap
	ld a,(r)
	ld (rowl),a
	ret
selectlevloopend								; loads selected world into savelev for saved games
	ret


typetableloopup
	ld a,(type)
	inc a
typetableloopupnext
	ld hl,typetxttable-4
	ld de,4
typeloopdisp
	or a
	add hl,de
	dec a
	cp 0
	jr nz,typeloopdisp
	push hl
	call $4010
	ld (moreinfo),hl
	pop hl
	inc hl
	inc hl
	call $4010
	ld a,(hl)
	inc hl
	ld (sizeoff),a
	call _puts
	ret
drawmenustart
	set 3,(iy+5)
	ld a,0
	ld (_curRow),a
	ld a,17
	ld (_curCol),a
	ld a,$2f
	call _putc
	ld a,(xlevelsnum)
	call atodec
	ld hl,hexchars
	call _puts
	res 3,(iy+5)
	
	ld a,6
	ld (menurow),a
	ld (rowl),a
Drawmenusloop
	ld (r),a
	ld (mr),a
	call Putvarinfo
	ld a,(menurow)
	dec a
	ld (menurow),a
	cp 0
	jr nz,Drawmenusloop
	ret
editvardrawscreen
	call _clrScrn
	call editvarinfodraw
	call Namedraw
	set 3,(iy+5)
	xor a										;does ld a,0
	ld (_curRow),a
	ld a,13
	ld (_curCol),a
	ld hl,File_name+1
	call _puts
	ret
editvarinfodraw
	ld a,7
	call Invbar
	set 3,(iy+5)
	ld a,7
	ld (_curRow),a
	xor a										;does ld a,0
	ld (_curCol),a
	ld hl,(size)
	call $4a33
	ld a,(hexbindec)
	cp 1
	ret z
	ld a,7
	ld (_curRow),a
	ld a,12
	ld (_curCol),a
	call typetableloopup
	ret
editvar
	ld hl,0
	ld (Addressoffset),hl
	ld a,(type)
	cp $12
	call z,editcheckifasm
	ld hl,File_name-1
	rst 20h
	rst 10h
	ld a,b
	ex de,hl
	call _SET_ABS_SRC_ADDR
	ld a,1
	ld hl,0
	call _SET_ABS_DEST_ADDR
	xor a										;does ld a,0
	ld hl,(size)
	call _SET_MM_NUM_BYTES
	call _mm_ldir
	call $47e3
Editbegin
	call _clrScrn
	call drawsecscreen
	call editvardrawscreen
	res 3,(iy+5)
	xor a										;does ld a,0
	ld (rowmax),a
	ld (noscroll),a
	ld a,5
	ld (colmax),a
	call draweditscreen
	xor a										;does ld a,0
	ld (c),a
	inc a
	ld (r),a
	ld hl,0
	ld (mr),hl
	jp editvardraw
editvarkeyloop
	call _getkey
	cp kExit
	jp z,End
	cp kF1
	jp z,Help
	cp kF2
	jp z,startselvar
	cp kF3
	jp z,hexbindecdecide
	cp kGrMenu
	jp z,graphicstoggle
	cp kTable
	jp z,grayscalecontrol
	ld b,a
	ld a,(full)
	cp 1
	jr z,jumpoveradjust	
	ld a,b
	cp kAdd
	jp z,graphwidthup
	cp kSub
	jp z,graphwidthdown
	cp kMul
	jp z,graphhightup
	cp kDiv
	jp z,graphhightdown
	cp kLog
	jp z,addressontoggle
	ld b,a
jumpoveradjust
	ld a,b
	cp kExpon
	jp z,graphicinccontrol
	cp kVarx
	jp z,fullgraphcontrol
	ld b,a
	ld a,(nodata)
	cp 1
	jr z,editvarkeyloop
	ld a,b
	cp kCustom
	jp z,editvarupbyk
	cp kTan
	jp z,editvardownbyk
	cp kUp
	jr z,editvarup
	cp kDown
	jp z,editvardown
	cp kLeft
	jr z,editvarleft
	cp kRight
	jr z,editvarright
	jr editvarkeyloop



editvarupbyk
	ld a,1
	ld (mscroll),a
	ld b,200
editvarupbykloop
	push bc
	call editvarup
	pop bc
	djnz editvarupbykloop
	xor a										;does ld a,0
	ld (mscroll),a
	jp redrawscreen
editvardownbyk
	ld a,1
	ld (mscroll),a
	ld b,200
editvardownbykloop
	push bc
	call editvardown
	pop bc
	djnz editvardownbykloop
	xor a										;does ld a,0
	ld (mscroll),a
	jp redrawscreen


editvarleft
	ld a,(c)
	cp 0
	jr z,editvarleftscroll
	dec a
	ld (c),a
	jp editvardraw
editvarleftscroll
	ld a,4
	ld (c),a
	jp editvarup
editvarright
	ld a,(c)
	cp 4
	jr z,editvarrightscroll
	inc a
	ld (c),a
	ld a,(r)
	ld b,a
	ld a,(rowmax)
	cp b
	jp nz,editvardraw
	ld a,(c)
	ld b,a
	ld a,(colmax)
	cp b
	jp c,editvarmovecol
	jp editvardraw
editvarrightscroll
	xor a										;does ld a,0
	ld (c),a
	jp editvardown
editvarup
	ld a,(r)
	cp 1
	jr z,editvarscrollup
	dec a
	ld (r),a
	ld hl,(mr)
	ld de,5
	or a
	sbc hl,de
	ld (mr),hl
	jp editvardraw
editvarscrollup
	ld hl,(mr)
	xor a										;does ld a,0
	cp h
	jr z,editvarscrolluph
	jr editvarscrolluprest
editvarscrolluph
	xor a										;does ld a,0
	cp l
	jp z,editvarupend
	jr editvarscrolluprest
editvarupend
	xor a										;does ld a,0
	ld (c),a
	jp editvardraw
editvarscrolluprest
	xor a										;does ld a,0
	ld (rowmax),a
	ld (noscroll),a
	ld a,5
	ld (colmax),a

	ld a,1
	ld (r),a
	ld hl,(mr)
	ld de,5
	or a
	sbc hl,de
	ld (mr),hl
	call drawrows
	ld a,1
	ld (r),a
	ld hl,(mr)
	ld de,30
	or a
	sbc hl,de
	ld (mr),hl
	jp editvardraw
editvardown
	ld a,(r)
	cp 6
	jr z,editvarscrolldown
	ld b,a
	ld a,(rowmax)
	cp b
	jp z,editvarmovecol
	ld a,(r)
	inc a
	ld (r),a
	ld hl,(mr)
	ld de,5
	or a
	add hl,de
	ld (mr),hl
	ld a,(r)
	ld b,a
	ld a,(rowmax)
	cp b
	jp z,editvarscrolldownend
	jr editvardraw
editvarscrolldownend
	ld a,(c)
	ld b,a
	ld a,(colmax)
	cp b
	jr c,editvarmovecol
	jr editvardraw
editvarmovecol
	ld a,(colmax)
	ld (c),a
	jr editvardraw
editvarscrolldown
	ld a,(noscroll)
	cp 1
	jp z,editvarmovecol
	ld a,1
	ld (r),a
	ld hl,(mr)
	ld de,20
	or a
	sbc hl,de
	ld (mr),hl
	call drawrows
	res 3,(iy+5)
	ld a,6
	ld (r),a
	ld hl,(mr)
	ld de,5
	or a
	sbc hl,de
	ld (mr),hl
	ld a,(c)
	ld b,a
	ld a,(colmax)
	cp b
	jr c,editvarmovecol
	jr editvardraw
editvardraw
	ld a,(mscroll)
	cp 1
	ret z
	ld a,(nodata)
	cp 1
	jp z,editvarkeyloop
	ld a,(full)
	cp 1
	jp z,drawgraphicsstart
	ld a,(rlast)
	ld (_curRow),a
	ld a,(clast)
	add a,16
	ld (_curCol),a
	call findundercur
	call _putmap
	ld a,(clast)
	ld b,a
	add a,a
	add a,b
	ld (_curCol),a
	ld a,(rlast)
	ld (_curRow),a
	ld b,2
drawclrlcurleft
	push bc
	call findundercur
	call _putc
	pop bc
	djnz drawclrlcurleft
	set 3,(iy+5)
	ld a,(r)
	ld (_curRow),a
	ld a,(c)
	add a,16
	ld (_curCol),a
	call findundercur
	call _putmap
	call displaynum
	ld a,(graphicson)
	cp 1
	jp z,drawgraphicsstart
	ld a,(c)
	ld b,a
	add a,a
	add a,b
	ld (_curCol),a
	ld a,(r)
	ld (_curRow),a
	ld b,2
drawcrcurleft
	push bc
	call findundercur
	call _putc
	pop bc
	djnz drawcrcurleft
drawgraphicsend
	set 3,(iy+5)
	ld a,(full)
	cp 1
	jp z,editvarkeyloop
	ld a,7
	ld (_curRow),a
	dec a
	ld (_curCol),a
	ld hl,(mr)
	ld a,(c)
	ld e,a
	ld d,0
	or a
	add hl,de
	inc hl
	ld a,(addressshow)
	cp 0
	jr nz,drawaddressnum
	xor a										;does ld a,0
	call $4a33
drawaddressnumend
	res 3,(iy+5)
	ld a,(r)
	ld (rlast),a
	ld a,(c)
	ld (clast),a
	jp editvarkeyloop
drawaddressnum
	ld a,7
	ld (_curCol),a
	dec hl
	ex de,hl
	ld hl,(Addressoffset)
	add hl,de
	push hl
	ld a,h
	call atohex
	ld hl,hexchars
	call _puts
	pop hl
	ld a,l
	call atohex
	ld hl,hexchars
	call _puts
	jr drawaddressnumend
drawgraphicsstart
	ld de,$8002
	ld hl,(mr)
	or a
	add hl,de
	ld a,(sizeoff)
	ld e,a
	ld d,0
	or a
	sbc hl,de
	ld a,(c)
	ld e,a
	ld d,0
	add hl,de
	dec hl
	ex de,hl
	ld hl,$fc7f
	ld (drawscreenloc),hl
	ex de,hl
begindraw
	ld a,(full)
	cp 0
	jr z,begindrawa
	push hl
	ld hl,(drawscreenloc)
	ld de,128
	sbc hl,de
	ld (drawscreenloc),hl
	pop hl
begindrawa
	ld a,(graphichight)
	ld b,a
	xor a										;does ld a,0
	ld (graphrow),a
	ex de,hl
	ld hl,(drawscreenloc)
	ex de,hl
graphicrow
	push bc
	ld a,(graphicwidth)
	ld b,a
graphiccol
	inc hl
	inc de
	ld a,(hl)
	ex de,hl
	ld (hl),a
	ex de,hl
	djnz graphiccol

	push hl
	ld a,(graphrow)
	inc a
	ld (graphrow),a
	ld e,a
	ld d,0
	ld hl,0
	ld b,16
graphicrowaddloop
	add hl,de
	djnz graphicrowaddloop
	ex de,hl
	ld hl,(drawscreenloc)
	add hl,de
	ex de,hl

	pop hl
	pop bc
	djnz graphicrow
	ld a,(graystat)
	cp 0
	jp z,endgraydraw
	ld a,(drewgray)
	cp 0
	jr nz,endgraydraw
;fixthis!



	ex de,hl
	ld hl,$e97f
	ld (drawscreenloc),hl
	ex de,hl
	ld a,1
	ld (drewgray),a
	jp begindraw
endgraydraw
	xor a										;does ld a,0
	ld (drewgray),a
	jp drawgraphicsend
findundercur
	ld a,(_curRow)
	ld b,a
	ld de,21
	ld hl,0
findunderloop
	add hl,de
	djnz findunderloop
	ld a,(_curCol)
	ld e,a
	ld d,0
	add hl,de
	ld de,$c0f9
	add hl,de
	ld a,(hl)
	cp 214
	ret nz
	ld a,$20
	ret
displaynum
	ld hl,$8002
	ex de,hl
	ld hl,(mr)
	or a
	add hl,de
	ld a,(sizeoff)
	ld e,a
	ld d,0
	or a
	sbc hl,de
	ld a,(c)
	ld e,a
	ld d,0
	add hl,de
	ld a,(hl)	
	ld b,a
	ld a,7
	ld (_curRow),a
	ld a,(hexbindec)
	cp 0
	jr z,displayhex
	cp 1
	jr z,displaybin
	jr displaydec
displaydec
	ld a,b	
	call atodec
	ld a,18
	ld (_curCol),a
	ld hl,hexchars
	call _puts
	ret
displayhex
	ld a,b
	call atohex
	ld a,18
	ld (_curCol),a
	ld hl,hexchars
	call _puts
	ld a,4
	call _putmap
	ret
displaybin
	ld a,b
	call atobin
	ld a,12
	ld (_curCol),a
	ld hl,hexchars
	call _puts
	ld a,1
	call _putmap
	ret
addressontoggle
	ld a,(addressshow)
	cp 1
	jr z,addresstoff
	ld a,1
	ld (addressshow),a
	jp redrawscreen
addresstoff
	xor a										;does ld a,0
	ld (addressshow),a
	jp redrawscreen
fullgraphcontrol
	ld a,(full)
	cp 0
	jr z,fullon
	jr fulloff
fullon
	ld a,1
	ld (full),a
	ld a,(graphicwidth)
	ld (widthalt),a
	ld a,(graphichight)
	ld (hightalt),a
	ld a,16
	ld (graphicwidth),a
	ld a,64
	ld (graphichight),a
	jp redrawscreen
fulloff
	xor a										;does ld a,0
	ld (full),a
	ld a,(widthalt)
	ld (graphicwidth),a
	ld a,(hightalt)
	ld (graphichight),a
	jp redrawscreen
grayscalecontrol
	ld a,(graystat)
	cp 0
	jr z,grayon
	jr grayoff
grayon
	ld a,1
	ld (graystat),a
	set 2,(iy+$23)
	jp redrawscreen
grayoff
	xor a										;does ld a,0
	ld (graystat),a
	res 2,(iy+$23)
	ld a,$3c
	out (0),a
	jp redrawscreen
graphicstoggle
	ld a,(graphicson)
	cp 1
	jr z,graphicsturnoff
	jr graphicsturnon
graphwidthup
	ld a,(graphicwidth)
	cp 16
	jp z,redrawscreen
	inc a
	ld (graphicwidth),a
	jp redrawscreen
graphwidthdown
	ld a,(graphicwidth)
	cp 1
	jp z,redrawscreen
	dec a
	ld (graphicwidth),a
	jp redrawscreen
graphhightup
	ld a,(inchightnum)
	ld b,a
graphhightupa
	ld a,(graphichight)
	cp 48
	jp z,redrawscreen
	inc a
	ld (graphichight),a
	djnz graphhightupa
	jp redrawscreen
graphhightdown
	ld a,(inchightnum)
	ld b,a
graphhightdowna
	ld a,(graphichight)
	cp 8
	jp z,redrawscreen
	dec a
	ld (graphichight),a
	djnz graphhightdowna
	jp redrawscreen
graphicsturnoff
	xor a										;does ld a,0	
	ld (graphicson),a
	jr redrawscreen
graphicsturnon
	ld a,1
	ld (graphicson),a
	jr redrawscreen
graphicinccontrol
	ld a,(inchightnum)
	cp 1
	jr z,graphincby8
	jr graphincby1
graphincby1
	ld a,1
	ld (inchightnum),a
	jr redrawscreen
graphincby8
	ld a,8
	ld (inchightnum),a
	jr redrawscreen
hexbindecdecide
	call drawsecscreen
	call _clrScrn
	call Bydraw
	ld a,1
	ld b,2
	ld hl,displaydecidetable
	call putflines
	call _getkey
	cp k1
	jr z,hexdecide
	cp k2
	jr z,bindecide
	cp k3
	jr z,decdecide
	cp kF2
	jr z,redrawscreen
	jr hexbindecdecide
hexdecide
	xor a										;does ld a,0
	ld (hexbindec),a
	jr redrawscreen
bindecide
	ld a,1
	ld (hexbindec),a
	jr redrawscreen
decdecide
	ld a,2
	ld (hexbindec),a
	jr redrawscreen
redrawscreen
	call drawsecscreen
	call editvardrawscreen
	res 3,(iy+5)
	ld a,(r)
	ld (rsave),a
	ld a,(c)
	ld (csave),a
	ld a,(rlast)
	ld (rlastsave),a
	ld a,(clast)
	ld (clastsave),a
	ld hl,(mr)
	ld (mrsave),hl
	ld a,(r)
	dec a
	ld b,a
	add a,a
	add a,a
	add a,b
	ld e,a
	ld d,0
	sbc hl,de
	ld (mr),hl
	ld a,1
	ld (r),a
	xor a										;does ld a,0
	ld (c),a
	call drawrows
	ld hl,(mrsave)
	ld (mr),hl
	ld a,(rsave)
	ld (r),a
	ld a,(csave)
	ld (c),a
	ld a,(rlastsave)
	ld (rlast),a
	ld a,(clastsave)
	ld (clast),a
	jp editvardraw




cphlsize
	push hl
	ld de,$8000
	or a
	sbc hl,de
	inc hl
	inc hl
	ex de,hl
	ld hl,(tsize)
	inc hl
	call $403c					;compares hl,de; works like compare a,b
	jr c,cphlnoscroll
	xor a										;does ld a,0
	ld (noscroll),a
	pop hl
	ret
cphlnoscroll
	pop hl
	ld a,1
	ld (noscroll),a
	ret

draweditscreen
	xor a										;does ld a,0
	ld (noscroll),a
	ld (nodata),a
	ld (c),a
	ld (clast),a
	ld a,1
	ld (rlast),a
	ld (r),a
	ld hl,0
	ld (mr),hl	
drawrows
	ld b,6
drawrowsloop
	push bc
	call draweditrow
	pop bc
	ld de,5
	ld hl,(mr)
	or a
	add hl,de
	ld (mr),hl
	ld a,(r)
	inc a
	ld (r),a
	ld a,(nodata)
	cp 1
	ret z
	ld a,(noscroll)
	cp 1
	ret z
	djnz drawrowsloop
	ret

firsttimethrough
	ld a,(r)
	cp 1
	ret nz
	call cphlsize
	ld a,(noscroll)
	cp 1
	jp z,nodatainvar
	ret
draweditrow
	ld hl,$8002
	ex de,hl
	ld hl,(mr)
	or a
	add hl,de
	ld a,(sizeoff)
	ld e,a
	ld d,0
	or a
	sbc hl,de
	ld a,1
	cp b
	call firsttimethrough
	ld a,16
	ld (_curCol),a
	ld a,(r)
	ld (_curRow),a
	ld b,5
drawcolloop
	ld a,(full)
	cp 1
	jp z,drawnorighttext

	ld a,(mscroll)
	cp 1
	jr z,drawnorighttexta

	ld a,(hl)
	call atohex
	cp 214
	jr nz,drawcolloopnenter
	ld a,$20
drawcolloopnenter
	call _putc
drawnorighttext
	inc hl
	call cphlsize
	ld a,(mscroll)
	cp 1
	jr z,endskipredraw
	ld a,(_curCol)
	ld c,a
	ld a,(_curRow)
	push af
	push bc
	push hl
	ld a,(graphicson)
	cp 0
	jr nz,drawcolloopnotext
	ld a,(_curCol)
	cp 0
	call z,enddrawcolloop4a
	sub 17
	ld b,a
	add a,a
	add a,b
	ld (_curCol),a
	ld hl,hexchars
	call _puts
drawcolloopnotext
	pop hl
	pop bc
	pop af
	ld (_curRow),a
	ld a,c
	ld (_curCol),a
endskipredraw
	ld a,(noscroll)
	cp 1
	jr z,enddrawcolloop
	djnz drawcolloop
	ret
drawnorighttexta
	ld a,(_curCol)
	inc a
	cp 22
	jr nz,drawnorighttextab
	ld a,(_curRow)
	inc a
	ld (_curRow),a
	xor a										;does ld a,0
drawnorighttextab
	ld (_curCol),a
	jp drawnorighttext

enddrawcolloop
	ld a,(_curCol)
	cp 0
	call z,enddrawcolloop4a
	sub 17
	ld (colmax),a
	ld a,(_curRow)
	ld (rowmax),a
enddrawcolloop2
	ld a,(_curCol)
	cp 0
	ret z
	ld a,$20
	call _putc
	ld a,6
	ld (_curRow),a
	ld a,(_curCol)
	ld c,a
	push bc
	cp 0
	call z,enddrawcolloop4
	sub 17
	ld b,a
	add a,a
	add a,b
	ld (_curCol),a
	ld a,$20
	call _putc
	ld a,$20
	call _putc
	pop bc
	ld a,c
	ld (_curCol),a
	jr enddrawcolloop2
enddrawcolloop4a
	ld a,(_curRow)
	dec a
	ld (_curRow),a
	ld a,21
	ret
enddrawcolloop4
	ld a,21
	ret
nodatainvar
	pop hl
	ld a,1
	ld (nodata),a
	ret

; originally from Putz!, modified for this program
FindVariables
	ld hl,xlevelstable
	ld a,$20
	ld (hl),a
	ld de,xlevelstable+1
	ld bc,2295
	ldir
	ld a,%01000111								; load RAM page 7
	out (6),a									;
	ld hl,$bfff
	ld (symlocate),hl
	xor a										;does ld a,0
	ld (xlevelsnum),a
Symsearch
	ld hl,(symlocate)
	ld de,($d29b)
	or a
	sbc hl,de
	jp c,Findlevsdone	
	jr Varfound
Symsearchnot
	ld hl,(symlocate)
	ld de,5
	sbc hl,de
	ld d,0
	ld a,(hl)
	inc a
	ld e,a
	sbc hl,de
	ld (symlocate),hl
	jr Symsearch
Varfound
	ld hl,(symlocate)
	ld de,4
	or a
	sbc hl,de
	ld a,(hl)
	cp 0
	jr nz,Symsearchnot
VarCheck
	call $47f3
	ld a,(xlevelsnum)
	cp 255
	jr z,Findlevsdone
	inc a
	ld (xlevelsnum),a
	ld hl,File_name
	ld (putzloc),hl
	ld hl,xlevelstable-9
	ld de,9
VarCheck1									;world found, next few lines write name to table
	add hl,de
	dec a
	cp 0
	jr nz,VarCheck1
	ld (xtableloc),hl
	ld hl,(symlocate)
	ld de,5
	or a
	sbc hl,de
	ld (symlocate),hl
	ld a,(hl)
	ld hl,(putzloc)
	ld (hl),a
	ld hl,(xtableloc)
	ld (hl),a
	ld b,a
VarCheckloop
	ld hl,(symlocate)
	dec hl
	ld (symlocate),hl
	ld a,(hl)
	ld hl,(putzloc)
	inc hl
	ld (hl),a
	ld (putzloc),hl
	ld hl,(xtableloc)
	inc hl
	ld (hl),a
	ld (xtableloc),hl
	djnz VarCheckloop
VarCheckloopend
	ld hl,(symlocate)
	dec hl
	ld (symlocate),hl
	ld hl,File_name-1
	rst 20h
	rst 10h
	jp c,Findlevsdonea
	jp Symsearch
Findlevsdonea
	ld hl,(xlevelsnum)
	dec (hl)
Findlevsdone
	ret



; originally from Putz!
putflines
	ld (_curCol),a
	ld (pcol),a
	ld a,b
	ld (_curRow),a
	ld (prow),a
putflinesloop
	call _puts
	ld a,(pcol)
	ld b,a
	ld a,(_curCol)
	cp b
	ret z
	ld (_curCol),a
	ld a,(prow)
	inc a
	ld (prow),a
	ld (_curRow),a
	ld a,(pcol)
	ld (_curCol),a
	jr putflinesloop
redrawscreena
	pop hl
	jp redrawscreen
drawsecscreen
	ld hl,$e900
	ld de,$e901
	ld (hl),$ff
	ld bc,127
	ldir
	ld hl,$e980
	ld de,$e981
	ld bc,770
	ld (hl),0
	ldir
	ld hl,$ec80
	ld de,$ec81
	ld bc,127
	ld (hl),$ff
	ldir
	ret
Levelchange
	ld a,(lev)
	ld (pr),a
	call $47e3
	jr Levelnumdraw
Levelchangeloop
	call _getkey
	cp kF2
	jp z,Selectwhat2load2
	cp kExit
	jp z,mEnd
	cp kEnter
	jr z,Levelchangeend
	cp kUp
	jr z,Levelgoesup
	cp kDown
	jr z,Levelgoesdown
	jr Levelchangeloop	
Levelgoesup
	ld a,(pr)
	cp 0
	jr z,Levelloopup
	ld a,(pr)
	dec a
	ld (pr),a
	jr Levelnumdraw
Levelgoesdown
	ld a,(pr)
	ld b,a
	ld a,(maxlevs)
	cp b
	jr z,Levelloopdown
	ld a,(pr)
	inc a
	ld (pr),a
	jr Levelnumdraw
Levelloopup
	ld a,(maxlevs)
	ld (pr),a
	jr Levelnumdraw
Levelloopdown
	xor a										;does ld a,0
	ld (pr),a
	jr Levelnumdraw
Levelnumdraw
	ld hl,0
	ld a,(pr)
	call atohex
	ld hl,hexchars+1
	call _puts
	ld a,(_curCol)
	sub 1
	ld (_curCol),a
	jr Levelchangeloop
Levelchangeend
	ld a,(pr)
	ld (lev),a
	ret
editcheckifasm
	ld hl,File_name-1
	rst 20h
	rst 10h
	ex de,hl
	inc hl
	inc hl
	ld a,b
	call $521d
	ld hl,$288e
	call $403c
	ret nz
	ld hl,$d746
	ld (Addressoffset),hl
	ret
drawgraphicsenda
	pop hl
	jp drawgraphicsend



installint
;thanks to Matt Johnson for this bit of code
_user_int_ram EQU $d2fd                      ;Area where interrupt handler goes
;====================================================================================================
; Install IM 1 Interrupt Handler
;====================================================================================================
 res 2,(iy+$23)                       ;turn user int off so it won't get called by
                                      ;accident before we're ready   
 ld hl,int_copy                       ;copy prog to user int buffer
 ld de,_user_int_ram+1                ;1 byte ahead of checksum
 ld bc,int_end-int_start              ;length of interrupt handler
 ldir                                 ;hl is the source, de is the destination,
                                      ;and bc is the length   
 ld a,(_user_int_ram+1)               ;set up checksum byte
 ld hl,_user_int_ram+($28*1)          ;load byte
 add a,(hl)                           ;add to total
 ld hl,_user_int_ram+($28*2)          ;load byte
 add a,(hl)                           ;add to total
 ld hl,_user_int_ram+($28*3)          ;load byte
 add a,(hl)                           ;add to total
 ld hl,_user_int_ram+($28*4)          ;load byte
 add a,(hl)                           ;add to total
 ld hl,_user_int_ram+($28*5)          ;load byte
 add a,(hl)                           ;add to total
 ld (_user_int_ram),a                 ;load checksum in its location
 ret                                 ; Return to shell or TI-OS



full
.db 0
widthalt
.db 0
hightalt
.db 0
inchightnum
.db 8
drewgray
.db 0
drawscreenloc
.db 0,0
time
 .db 0
graystat
.db 0
name
.db "Hex Viewer .90 by John Kempen",0
versionnum
.db ".90",0
graphicwidth
.db 1
graphichight
.db 16
graphicson
.db 0
addressshow
.db 0
displaydecidetable
.db "1 Hexadecimal",0
.db "2 Binary",0
.db "3 Decimal",0,0
hexbindec
.db 0
hexcharstable
.db "0123456789",$0a,$0b,$0c,$0d,$0e,$0f
bytext
.db "By John Kempen",0
nametext
.db "Hex Viewer",0
File_name
.db 8,"12345678",0
moreinfo
.db 0,0
Selectwhattxt
.db "1 Load Variable",0
.db "2 "
lrampage
.db "Load Ram "
pagetxt
.db "Page",0
.db "3 "
lrompage
.db "Load Rom Page",0
.db "4 About",0
.db "5 Help",0
.db "6 Exit",0,0
Abouttxt
.db "Hex Viewer",0
.db "version .90",0
.db " ",0
.db "Report bugs to:",0
.db "saywhat97@hotmail.com",0,0
Page
.db "Load page ",0
typetxttable
;0
.dw textno
.dw varreal
;1
.dw textno
.dw varcplx
;2
.dw textreal
.dw varvectr
;3
.dw textcplx
.dw varvectr
;4
.dw textreal
.dw varlist
;5
.dw textcplx
.dw varlist
;6
.dw textreal
.dw varmatrx
;7
.dw textcplx
.dw varmatrx
;8
.dw textreal
.dw varcons
;9
.dw textcplx
.dw varcons
;a
.dw textno
.dw varequ
;b
.dw textos
.dw varunknown
;c
.dw textno
.dw varstrng
;d
.dw textfunc
.dw vargdb
;e
.dw textpol
.dw vargdb
;f
.dw textparam
.dw vargdb
;10
.dw textdifeq
.dw vargdb
;11
.dw textno
.dw varpic
;12
.dw textno
.dw varprgm
;13
.dw textos
.dw varunknown
;14
.dw textos
.dw varunknown
;15
.dw textos
.dw varunknown
;16
.dw textos
.dw varunknown
;17
.dw textos
.dw varunknown
;18
.dw textos
.dw varunknown
;19
.dw textos
.dw varunknown
;1a
.dw textos
.dw varunknown
;1b
.dw textos
.dw varunknown
;1c
.dw textos
.dw varunknown
;1d
.dw textos
.dw varunknown
;1e
.dw textos
.dw varunknown
;1f
.dw textos
.dw varunknown
;20
.dw textno
.dw varram
;21
.dw textno
.dw varrom


varreal
.db 2
textreal
.db "Real ",0
varcplx
.db 2
textcplx
.db "Cplx ",0
varvectr
.db 0,"Vectr",0
varlist
.db 0,"List ",0
varmatrx
.db 0,"Matrx",0
varcons
.db 2,"Cons ",0
varequ
.db 0,"Equ  ",0
varstrng
.db 0,"Strng",0
vargdb
.db 2,"Gdb  ",0
varpic
.db 2,"Pic  ",0
varprgm
.db 0,"Prgm ",0
varunknown
.db 0
textno
.db "     ",0
textfunc
.db "Func ",0
textpol
.db "Pol  ",0
textparam
.db "Param",0
textdifeq
.db "DifEq",0
textos
.db "Os?  ",0
varram
.db 2,"Ram  ",0
varrom
.db 2,"Rom  ",0
nohelpviewer
.db "Need file: HelpView",0
variable
.db 8,"HelpView"

textfiledata
maxrow
.db 6
minrow
.db 1
maxcol
.db 20
mincol
.db 0
textvariable
.db 7,"HexHelp"

.db "2/13/99-"
.db "7/25/99"




;thanks to Matt Johnson for this bit of code
;====================================================================================================
; IM 1 Interrupt Handler code
;====================================================================================================
int_copy:
        .org $D2FE                       ; Intruction Counter starts at $D2FE
int_start:; ------[ interrupt code goes here ]------------EndInterrupt:
	in a,(3)                              ; Is the LCD in the middle of refreshing?
	bit 1,a
	ret z                              ; If so, immediately exit interrupt routine

	ld a,(time)
	inc a
	ld (time),a
	cp 3
	jr z,lower
	cp 1
	jr z,upper
	ret

upper
	ld a,$3c
	out (0),a
	ret
lower
	xor a										;does ld a,0
	ld (time),a
	ld a,$29
	out (0),a
	ret
int_end
.end
