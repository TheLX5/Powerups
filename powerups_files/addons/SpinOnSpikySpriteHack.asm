ClearStatusRAM:
	lda #$02
	sta $1DF9|!base2

	lda $19
	cmp #!PropSuit_powerup_num
	bne .Rtrn0

	lda #$80
	sta !PropStatus
	lda #$00
	sta !PropStatusTimer
	sta !mask_15
	sta $140D|!base2

.Rtrn0	rtl