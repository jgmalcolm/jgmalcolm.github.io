;-=-=-=-=-=-=-=-=-=-=-=-=
;|82->86 Include File
;|Made by Sam Heald
;-=-=-=-=-=-=-=-=-=-=-=-=


#define equ .equ
#define EQU .equ
#define end .end

;----= Shell Description =----
 .org $D748
 nop         
 jp ProgStart
 .dw $0000
 .dw ProgDesc

;-----------------------------

;----= 82->83 Memory Addresses =----
TEXT_MEM  = $C0F9
TEXT_MEM2 = $CFAB
GRAPH_MEM = $fc00  ; For displaying purposes these two are swithed
APD_BUF   = $FC00  ;

	
CURSOR_ROW  = $C00F
CURSOR_COL  = $C010
CURSOR_X    = $C37C
CURSOR_Y    = $C37D

;----= 82->86 ROM_Call's =----
#DEFINE ROM_CALL(ADDR)    call ADDR

MUL_HL = $4547

CP_HL_DE = $403C
LD_HL_MHL = $4010
GET_KEY = $5371
UNPACK_HL = $4044

D_HL_DECI:
 xor a
 jp $4a33

BUSY_OFF = $4ab1			;_runindoff
BUSY_ON = $4aad				;_runindicon
D_ZT_STR = $4a37			;_puts
D_LT_STR = $4a3b			;_putps
TX_CHARPUT = $4a2b			;_putc
D_ZM_STR = $4aa5			;_vputs
D_LM_STR = $4aa9			;_vputsn
M_CHARPUT = $4aa1			;_vputmap
CLEARLCD = $4a7e			;_clrLCD
_ILine     = $4E51
_ipoint    = $4E59


DISP_GRAPH:
 ld hl,$c9fa
 ld de,$fc02
 ld a,64
copy_loop
 ld bc,12
 ldir
 inc de
 inc de 
 inc de
 inc de
 dec a
 jr nz,copy_loop
 ret


;-------------------------------------------------------------------------------
;FIND_PIXEL Routine
;-------------------------------------------------------------------------------
FIND_PIXEL:
 push bc
 push de
 ld hl,ExpTable
 ld d,0
 ld a,b
 and $07
 ld e,a
 add hl,de
 ld e,(hl)
         ld       a,63
         sub      c
         ld       c,a
 ld h,d
 srl b
 srl b
 srl b
 ld a,c
 add a,a
 add a,a
 ld l,a
 add hl,hl
 add hl,hl
 ld a,e
 ld e,b
 add hl,de
 pop de
 pop bc
 ret

ExpTable:
 .db $80,$40,$20,$10,$08,$04,$02,$01



;GET_KEY equates

G_NONE    = $00 ; NO KEY
G_TAN     = $16 ; TAN
G_XTO     = $28 ; x,T,theta|
G_DOWN    = $01 ; DOWN
G_VARS    = $17 ; VARS
G_ON      = $29 ; ON
G_LEFT    = $02 ; LEFT
G_PERIODE = $19 ; .
G_STO     = $2A ; STO>
G_RIGTH   = $03 ; RIGHT
G_RIGHT   = $03 ; RIGHT
G_2       = $1A ; 2
G_LN      = $2B ; LN
G_UP      = $04 ; UP
G_5       = $1B ; 5
G_LOG     = $2C ; LOG
G_ENTER   = $09 ; ENTER
G_8       = $1C ; 8
G_SQR     = $2D ; X^2
G_PLUS    = $0A ; +
G_LPARAN  = $1D ; (
G_INVERSE = $2E ; X^-1
G_MINUS   = $0B ; -
G_COS     = $1E ; COS
G_MATH    = $2F ; MATH
G_TIMES   = $0C ; *
G_PRGM    = $1F ; PRGM
G_ALPHA   = $30 ; ALPHA
G_DIV     = $0D ; /
G_STAT    = $20 ; STAT
G_GRAPH   = $31 ; GRAPH
G_POWER   = $0E ; ^
G_0       = $21 ; 0
G_TRACE   = $32 ; TRACE
G_CLEAR   = $0F ; CLEAR
G_1       = $22 ; 1
G_ZOOM    = $33 ; ZOOM
G_NEG     = $11 ; (-)
G_4       = $23 ; 4
G_WINDOW  = $34 ; WINDOW
G_3       = $12 ; 3
G_7       = $24 ; 7
G_YEDIT   = $35 ; Y=
G_6       = $13 ; 6
G_COMMA   = $25 ; ,
G_2nd     = $36 ; 2nd
G_9       = $14 ; 9
G_SIN     = $26 ; SIN
G_MODE    = $37 ; MODE
G_RPARAN  = $15 ; )
G_MATRIX  = $27 ; MATRIX
G_DEL     = $38 ; DEL

;                 Key       Function

