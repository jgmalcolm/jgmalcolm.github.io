_asm_exec_ram	=$d748
_ASAPloadmenu	=$49c8
_funcDisp	=$49e8

.org _asm_exec_ram

	ld hl,menu	;the addres of the menu
			; we want displayed
	call _asaploadmenu
			;setup the menu in memory
	jp _funcDisp	;display it and exit to
			; ti-os
menu:
	.db 3		;type - pushable
	.db 16		;slots - 16
			;16 different types of
			; pasting methods
;
;	menu pointers grouped in fives
;	 according to how many are displayed
;	 at a time
;	these point to where the data for
;	 that specific slot is stored
;
first_menu:
	.dw p1_slot
	.dw p2_slot
	.dw p3_slot
	.dw p4_slot
	.dw p5_slot
second_menu:
	.dw p6_slot
	.dw p7_slot
	.dw p8_slot
	.dw p9_slot
	.dw p10_slot
third_menu:
	.dw p11_slot
	.dw p12_slot
	.dw p13_slot
	.dw p14_slot
	.dw p15_slot
fourth_menu:
	.dw p16_slot
;
;	menu slot data
;	format: .db type,"string",$00
p1_slot:		.db $00,"Item",0
p2_slot:		.db $10,"Item",0
p3_slot:		.db $20,"Item",0
p4_slot:		.db $30,"Item",0
p5_slot:		.db $40,"Item",0

p6_slot:		.db $50,"Item",0
p7_slot:		.db $60,"Item",0
p8_slot:		.db $70,"Item",0
p9_slot:		.db $80,"Item",0
p10_slot:		.db $90,"Item",0

p11_slot:		.db $a0,"Item",0
p12_slot:		.db $b0,"Item",0
p13_slot:		.db $c0,"Item",0
p14_slot:		.db $d0,"Item",0
p15_slot:		.db $e0,"Item",0

p16_slot:		.db $f0,"Item",0

.end
