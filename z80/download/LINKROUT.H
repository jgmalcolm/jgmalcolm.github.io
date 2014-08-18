;
; SOME VERY NICE LINK ROUTINES MADE BY PASCAL BOURON
;
; I've made some modifications so it fits ZTetris
;

ReceiveByte:
 ld hl,0
 ld (lcounter),hl

 ld 	 e,1			 ; for the OR
 ld 	 c,0			 ; byte receive
 ld 	 b,8			 ; counter
 ld 	 a,$C0
 out	 (7),a
rb_w_Start:
 in 	 a,(7)
 and 3
 cp  3
 jr 	 nz,rb_get_bit
 call Test_ON
 jr 	 rb_w_Start
rb_get_bit:
 cp 	 2
 jr 	 z,rb_receive_zero
 ld 	 a,c
 or 	 e
 ld 	 c,a
 ld 	 a,$D4
 out	 (7),a
 jr 	 rb_waitStop
rb_receive_zero:
 ld 	 a,$E8
 out	 (7),a
rb_waitStop:
 call Test_ON
 in 	 a,(7)
 and	 3
 jr 	 z,rb_waitStop
 ld 	 a,$c0
 out	 (7),a
 rl 	 e
 djnz 	 rb_w_Start
 ld 	 a,c
 ret

SendByte:
 ld hl,0
 ld (lcounter),hl
 ld 	 b,8
 ld (sbyte),a
 ld 	 c,a			 ;byte to send
 ld 	 a,$C0
 out	 (7),a
w_setport3:
 in 	 a,(7)
 and 3
 cp  3
 jr 	 z,calc_bit
 call SendTest_ON
 jr 	 w_setport3
calc_bit:
 ld 	 a,c
 and	 1
 jr 	 z,send_one
send_zero:
 ld 	 a,$E8
 out	 (7),A
 jr 	 wait_setport
send_one:
 ld 	 a,$D4
 out	 (7),A
wait_setport:
 call SendTest_ON
 in 	 a,(7)
 and	 3
 jr 	 nz,wait_setport
 ld 	 a,$C0
 out	 (7),A
 srl c
 djnz w_setport3
 xor a
 ld (sbyte),a
 ret

Test_ON:
 ld a,(lcounter)
 inc a
 ld (lcounter),a
 cp 255
 ret nz
 pop hl  ;Back to the place you were before.	Gotta love it!
 xor a
 ret

SendTest_ON:
 ld a,(hsflag)
 or a
 jr z,LongWait
 call GET_KEY
 cp $37
 ret nz
 pop hl
 pop hl
 jp Quit
LongWait:
 ld hl,(lcounter)
 inc hl
 ld (lcounter),hl
 ld de,$3FFF
 call CP_HL_DE
 ret nz
 pop hl
 ret