K_RIGTH   =   1 ; RIGHT     RIGHT
K_RIGHT   =   1 ; RIGHT     RIGHT
K_LEFT    =   2 ; LEFT      LEFT
K_UP      =   3 ; UP        UP
K_DOWN    =   4 ; DOWN      DOWN
K_ENTER   =   5 ; ENTER     ENTER
K_CLEAR   =   6 ; CLEAR     CLEAR
K_DEL     =   7 ; DEL       DEL
K_INS     =   8 ; DEL       INS
K_RCL     =   9 ; STO>      RCL
K_ENTRY   =  10 ; ENTER     ENTRY
K_BOL     =  11 ; LEFT      BOL
K_EOL     =  12 ; RIGTH     EOL
K_PRGM    =  45 ; PRGM      PRGM
K_ZOOM    =  46 ; ZOOM      ZOOM
K_DRAW    =  47 ; PRGM      DRAW
K_PLOT    =  48 ; Y=        STAT PLOT
K_MATH    =  49 ; MATH      MATH
K_TEST    =  50 ; MATH      TEST
K_VARS    =  52 ; VARS      VARS
K_MEM     =  53 ; +         MEM
K_MATRIX  =  54 ; MATRIX    MATRIX
K_STAT    =  55 ; STAT      STAT
K_Y-VARS  =  56 ; VARS      Y-VARS
K_ANGLE   =  57 ; MATRIX    ANGLE
K_LIST    =  58 ; STAT      LIST
K_CALC    =  59 ; TRACE     CALC
K_QUIT    =  64 ; MODE      QUIT
K_LINK    =  65 ; x,T,theta LINK
K_GRAPH   =  69 ; GRAPH     GRAPH
K_MODE    =  70 ; MODE      MODE
K_WINDOW  =  73 ; WINDOW    WINDOW
K_YEDIT   =  74 ; Y=        Y=
K_TABLE   =  75 ; GRAPH     TABLE
K_TBLSET  =  76 ; WINDOW    TblSet
K_TRACE   =  93 ; TRACE     TRACE
K_PLUS    = 129 ; +         +
K_MINUS   = 130 ; -         -
K_TIMES   = 131 ; *         *
K_DIV     = 132 ; /         /
K_POWER   = 133 ; ^         ^
K_LPARAN  = 134 ; (         (
K_RPARAN  = 135 ; )         )
K_LBRACK  = 136 ; *         [
K_RBRACK  = 137 ; -         ]
K_STO     = 139 ; STO>      STO>
K_COMMA   = 140 ; ,         ,
K_NEG     = 141 ; (-)       (-)
K_PERIODE = 142 ; .         .
K_0       = 143 ; 0         0
K_1       = 144 ; 1         1
K_2       = 145 ; 2         2
K_3       = 146 ; 3         3
K_4       = 147 ; 4         4
K_5       = 148 ; 5         5
K_6       = 149 ; 6         6
K_7       = 150 ; 7         7
K_8       = 151 ; 8         8
K_9       = 152 ; 9         9
K_EE      = 153 ; ,         EE
K_SEMI    = 154 ; 0         ;
K_A       = 155 ; MATH      A
K_B       = 156 ; MATRIX    B
K_C       = 157 ; PRGM      C
K_D       = 158 ; X^-1      D
K_E       = 159 ; SIN       E
K_F       = 160 ; COS       F
K_G       = 161 ; TAN       G
K_H       = 162 ; ^         H
K_I       = 163 ; X^2       I
K_J       = 164 ; ,         J
K_K       = 165 ; (         K
K_L       = 166 ; )         L
K_M       = 167 ; /         M
K_N       = 168 ; LOG       N
K_O       = 169 ; 7         O
K_P       = 170 ; 8         P
K_Q       = 171 ; 9         Q
K_R       = 172 ; *         R
K_S       = 173 ; LN        S
K_T       = 174 ; 4         T
K_U       = 175 ; 5         U
K_V       = 176 ; 6         V
K_W       = 177 ; -         W
K_X       = 178 ; STO>      X
K_Y       = 179 ; 1         Y
K_Z       = 180 ; 2         Z
K_XTO     = 181 ; x,T,theta x,T,theta
K_PI      = 182 ; ^         Pi
K_INVERSE = 183 ; X^-1      X^-1
K_SIN     = 184 ; SIN       SIN
K_ASIN    = 185 ; SIN       SIN^-1
K_COS     = 186 ; COS       COS
K_ACOS    = 187 ; COS       COS^-1
K_TAN     = 188 ; TAN       TAN
K_ATAN    = 189 ; TAN       TAN^-1
K_SQR     = 190 ; X^2       X^2
K_SQRT    = 191 ; X^2       SQRT
K_LN      = 192 ; LN        LN
K_EX      = 193 ; LN        e^X
K_LOG     = 194 ; LOG       LOG
K_TENP    = 195 ; LOG       10^X
K_ANS     = 198 ; (-)       ANS
K_COLON   = 199 ; .         :
K_QUEST   = 203 ; (-)       ?
K_QUOTE   = 204 ; +         "
K_THETA   = 205 ; 3         THETA
K_LBRACE  = 237 ; (         {
K_RBRACE  = 238 ; )         }
K_ABS     = 244 ; X^-1      ABS
K_L1      = 245 ; 1         L1
K_L2      = 246 ; 2         L2
K_L3      = 247 ; 3         L3
K_L4      = 248 ; 4         L4
K_L5      = 249 ; 5         L5
K_L6      = 250 ; 6         L6
K_Vn1     = 252 ; 8         Vn-1
K_Un1     = 253 ; 7         Un-1

_grbufclr:
 ld hl,$fc00
 ld de,$fc01
 ld bc,1023
 ldir
 ret

.end
END