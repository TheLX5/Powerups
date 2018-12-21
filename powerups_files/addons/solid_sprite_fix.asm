fix_mini_solid:
	ldy $19
	cpy #!mini_mushroom_powerup_num
	beq .mini
	cpy #$00
	bne .original
.mini	
	jml $01B4C4|!base3
.original
	jml $01B4C6|!base3